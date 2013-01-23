//
//  LFBootstrapClient.m
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFBootstrapClient.h"
#import "NSString+Base64Encoding.h"

static NSString *_bootstrap = @"bootstrap";

@implementation LFBootstrapClient
+ (void)getInitForArticle:(NSString *)articleId
                  forSite:(NSString *)siteId
                onNetwork:(NSString *)networkDomain
          withEnvironment:(NSString *)environment
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failure
{
    // https://github.com/Livefyre/livefyre-docs/wiki/StreamHub-API-Reference#wiki-init
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", _bootstrap, networkDomain];
    NSString *path;
    if (environment) {
        path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/%@/init", environment, networkDomain, siteId, [articleId base64EncodedString]];
    } else {
        path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/init", networkDomain, siteId, [articleId base64EncodedString]];
    }
    
    [self requestWithHost:host
                 WithPath:path
              WithPayload:nil
               WithMethod:@"GET"
              WithSuccess:success
              WithFailure:failure];
}
@end