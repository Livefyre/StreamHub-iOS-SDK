//
//  LFClientBase.m
//  LFClient
//
//  Created by zjj on 1/14/13.
//
//  Copyright (c) 2013 Livefyre
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "LFClientBase.h"

static NSOperationQueue *_LFQueue;

@implementation LFClientBase
//We need our own queue so that our callbacks to do not block the main queue, which executes on the main thread.
//Main thread is main.
+ (NSOperationQueue *)LFQueue
{
    if (!_LFQueue) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _LFQueue = [NSOperationQueue new];
        });
    }
    
    return _LFQueue;
}

+ (void)requestWithHost:(NSString *)host
                   path:(NSString *)path
                payload:(NSString *)payload
                 method:(NSString *)httpMethod
              onSuccess:(void (^)(NSDictionary *res))success
              onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(host != nil);
    NSParameterAssert(path != nil);
    NSParameterAssert(httpMethod != nil);
    
    NSURL *connectionURL = [[NSURL alloc] initWithScheme:kLFSDKScheme host:host path:path];
    NSMutableURLRequest *connectionReq = [[NSMutableURLRequest alloc] initWithURL:connectionURL];
    [connectionReq setHTTPMethod:httpMethod];
    [connectionReq setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
    
    if (payload && [httpMethod isEqualToString:@"POST"]) {
        //strip off our beloved question mark
        payload = [payload substringFromIndex:1];
        [connectionReq setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection sendAsynchronousRequest:connectionReq queue:[self LFQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
        
        NSDictionary *payload = [self handleResponse:resp error:err data:data onFailure:failure];
        if (payload)
            success(payload);
        
        return;
    }];
}

+ (NSDictionary *)handleResponse:(NSURLResponse *)resp
                       error:(NSError *)err
                        data:(NSData *)data
                       onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(resp != nil);
    
    if (err) {
        failure(err);
        return nil;
    }
    
    NSError *JSONerror;
    NSDictionary *payload  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONerror];
    //bad news bears
    if (JSONerror && JSONerror.code == 3840u) {
        payload = [self handleNaNBugWithData:data];
        if (payload)
            return payload;
    }
    
    if (JSONerror) {
        failure(JSONerror);
        return nil;
    }
    
    if (!payload) {
        NSError *noDataErr = [[NSError alloc] initWithDomain:kLFError
                                                            code:0
                                                        userInfo:[NSDictionary dictionaryWithObject:@"Response failed to return data."
                                                                                             forKey:NSLocalizedDescriptionKey]];
        failure(noDataErr);
        return nil;
    }
    
    //reported errors are reported
    if ([payload objectForKey:@"code"] && ![[payload objectForKey:@"code"] isEqualToNumber:@200]) {
        err = [NSError errorWithDomain:kLFError
                                  code:[[payload objectForKey:@"code"] integerValue]
                              userInfo:[NSDictionary dictionaryWithObject:[payload objectForKey:@"msg"]
                                                                   forKey:NSLocalizedDescriptionKey]];
        failure(err);
        return nil;
    }
    
    return payload;
}

// When the heat index pipes down floats exceeding 1.0e-128, NSJSONSerialization does not parse them as doubles and throws an exception. We hack around this.
// TODO optimize
+ (NSDictionary *)handleNaNBugWithData:(NSData *)data
{
    NSError *regexError;
    NSRegularExpression *scientificNotationRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+.\\d+e-.\\d+)" options:kNilOptions error:&regexError];
    if (regexError)
        return nil;
    
    //convert the JSON blob to a string
    NSMutableString *responseString = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *matches = [scientificNotationRegex matchesInString:responseString options:kNilOptions range:NSMakeRange(0, [responseString length])];
    if (!matches.count)
        //different problem
        return nil;
    
    //find the offensive numbers
    NSMutableArray *replacements = [NSMutableArray new];
    for (NSTextCheckingResult *match in matches) {
        NSString *subString = [responseString substringWithRange:[match range]];
        [replacements addObject:subString];
    }
    
    //replace the offensive numbers with innocuous placeholders
    for (int i = 0; i < replacements.count; i++) {
        NSString *rememberReplacement = [NSString stringWithFormat:@"\"placeHolderAtIndex%d\"", i];
        responseString = [[responseString stringByReplacingOccurrencesOfString:[replacements objectAtIndex:i] withString:rememberReplacement] copy];
    }
    
    //safely convert JSON to Dictionary
    NSData *JSONData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *JSONerror;
    NSMutableDictionary *payload  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&JSONerror];
    if (JSONerror)
        return nil;
    
    NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //re-add the offensive numbers
    NSUInteger i = 0;
    for (NSDictionary *result in [[payload objectForKey:@"data"] copy]) {
        NSString *heat = [result objectForKey:@"heat"];
        if ([heat respondsToSelector:@selector(hasPrefix:)] && [[result objectForKey:@"heat"] hasPrefix:@"placeHolderAtIndex"]) {
            NSString *index = [heat stringByTrimmingCharactersInSet:letters];
            NSString *scientificNotation = [replacements objectAtIndex:[index doubleValue]];
            NSNumber *offensiveNum = [numFormatter numberFromString:scientificNotation];
            //everything is getting complicated
            [[[payload objectForKey:@"data"] objectAtIndex:i] setValue:offensiveNum forKey:@"heat"];
        }
        i++;
    }

    return [NSDictionary dictionaryWithDictionary:payload];
}
@end
