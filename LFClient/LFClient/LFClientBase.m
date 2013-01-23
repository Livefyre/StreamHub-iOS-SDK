//
//  LFClientBase.m
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

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
               WithPath:(NSString *)path
            WithPayload:(NSString *)payload
             WithMethod:(NSString *)httpMethod
            WithSuccess:(void (^)(NSDictionary *res))success
            WithFailure:(void (^)(NSError *))failure
{
    NSURL *connectionURL = [[NSURL alloc] initWithScheme:kLFSDKScheme host:host path:path];
    NSMutableURLRequest *connectionReq = [[NSMutableURLRequest alloc] initWithURL:connectionURL];
    [connectionReq setHTTPMethod:httpMethod];
    
    if (payload && [httpMethod isEqualToString:@"POST"]) {
        //strip off our beloved question mark
        payload = [payload substringFromIndex:1];
        [connectionReq setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection sendAsynchronousRequest:connectionReq queue:[self LFQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
        
        NSDictionary *payload = [self handleResponse:resp WithError:err WithData:data WithFailure:failure];
        if (payload)
            success(payload);
        
        return;
    }];
}

+ (NSDictionary *)handleResponse:(NSURLResponse *)resp
                       WithError:(NSError *)err
                        WithData:(NSData *)data
                     WithFailure:(void (^)(NSError *))failure
{
    if (err) {
        failure(err);
        return nil;
    }
    
    //TODO, handle NaN bug.
    NSError *JSONerror;
    NSDictionary *payload  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONerror];
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
@end
