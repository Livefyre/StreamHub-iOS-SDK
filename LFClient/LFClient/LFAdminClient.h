//
//  LFAdminClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

@interface LFAdminClient : LFClientBase
/** @name User Authentication */

/** 
 * Check a user's token against the auth admin.
 *
 * It is necessary to provide either a collectionId or a siteId combined with an articleId.
 *
 * @param userToken The lftoken representing a user.
 * @param collectionId (optional) The Id of the collection to auth against.
 * @param articleId (optional) The Id of the collection's article.
 * @param siteId (optional) The Id of the article's site.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @param success Callback called with a dictionary after the user data has
 * been retrieved.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)authenticateUserWithToken:(NSString *)userToken
                    forCollection:(NSString *)collectionId
                       forArticle:(NSString *)articleId
                          forSite:(NSString *)siteId
                        onNetwork:(NSString *)networkDomain
                          success:(void (^)(NSDictionary *userData))success
                          failure:(void (^)(NSError *error))failure;
@end
