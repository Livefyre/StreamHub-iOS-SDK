//
//  LFBootstrapClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//
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
 * @param success (optional) Callback called with a dictionary after the init data has
 * been retrieved.
 * @param failure (optional) Callback called with an error after a failure to retrieve data.
 * @return void
 */
+ (void)getInitForArticle:(NSString *)articleId
                  forSite:(NSString *)siteId
                onNetwork:(NSString *)networkDomain
          withEnvironment:(NSString *)environment
                  success:(void (^)(NSDictionary *initData))success
                  failure:(void (^)(NSError *error))failure;
@end
