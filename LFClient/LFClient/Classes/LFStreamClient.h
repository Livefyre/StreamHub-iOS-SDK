//
//  LFStreamClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//
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
 * Stop polling happens asynchronously and so there is no gaurantee when it will stop,
 * only that it will stop before the next server call.
 *
 * @param collectionId
 * @return void The collection to stop polling for updates.
 */
- (void)stopStreamForCollection:(NSString *)collectionId;

/**
 * Get the currently streaming collections on this StreamClient
 *
 * @return NSArray
 */
- (NSArray *)getStreamingCollections;
@end
