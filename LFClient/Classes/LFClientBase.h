//
//  LFClientBase.h
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

#import <Foundation/Foundation.h>
#import "LFConstants.h"

@interface LFClientBase : NSObject
// Returns the queue for handling our callback blocks.
+ (NSOperationQueue *)LFQueue;

// Sends an asynchronous request to the specified resource.
+ (void)requestWithHost:(NSString *)host
                   path:(NSString *)path
                payload:(NSString *)payload
                 method:(NSString *)httpMethod
              onSuccess:(void (^)(NSDictionary *res))success
              onFailure:(void (^)(NSError *))failure;

// Generic handling of HTTP responses, 
// handling error reporting and JSON parsing.
+ (NSDictionary *)handleResponse:(NSURLResponse *)resp
                           error:(NSError *)err
                            data:(NSData *)data
                       onFailure:(void (^)(NSError *))failure;
@end
