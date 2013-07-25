//
//  LFWriteClient.m
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

#import "LFWriteClient.h"
#import "NSString+QueryString.h"

@implementation LFWriteClient
+ (void)likeContent:(NSString *)contentId
            forUser:(NSString *)userToken
         collection:(NSString *)collectionId
            network:(NSString *)networkDomain
          onSuccess:(void (^)(NSDictionary *))success
          onFailure:(void (^)(NSError *))failure
{
    [self likeOrUnlikeContent:contentId forUser:userToken collection:collectionId network:networkDomain action:@"like" onSuccess:success onFailure:failure];
}

+ (void)unlikeContent:(NSString *)contentId
              forUser:(NSString *)userToken
           collection:(NSString *)collectionId
              network:(NSString *)networkDomain
            onSuccess:(void (^)(NSDictionary *))success
            onFailure:(void (^)(NSError *))failure
{
    [self likeOrUnlikeContent:contentId forUser:userToken collection:collectionId network:networkDomain action:@"unlike" onSuccess:success onFailure:failure];
}

+ (void)likeOrUnlikeContent:(NSString *)contentId
                    forUser:(NSString *)userToken
                 collection:(NSString *)collectionId
                    network:(NSString *)networkDomain
                     action:(NSString *)actionEndpoint
                  onSuccess:(void (^)(NSDictionary *))success
                  onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(networkDomain != nil);
    NSParameterAssert(userToken != nil);
    NSParameterAssert(collectionId != nil);
    NSParameterAssert(contentId != nil);
    
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjects:@[collectionId, userToken] forKeys:@[@"collection_id", @"lftoken"]];
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    
    contentId = [contentId stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *host = [NSString stringWithFormat:@"%@.%@", kQuillDomain, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/message/%@/%@/", contentId, actionEndpoint];

    [self requestWithHost:host
                 path:path
              payload:queryString
               method:@"POST"
            onSuccess:success
            onFailure:failure];
}

+ (void)postContent:(NSString *)body
            forUser:(NSString *)userToken
          inReplyTo:(NSString *)parentId
      forCollection:(NSString *)collectionId
            network:(NSString *)networkDomain
          onSuccess:(void (^)(NSDictionary *))success
          onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(body != nil);
    NSParameterAssert(userToken != nil);
    NSParameterAssert(collectionId != nil);
    NSParameterAssert(networkDomain != nil);
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjects:@[body, userToken] forKeys:@[@"body", @"lftoken"]];
    if (parentId)
        [paramsDict setObject:parentId forKey:@"parent_id"];
    
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    NSString *host = [NSString stringWithFormat:@"%@.%@", kQuillDomain, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/collection/%@/post/", collectionId];
    
    [self requestWithHost:host
                 path:path
              payload:queryString
               method:@"POST"
            onSuccess:success
            onFailure:failure];
}

+ (void)flagContent:(NSString *)contentId
      forCollection:(NSString *)collectionId
            network:(NSString *)networkDomain
           withFlag:(FlagType)flagType
               user:(NSString *)userToken
              notes:(NSString *)notes
              email:(NSString *)email
          onSuccess:(void (^)(NSDictionary *))success
          onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(contentId != nil);
    NSParameterAssert(collectionId != nil);
    NSParameterAssert(networkDomain != nil);
    NSParameterAssert(userToken != nil);

    NSString *flag = [self adaptFlag:flagType];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjects:@[contentId, collectionId, flag, userToken]
                                                                        forKeys:@[@"message_id", @"collection_id", @"flag", @"lftoken"]];
    if (notes)
        [paramsDict setObject:notes forKey:@"notes"];
    if (email)
        [paramsDict setObject:email forKey:@"email"];

    NSString *payload = [[NSString alloc] initWithParams:paramsDict];
    NSString *host = [NSString stringWithFormat:@"%@.%@", kQuillDomain, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/message/%@/flag/%@/", contentId, flag];

    [self requestWithHost:host
                     path:path
                  payload:payload
                   method:@"POST"
                onSuccess:success
                onFailure:failure];
}

+ (NSString *)adaptFlag:(FlagType)flagType
{
    switch (flagType) {
        case OFFENSIVE:
            return @"offensive";
            break;
        case SPAM:
            return @"spam";
        case DISAGREE:
            return @"disagree";
        case OFF_TOPIC:
            return @"off-topic";
        default:
            [NSException raise:@"Unknown flag type" format:@"Unknown flag type: '%d'", flagType];
            break;
    }
}
@end
