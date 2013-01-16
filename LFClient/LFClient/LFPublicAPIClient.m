//
//  LFPublicAPIClient.m
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFPublicAPIClient.h"
#import "NSString+QueryString.h"
#import "LFConstants.h"

static NSString *_bootstrap = @"bootstrap";

@implementation LFPublicAPIClient
+ (void)getTrendingCollectionsForTag:(NSString *)tag
                              inSite:(NSString *)siteId
                           onNetwork:(NSString *)networkDomain
                      desiredResults:(NSUInteger)number
                             success:(void (^)(NSArray *))success
                             failure:(void (^)(NSError *))failure
{
    // https://github.com/Livefyre/livefyre-docs/wiki/Hottest-Collection-API
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    if (tag)
        [paramsDict setObject:tag forKey:@"tag"];
    if (siteId)
        [paramsDict setObject:siteId forKey:@"site"];
    if (number)
        [paramsDict setObject:[NSString stringWithFormat:@"%d", number] forKey:@"number"];
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", _bootstrap, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/hottest/%@", queryString];
    
    [self requestWithHost:host
                 WithPath:path
               WithMethod:@"GET"
              WithSuccess:^(NSDictionary *res) {
                  NSArray *results = [res objectForKey:@"data"];
                  if (results)
                      success(results);
              }
              WithFailure:failure];
}

+ (void)getUserContentForUser:(NSString *)userId
                    withToken:(NSString *)userToken
                    onNetwork:(NSString *)networkDomain
                  forStatuses:(NSArray *)statuses
                   withOffset:(NSNumber *)offset
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSError *))failure
{
    //https://github.com/Livefyre/livefyre-docs/wiki/User-Content-API
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (userToken)
        [params setObject:userToken forKey:@"lftoken"];
    if (statuses)
        [params setObject:[statuses componentsJoinedByString:@","] forKey:@"status"];
    if (offset)
        [params setObject:[offset stringValue] forKey:@"offset"];
    NSString *queryString = [[NSString alloc] initWithParams:params];
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", _bootstrap, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/author/%@/comments/%@", userId, queryString];
    
    [self requestWithHost:host
                 WithPath:path
               WithMethod:@"GET"
              WithSuccess:^(NSDictionary *res) {
                  NSArray *results = [res objectForKey:@"data"];
                  if (results)
                      success(results);
              }
              WithFailure:failure];
}
@end
