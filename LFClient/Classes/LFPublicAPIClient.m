//
//  LFPublicAPIClient.m
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

#import "LFPublicAPIClient.h"
#import "NSDictionary+QueryString.h"

@implementation LFPublicAPIClient
+ (void)getHottestCollectionsForTag:(NSString *)tag
                               site:(NSString *)siteId
                            network:(NSString *)networkDomain
                     desiredResults:(NSUInteger)number
                          onSuccess:(void (^)(NSArray *))success
                          onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(networkDomain != nil);
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    if (tag)
        [paramsDict setObject:tag forKey:@"tag"];
    if (siteId)
        [paramsDict setObject:siteId forKey:@"site"];
    if (number)
        [paramsDict setObject:[NSString stringWithFormat:@"%d", number] forKey:@"number"];
    NSString *queryString = [paramsDict queryString];
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", kBootstrapDomain, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/hottest/?%@", queryString];
    
    [self requestWithHost:host
                 path:path
              payload:nil
               method:@"GET"
            onSuccess:^(NSDictionary *res) {
                  NSArray *results = [res objectForKey:@"data"];
                  if (results)
                      success(results);
              }
            onFailure:failure];
}
 
+ (void)getUserContentForUser:(NSString *)userId
                    withToken:(NSString *)userToken
                   forNetwork:(NSString *)networkDomain
                     statuses:(NSArray *)statuses
                       offset:(NSNumber *)offset
                    onSuccess:(void (^)(NSArray *))success
                    onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(networkDomain != nil);
    NSParameterAssert(userId != nil);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (userToken)
        [params setObject:userToken forKey:@"lftoken"];
    if (statuses)
        [params setObject:[statuses componentsJoinedByString:@","] forKey:@"status"];
    if (offset)
        [params setObject:[offset stringValue] forKey:@"offset"];
    NSString *queryString = [params queryString];
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", kBootstrapDomain, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/author/%@/comments/?%@", userId, queryString];
    
    [self requestWithHost:host
                 path:path
              payload:nil
               method:@"GET"
            onSuccess:^(NSDictionary *res) {
                  NSArray *results = [res objectForKey:@"data"];
                  if (results)
                      success(results);
              }
            onFailure:failure];
}
@end
