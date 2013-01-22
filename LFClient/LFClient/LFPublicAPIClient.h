//
//  LFPublicAPIClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFClientBase.h"

@interface LFPublicAPIClient : LFClientBase
/// @name Heat Index Trends

/// Polls for trending Collections
/// @param tag (optional) Tag to filter on.
/// @param siteId (optional) Site ID to filter on.
/// @param networkDomain The network to query on, identified by domain, i.e. livefyre.com.
/// @param results (optional) Number of results to be returned. The default is 10 and the maximum is 100.
/// @param success (optional) Callback called with a dictionary of results. Only technically optional.
/// @param failure (optional) Callback called with error on a failure to retrieve data.
///
/// This method hands to the callback an array of HotCollection objects.
/// For more information see:
/// https://github.com/Livefyre/livefyre-docs/wiki/Trending-Collection-API
+ (void)getTrendingCollectionsForTag:(NSString *)tag
                              inSite:(NSString *)siteId
                           onNetwork:(NSString *)networkDomain
                      desiredResults:(NSUInteger)number
                             success:(void (^)(NSArray *results))success
                             failure:(void (^)(NSError *error))failure;
/// @name User Information

/// Pulls the user's content history
/// @param userId The Id of the user whose content is to be fetched.
/// @param userToken (optional) The token of the user whose content is to be fetch, required by default unless the Newtwork specifies otherwise.
/// @param status (optional) CSV of comment states to return.
/// @param offset (optional) Number of results to skip. Defaults to 0, 25 pieces of content are returned at a time.
/// @param success (optional) Callback called with a dictionary of results.
/// @param failure (optional) Callback called with error on a failure to retrieve data.
///
/// This method hands to the callback an array of UserContent objects.
/// For more information see:
/// https://github.com/Livefyre/livefyre-docs/wiki/User-Content-API
+ (void)getUserContentForUser:(NSString *)userId
                    withToken:(NSString *)userToken
                    onNetwork:(NSString *)networkDomain
                  forStatuses:(NSArray *)statuses
                   withOffset:(NSNumber *)offset
                      success:(void (^)(NSArray *results))success
                      failure:(void (^)(NSError *error))failure;
@end
