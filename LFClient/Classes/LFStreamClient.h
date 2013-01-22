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
 * Start polling for updates made to the contents of a collection. 
 *
 * @param collectionId The collection to start polling for updates.
 * @param eventId The event identifier of the most recent content that is represented locally.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @param success Callback called with a dictionary after new content has been recieved.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
- (void)startStreamForCollection:(NSString *)collectionId
                       fromEvent:(NSString *)eventId
                       onNetwork:(NSString *)networkDomain
                         success:(void (^)(NSDictionary *updates))success
                         failure:(void (^)(NSError *error))failure;

/**
 * Stop polling for updates made to the contents of a collection.
 *
 * Stopping the stream happens asynchronously and so there is no gaurantee when it will stop,
 * only that it will stop before the next server call.
 *
 * @param collectionId The collection to stop polling for updates.
 * @return void 
 */
- (void)stopStreamForCollection:(NSString *)collectionId;

/**
 * Get the currently streaming collections on this StreamClient
 *
 * @return NSArray
 */
- (NSArray *)getStreamingCollections;
@end
