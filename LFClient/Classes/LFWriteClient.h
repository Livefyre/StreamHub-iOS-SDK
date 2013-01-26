//
//  LFWriteClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LFConstants.h"
#import "LFClientBase.h"

@interface LFWriteClient : LFClientBase
/** @name Content Interaction */

/**
 * Like a comment in a collection.
 *
 * The comment must be in a collection the user is authenticated for and it must have been posted by a
 * different user. Trying to like things other than comments may have odd results.
 *
 * @param contentId The content to like
 * @param userToken The lftoken of the user responsible for this madness(interaction).
 * @param collectionId The collection in which the content appears.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @param success Callback called with a dictionary after the content has
 * been liked.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)likeContent:(NSString *)contentId
            forUser:(NSString *)userToken
       inCollection:(NSString *)collectionId
          onNetwork:(NSString *)networkDomain
            success:(void (^)(NSDictionary *content))success
            failure:(void (^)(NSError *error))failure;

/**
 * Unlike a comment in a collection.
 *
 * The comment must be in a collection the user is authenticated for and it must have been posted by a
 * different user. Trying to unlike things other than comments may have odd results.
 *
 * @param contentId The content to unlike
 * @param userToken The lftoken of the user responsible for this madness(interaction).
 * @param collectionId The collection in which the content appears.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @param success Callback called with a dictionary after the content has
 * been unliked.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)unlikeContent:(NSString *)contentId
              forUser:(NSString *)userToken
         inCollection:(NSString *)collectionId
            onNetwork:(NSString *)networkDomain
              success:(void (^)(NSDictionary *content))success
              failure:(void (^)(NSError *error))failure;

/**
 * Create a new comment in a collection.
 *
 * Creating new posts requires that the user has permission to post in the collection.
 *
 * @param body HTML body of the new post.
 * @param userToken The lftoken of the user responsible for this madness(interaction).
 * @param parentId (optional) The post that this is a response to, if applicable.
 * @param collectionId Collection to add the post to.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @param success Callback called with a dictionary once the content has
 * been interacted.
 * @param failure Callback called with error on a failure to retrieve data.
 * @return void
 */
+ (void)postContent:(NSString *)body
            forUser:(NSString *)userToken
          inReplyTo:(NSString *)parentId
       inCollection:(NSString *)collectionId
          onNetwork:(NSString *)networkDomain
            success:(void (^)(NSDictionary *content))success
            failure:(void (^)(NSError *error))failure;
@end
