//
//  LFSAdminClient.h
//  LFSClient
//
//  Created by Eugene Scherba on 8/22/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFSBaseClient.h"

@interface LFSAdminClient : LFSBaseClient

/** @name User Authentication */

/**
 * Check a user's token against the auth admin.
 *
 * It is necessary to provide either a collectionId or a siteId combined with an articleId.
 *
 * @param userToken A JWT-encoded token representing a user.
 * @param collectionId The Id of the collection to auth against.
 * @param success   Success callback
 * @param failure   Failure callback
 */

- (void)authenticateUserWithToken:(NSString *)userToken
                       collection:(NSString *)collectionId
                        onSuccess:(LFSSuccessBlock)success
                        onFailure:(LFSFailureBlock)failure;


/**
 * Check a user's token against the auth admin.
 *
 * It is necessary to provide either a collectionId or a siteId combined with an articleId.
 *
 * @param userToken A JWT-encoded token representing a user.
 * @param siteId The Id of the article's site.
 * @param articleId The Id of the collection's article.
 * @param success   Success callback
 * @param failure   Failure callback
 */

- (void)authenticateUserWithToken:(NSString *)userToken
                             site:(NSString *)siteId
                          article:(NSString *)articleId
                        onSuccess:(LFSSuccessBlock)success
                        onFailure:(LFSFailureBlock)failure;

@end
