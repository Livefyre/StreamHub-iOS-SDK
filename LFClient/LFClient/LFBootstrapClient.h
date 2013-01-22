//
//  LFBootstrapClient.h
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFClientBase.h"

@interface LFBootstrapClient : LFClientBase
/// @name Collection Retrieval

/// Get the collection of comments for an article.
/// @param articleId The Id of the article to get the collection for.
/// @param siteId The Id of the site the article is in.
/// @param networkDomain The collection's network, identified by domain, i.e. livefyre.com.
/// @param environment (optional) Where the collection is hosted, i.e. t-402. Likekly used for developement purposes. 
/// @param success (optional) Callback called with a dictionary once the init data has
/// been retrieved.
/// @param failure (optional) Callback called with error on a failure to retrieve data.
///
+ (void)getInitForArticle:(NSString *)articleId
                   inSite:(NSString *)siteId
              withNetwork:(NSString *)networkDomain
          withEnvironment:(NSString *)environment
                  success:(void (^)(NSDictionary *collection))success
                  failure:(void (^)(NSError *error))failure;
@end
