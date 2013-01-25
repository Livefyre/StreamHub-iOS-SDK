//
//  LFPublicAPIClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LFConstants.h"
#import "LFClientBase.h"

@interface LFPublicAPIClient : LFClientBase
/** @name Heat Index Trends */

/**
 * Polls for trending Collections
 *
 * For more information see:
 * https://github.com/Livefyre/livefyre-docs/wiki/Trending-Collection-API
 *
 * @param tag (optional) Tag to filter on.
 * @param siteId (optional) Site ID to filter on.
 * @param networkDomain The network to query against as identified by domain, i.e. livefyre.com.
 * @param numberOfResults (optional) Number of results to be returned. The default is 10 and the maximum is 100.
 * @param success Callback called with a dictionary after the results data has
 * been retrieved.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)getTrendingCollectionsForTag:(NSString *)tag
                             forSite:(NSString *)siteId
                           onNetwork:(NSString *)networkDomain
                      desiredResults:(NSUInteger)numberOfResults
                             success:(void (^)(NSArray *results))success
                             failure:(void (^)(NSError *error))failure;
                             
/** @name User Information */

/**
 * Fetches the user's content history
 *
 * For more information see:
 * https://github.com/Livefyre/livefyre-docs/wiki/User-Content-API
 *
 * @param userId The Id of the user whose content is to be fetched.
 * @param userToken (optional) The lftoken of the user whose content is to be fetched. This parameter is required by default unless the network specifies otherwise.
 * @param networkDomain The network to query agianst as identified by domain, i.e. livefyre.com.
 * @param status (optional) CSV of comment states to return.
 * @param offset (optional) Number of results to skip, defaults to 0. 25 items are returned at a time.
 * @param success Callback called with a dictionary after the results data has
 * been retrieved.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)getUserContentForUser:(NSString *)userId
                    withToken:(NSString *)userToken
                    onNetwork:(NSString *)networkDomain
                  forStatuses:(NSArray *)statuses
                   withOffset:(NSNumber *)offset
                      success:(void (^)(NSArray *results))success
                      failure:(void (^)(NSError *error))failure;
@end
