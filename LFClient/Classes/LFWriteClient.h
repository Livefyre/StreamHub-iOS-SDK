//
//  LFWriteClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//
//  Copyright (c) 2013 Livefyre
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

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
         collection:(NSString *)collectionId
            network:(NSString *)networkDomain
          onSuccess:(void (^)(NSDictionary *content))success
          onFailure:(void (^)(NSError *error))failure;

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
           collection:(NSString *)collectionId
              network:(NSString *)networkDomain
            onSuccess:(void (^)(NSDictionary *content))success
            onFailure:(void (^)(NSError *error))failure;

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
      forCollection:(NSString *)collectionId
            network:(NSString *)networkDomain
          onSuccess:(void (^)(NSDictionary *content))success
          onFailure:(void (^)(NSError *error))failure;

/**
 * Flag content with one of the flag types.
 *
 * @param contentId The is of the content to flag.
 * @param collectionId The Id of the collection where the content appears.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @param flagType The flagging action.
 * @param userToken The user that is taking the flagging action.
 * @param notes (optional) Any additional comment the user provided.
 * @param email (optional) The email of the user.
 * @param success Callback called with a dictionary after the flag was successfully acknowledged.
 * @param failure Callback called with an error after a failure to post data.
 * @return void
 */
+ (void)flagContent:(NSString *)contentId
      forCollection:(NSString *)collectionId
            network:(NSString *)networkDomain
           withFlag:(FlagType)flagType
               user:(NSString *)userToken
              notes:(NSString *)notes
              email:(NSString *)email
          onSuccess:(void (^)(NSDictionary *opineData))success
          onFailure:(void (^)(NSError *error))failure;
@end
