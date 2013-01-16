//
//  LFAdminClient.m
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFAdminClient.h"
#import "NSString+QueryString.h"
#import "NSString+Base64Encoding.h"

static NSString *_admin = @"admin";

@implementation LFAdminClient
+ (void)authenticateUserWithToken:(NSString *)userToken
                          forSite:(NSString *)siteId
                       forArticle:(NSString *)articleId
                    forCollection:(NSString *)collectionId
                        onNetwork:(NSString *)networkDomain
                          success:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *))failure
{
    NSDictionary *paramsDict;
    if (collectionId) {
        paramsDict = [NSDictionary dictionaryWithObjects:@[collectionId, userToken] forKeys:@[@"collectionId", @"lftoken"]];
    } else {
        articleId = [articleId base64EncodedString];
        paramsDict = [NSDictionary dictionaryWithObjects:@[siteId, articleId, userToken] forKeys:@[@"siteId", @"articleId", @"lftoken"]];
    }
    
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", _admin, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/auth/%@", queryString];
    
    [self requestWithHost:host
                 WithPath:path
               WithMethod:@"GET"
              WithSuccess:success
              WithFailure:failure];
}
@end
