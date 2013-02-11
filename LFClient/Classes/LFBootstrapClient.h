//
//  LFBootstrapClient.h
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

@interface LFBootstrapClient : LFClientBase
/** @name Collection Initialization */

/**
 * Get the initial bootstrap data for a collection.
 * 
 * For more information see:
 * https://github.com/Livefyre/livefyre-docs/wiki/StreamHub-API-Reference#wiki-init
 *
 * @param articleId The Id of the collection's article.
 * @param siteId The Id of the article's site.
 * @param networkDomain The collection's network as identified by domain, i.e. livefyre.com.
 * @param environment (optional) Where the collection is hosted, i.e. t-402. Used for development/testing purposes.
 * @param success Callback called with a dictionary after the init data has
 * been retrieved.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)getInitForArticle:(NSString *)articleId
                     site:(NSString *)siteId
                  network:(NSString *)networkDomain
              environment:(NSString *)environment
                onSuccess:(void (^)(NSDictionary *initInfo))success
                onFailure:(void (^)(NSError *error))failure;

/** @name Content Retrieval */

/**
 * The init data for a collection contains information about that collection's number of pages and where to fetch the content for those pages.
 * 
 * @param pageIndex The page to fetch content for. The pages are numbered from zero. If the page index provided is outside the bounds of what the init data knows about the error callback will convey that failure.
 * @param initInfo A pointer to a bootstrap's init data as returned by the bootstrap init endpoint and parsed from JSON into a dictionary.
 * @param success Callback called with a dictionary represting the pages content.
 * @param failure Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)getContentForPage:(NSUInteger) pageIndex
             withInitInfo:(NSDictionary *)initInfo
                onSuccess:(void (^)(NSDictionary *contentInfo))success
                onFailure:(void (^)(NSError *error))failure;
@end
