//
//  LFClientBase.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFClientBase : NSObject
// Returns the queue for handling our callback blocks.
+ (NSOperationQueue *)LFQueue;

// Sends an asynchronous request to the specified resource.
+ (void)requestWithHost:(NSString *)host
               WithPath:(NSString *)path
            WithPayload:(NSString *)payload
             WithMethod:(NSString *)httpMethod
            WithSuccess:(void (^)(NSDictionary *res))success
            WithFailure:(void (^)(NSError *))failure;

// Generic handling of HTTP responses, 
// handling error reporting and JSON parsing.
+ (NSDictionary *)handleResponse:(NSURLResponse *)resp
                       WithError:(NSError *)err
                        WithData:(NSData *)data
                     WithFailure:(void (^)(NSError *))failure;
@end
