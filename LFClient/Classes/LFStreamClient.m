//
//  LFStreamClient.m
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

#import "LFStreamClient.h"

@implementation LFStreamClient
+ (NSString *)buildStreamEndpointForCollection:(NSString *)collectionId
                                       network:(NSString *)networkDomain
{
    NSParameterAssert(collectionId != nil);
    NSParameterAssert(networkDomain != nil);
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", kStreamDomain, networkDomain];
    NSString *eventlessPath = [NSString stringWithFormat:@"/v3.0/collection/%@/", collectionId];
    return [NSString stringWithFormat:@"%@://%@%@", kLFSDKScheme, host, eventlessPath];
}

+ (NSDictionary *)pollStreamEndpoint:(NSString *)endpoint
                               event:(NSString *)eventId
                             timeout:(NSError *__autoreleasing *)timeout
                               error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(eventId != nil);
    NSParameterAssert(endpoint != nil);
    
    NSString *eventedEndpoint = [endpoint stringByAppendingString:eventId];
    NSURL *connectionURL = [[NSURL alloc] initWithString:eventedEndpoint];
    NSURLRequest *streamReq = [NSURLRequest requestWithURL:connectionURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:65.0];
    NSURLResponse *resp;
    NSError *requestError;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:streamReq returningResponse:&resp error:&requestError];
    //wait
    NSDictionary *payload = [LFClientBase handleResponse:resp error:requestError data:data onFailure:^(NSError *failError) {
        if (failError)
            // Lots of errors being juggled, the flow is this: requestError-> failError -> paramError.
            *error = failError;
    }];
    if (payload && [payload objectForKey:@"timeout"]) {
        *timeout = [NSError errorWithDomain:kLFError code:408u userInfo:[NSDictionary dictionaryWithObject:@"Request timed out."
                                                                                                    forKey:NSLocalizedDescriptionKey]];
    }
    if (payload && [payload objectForKey:@"data"])
        return payload;
    
    return nil;
}
@end
