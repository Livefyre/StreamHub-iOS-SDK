//
//  LFWriteClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFClientBase.h"

@interface LFWriteClient : LFClientBase
/// @name Content Interaction

/// Like a post in a collection.
/// @param contentId The content to like
/// @param userToken The lftoken of the user responsible for this madness(interaction).
/// @param collectionId The collection in which the content appears.
/// @param networkDomain The network in which the collection exists.
/// @param success (optional) Callback called with a dictionary once the content has
/// been interacted.
/// @param failure (optional) Callback called with error on a failure to retrieve data.
///
/// The post must be from a logged-in user's Collection and posted by a
/// different user.
///
/// Trying to Like things other than Posts may have odd results.
+ (void)likeContent:(NSString *)contentId
            forUser:(NSString *)userToken
       inCollection:(NSString *)collectionId
          onNetwork:(NSString *)networkDomain
            success:(void (^)(NSDictionary *content))success
            failure:(void (^)(NSError *error))failure;

/// Unlike a post in a collection.
/// @param contentId The content to unlike.
/// @param userToken The lftoken of the user responsible for this madness(interaction).
/// @param collectionId The collection in which the content appears.
/// @param networkDomain The network in which the collection exists.
/// @param success (optional) Callback called with a dictionary once the content has
/// been interacted.
/// @param failure (optional) Callback called with error on a failure to retrieve data.
///
+ (void)unlikeContent:(NSString *)contentId
              forUser:(NSString *)userToken
         inCollection:(NSString *)collectionId
            onNetwork:(NSString *)networkDomain
              success:(void (^)(NSDictionary *content))success
              failure:(void (^)(NSError *error))failure;

/// Create a new top-level post in a collection.
/// @param body HTML body of the new post.
/// @param userToken The lftoken of the user responsible for this madness(interaction).
/// @param parentId (optional) The post that this is a response to, if applicable.
/// @param shareTos (optional) Where the post will be shared to.
/// @param collectionId Collection to add the post to.
/// @param success (optional) Callback called with a dictionary once the content has
/// been interacted.
/// @param failure (optional) Callback called with error on a failure to retrieve data.
///
/// Creating new posts requires that the Collection was created with a
/// logged-in user who has permission to post in the collection.
+ (void)postContent:(NSString *)body
            forUser:(NSString *)userToken
          inReplyTo:(NSString *)parentId
       inCollection:(NSString *)collectionId
          onNetwork:(NSString *)networkDomain
            success:(void (^)(NSDictionary *content))success
            failure:(void (^)(NSError *error))failure;


@end
