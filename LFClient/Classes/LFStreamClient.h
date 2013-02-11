//
//  LFStreamClient.h
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
#import "LFClientBase.h"

@interface LFStreamClient : LFClientBase
/**
 * For successive polls, we want to build the stream endpoint once and only update the eventId going forward.
 *
 * @param collectionId The collection to stream for.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @return NSString The endpoint to poll for stream data.
 */
+ (NSString *)buildStreamEndpointForCollection:(NSString *)collectionId
                                       network:(NSString *)networkDomain;

/**
 * Long poll for updates made to the contents of a collection.
 *
 * Executed synchronously, do not call directly! Also note that a general error is differentiated from a timeout, though both set an error flag. Requests will keep the connection open for about a minute before giving up and setting a timeout.
 * @param endpoint The streaming HTTP resource.
 * @param eventId The most recently recieved event head for this stream.
 * @return NSDictionary The updated eventId of the stream.
 */
+ (NSDictionary *)pollStreamEndpoint:(NSString *)endpoint
                               event:(NSString *)eventId
                             timeout:(NSError **)timeout
                               error:(NSError **) error;
@end
