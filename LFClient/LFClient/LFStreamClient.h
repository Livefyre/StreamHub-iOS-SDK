//
//  LFStreamClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFClientBase.h"

@interface LFStreamClient : LFClientBase
/// Start polling for updates made to the contents of a Collection.
/// @param collectionId Collection to start polling for updates.
/// @param event Last event to search for new content from.
/// @param networkDomain The network the collection resides in.
/// @param callback Callback to call when new data arrives.
/// @param success Callback called with new content.
/// @param failure Callback called with error on a failure to retrieve data.
///
- (void)startStreamForCollection:(NSString *)collectionId
                                   fromEvent:(NSString *)eventId
                                   onNetwork:(NSString *)networkDomain
                                     success:(void (^)(NSDictionary *updates))success
                                     failure:(void (^)(NSError *error))failure;

- (void)stopStreamForCollection:(NSString *)collectionId;
@end
