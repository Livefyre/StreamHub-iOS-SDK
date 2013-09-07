//
//  LFSWriteClient.h
//  LFSClient
//
//  Created by Eugene Scherba on 8/22/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFSBaseClient.h"

@interface LFSWriteClient : LFSBaseClient
/** @name Content Interaction */

/**
 * Like (or unlike) a comment in a collection.
 *
 * The comment must be in a collection the user is authenticated for and it must have been posted by a
 * different user. Trying to like things other than comments may have odd results.
 *
 * @param action       One of the following: LFSOpinionLike, LFSOpinionUnlike
 * @param userToken    JWT-encoded user token
 * @param contentId    id of content which is being liked/unliked
 * @param collectionId The collection in which the content appears.
 * @param success      Success callback
 * @param failure      Failure callback
 * @return void
 */
- (void)postOpinion:(LFSOpinion)action
            forUser:(NSString *)userToken
         forContent:(NSString *)contentId
       inCollection:(NSString *)collectionId
          onSuccess:(LFSSuccessBlock)success
          onFailure:(LFSFailureBlock)failure;

/**
 * Flag content with one of the flag types.
 *
 * @param flag         One of the following: LFSFlagOffensive, LFSFlagSpam, LFSFlagDisagree, LFSFlagOfftopic
 * @param userToken    JWT-encoded user token
 * @param contentId    The is of the content to flag.
 * @param collectionId The Id of the collection where the content appears.
 * @param parameters (optional)   Dictionary containing optional parameters:
 *        @"notes" (optional) Any additional comment the user provided.
 *        @"email" (optional) The email of the user.
 * @param success      Success callback
 * @param failure      Failure callback
 * @return void
 */
- (void)postFlag:(LFSUserFlag)flag
         forUser:(NSString *)userToken
      forContent:(NSString *)contentId
    inCollection:(NSString *)collectionId
      parameters:(NSDictionary *)parameters
       onSuccess:(LFSSuccessBlock)success
       onFailure:(LFSFailureBlock)failure;

/**
 * Create a new comment in a collection.
 *
 * Creating new posts requires that the user has permission to post in the collection.
 *
 * @param body HTML body of the new post.
 * @param userToken JWT-encoded user token
 * @param collectionId Collection to add the post to.
 * @param parentId (optional) The post that this is a response to, if applicable.
 * @param success Success callback
 * @param failure Failure callback
 * @return void
 */
- (void)postNewContent:(NSString *)body
               forUser:(NSString *)userToken
         forCollection:(NSString *)collectionId
             inReplyTo:(NSString *)parentId
             onSuccess:(LFSSuccessBlock)success
             onFailure:(LFSFailureBlock)failure;

/**
 * Create a new collection.
 *
 * "signed" create has secretSiteKey that is non-nil
 *
 * @param articleId User-assigned article Id that will (together with
 *                  existing site Id) correspond to the newly created collection
 * @param siteId    site Id
 * @param secretSiteKey (optional) Site Key to sign JWT token with
 *                  If nil, so-called "unsigned collection creation" will take place
 * @param title     User-provided title (up to 255 characters)
 * @param tagArray  User-assigned Tag array
 * @param success   Success callback
 * @param failure   Failure callback
 * @return void
 */
- (void)postNewArticle:(NSString *)articleId
               forSite:(NSString *)siteId
         secretSiteKey:(NSString *)secretSiteKey
                 title:(NSString *)title
                  tags:(NSArray *)tagArray
               withURL:(NSURL *)newURL
             onSuccess:(LFSSuccessBlock)success
             onFailure:(LFSFailureBlock)failure;

@end
