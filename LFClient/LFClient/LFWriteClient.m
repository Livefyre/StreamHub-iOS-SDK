//
//  LFWriteClient.m
//  LFClient
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFWriteClient.h"
#import "LFConstants.h"
#import "NSString+QueryString.h"

static NSString *_quill = @"quill";

@implementation LFWriteClient
+ (void)likeContent:(NSString *)contentId
            forUser:(NSString *)userToken
       inCollection:(NSString *)collectionId
          onNetwork:(NSString *)networkDomain
            success:(void (^)(NSDictionary *))success
            failure:(void (^)(NSError *))failure
{
    [self likeOrUnlikeContent:contentId forUser:userToken inCollection:collectionId onNetwork:networkDomain withAction:@"like" success:success failure:failure];
}

+ (void)unlikeContent:(NSString *)contentId
              forUser:(NSString *)userToken
         inCollection:(NSString *)collectionId
            onNetwork:(NSString *)networkDomain
              success:(void (^)(NSDictionary *))success
              failure:(void (^)(NSError *))failure
{
    [self likeOrUnlikeContent:contentId forUser:userToken inCollection:collectionId onNetwork:networkDomain withAction:@"unlike" success:success failure:failure];
}

+ (void)likeOrUnlikeContent:(NSString *)contentId
                    forUser:(NSString *)userToken
               inCollection:(NSString *)collectionId
                  onNetwork:(NSString *)networkDomain
                 withAction:(NSString *)actionEndpoint
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSError *))failure
{
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjects:@[collectionId, userToken] forKeys:@[@"collection_id", @"lftoken"]];
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    
    contentId = [contentId stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *host = [NSString stringWithFormat:@"%@.%@", _quill, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/message/%@/%@/%@", contentId, actionEndpoint, queryString];

    [self requestWithHost:host
                 WithPath:path
               WithMethod:@"POST"
              WithSuccess:success
              WithFailure:failure];
}

+ (void)postContent:(NSString *)body
            forUser:(NSString *)userToken
          inReplyTo:(NSString *)parentId
       inCollection:(NSString *)collectionId
          onNetwork:(NSString *)networkDomain
            success:(void (^)(NSDictionary *))success
            failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjects:@[body, userToken] forKeys:@[@"body", @"lftoken"]];
    if (parentId)
        [paramsDict setObject:parentId forKey:@"parent_id"];
    
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    NSString *host = [NSString stringWithFormat:@"%@.%@", _quill, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/collection/%@/post/%@", collectionId, queryString];
    
    [self requestWithHost:host
                 WithPath:path
               WithMethod:@"POST"
              WithSuccess:success
              WithFailure:failure];
}
@end
