//
//  LFAdminClient.h
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
//
#import <Foundation/Foundation.h>
#import "LFConstants.h"
#import "LFClientBase.h"

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
                          article:(NSString *)articleId
                             site:(NSString *)siteId
                          network:(NSString *)networkDomain
                        onSuccess:(void (^)(NSDictionary *userData))success
                        onFailure:(void (^)(NSError *error))failure;
@end
