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
    if (!networkDomain || !userToken || !collectionId || !contentId) {
        failure([NSError errorWithDomain:kLFError code:400u userInfo:[NSDictionary dictionaryWithObject:@"Lacking necessary parameters to like content."
                                                                                                 forKey:NSLocalizedDescriptionKey]]);
        return;
    }
    
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjects:@[collectionId, userToken] forKeys:@[@"collection_id", @"lftoken"]];
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    
    contentId = [contentId stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *host = [NSString stringWithFormat:@"%@.%@", _quill, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/message/%@/%@/", contentId, actionEndpoint];

    [self requestWithHost:host
                 WithPath:path
              WithPayload:queryString
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
    if (!body || !userToken || !collectionId || !networkDomain) {
        failure([NSError errorWithDomain:kLFError code:400u userInfo:[NSDictionary dictionaryWithObject:@"Lacking necessary parameters to post content."
                                                                                                 forKey:NSLocalizedDescriptionKey]]);
        return;
    }
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjects:@[body, userToken] forKeys:@[@"body", @"lftoken"]];
    if (parentId)
        [paramsDict setObject:parentId forKey:@"parent_id"];
    
    NSString *queryString = [[NSString alloc] initWithParams:paramsDict];
    NSString *host = [NSString stringWithFormat:@"%@.%@", _quill, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/collection/%@/post/", collectionId];
    
    [self requestWithHost:host
                 WithPath:path
              WithPayload:queryString
               WithMethod:@"POST"
              WithSuccess:success
              WithFailure:failure];
}
@end
