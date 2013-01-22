//
//  LFAdminClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFClientBase.h"

@interface LFAdminClient : LFClientBase
/// @name User Authentication

/// Check a user's token against the auth backend.
/// @param userToken The lftoken representing a valid user.
/// @param siteId (optional) The ID of the site the collection is in.
/// @param articleId (optional) The ID of the article the collection is in.
/// @param collectionId (optional) The ID of the collection to auth for. 
/// @param success Callback called with a dictionary once the user data has
/// been retrieved.
/// @param failure Callback called with error on a failure to retrieve data.
///
/// It is necessary to provide either a collectionId OR a siteId and an articleId, but not all 3.
+ (void)authenticateUserWithToken:(NSString *)userToken
                          forSite:(NSString *)siteId
                       forArticle:(NSString *)articleId
                    forCollection:(NSString *)collectionId
                        onNetwork:(NSString *)networkDomain
                          success:(void (^)(NSDictionary *gotUserData))success
                          failure:(void (^)(NSError *error))failure;
@end
