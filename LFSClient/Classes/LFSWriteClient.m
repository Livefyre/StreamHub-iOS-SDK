//
//  LFSWriteClient.m
//  LFSClient
//
//  Created by Eugene Scherba on 8/22/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFSWriteClient.h"
#import <JWT/JWT.h>
#import <NSString-Hashes/NSString+Hashes.h>

@implementation LFSWriteClient

#pragma mark - Overrides
-(NSString*)subdomain { return @"quill"; }

#pragma mark - Methods

-(void)postMessage:(LFSMessageAction)action
        forContent:(NSString *)contentId
      inCollection:(NSString *)collectionId
         userToken:(NSString *)userToken
        parameters:(NSDictionary *)parameters
         onSuccess:(LFSSuccessBlock)success
         onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(contentId != nil);
    NSParameterAssert(collectionId != nil);
    NSParameterAssert(userToken != nil);
    NSParameterAssert((NSUInteger)action < LFS_OPINE_ENDPOINTS_LENGTH);
    
    const NSString *actionEndpoint = LFSMessageEndpoints[action];
    
    NSMutableDictionary *parameters1 =
    [NSMutableDictionary
     dictionaryWithObjects:@[contentId, collectionId, userToken]
     forKeys:@[@"message_id", @"collection_id", @"lftoken"]];
    
    // parameters passed in can be @{ notes: @"...", email: @"..." }
    [parameters1 addEntriesFromDictionary:parameters];
    
    NSString *path = [NSString
                      stringWithFormat:@"/api/v3.0/message/%@/%@/",
                      contentId, actionEndpoint];
    
    [self postPath:path
        parameters:parameters1
           success:success
           failure:failure];
}

- (void)postFlag:(LFSContentFlag)flag
      forContent:(NSString *)contentId
    inCollection:(NSString *)collectionId
       userToken:(NSString*)userToken
      parameters:(NSDictionary*)parameters
       onSuccess:(LFSSuccessBlock)success
       onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(contentId != nil);
    NSParameterAssert(collectionId != nil);
    NSParameterAssert(userToken != nil);
    NSParameterAssert((NSUInteger)flag < LFS_CONTENT_FLAGS_LENGTH);
    
    NSMutableDictionary *parameters1 =
    [NSMutableDictionary
     dictionaryWithObjects:@[contentId, collectionId, userToken]
     forKeys:@[@"message_id", @"collection_id", @"lftoken"]];
    
    // parameters passed in can be @{ notes: @"...", email: @"..." }
    [parameters1 addEntriesFromDictionary:parameters];
    
    NSString *path = [NSString
                      stringWithFormat:@"/api/v3.0/message/%@/flag/%@/",
                      contentId, LFSContentFlags[flag]];
    
    [self postPath:path
        parameters:parameters1
           success:success
           failure:failure];
}


- (void)postContent:(NSString *)body
       inCollection:(NSString *)collectionId
          userToken:(NSString*)userToken
          inReplyTo:(NSString *)parentId
          onSuccess:(LFSSuccessBlock)success
          onFailure:(LFSFailureBlock)failure
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (body != nil) {
        [parameters setObject:body forKey:LFSCollectionPostBodyKey];
    }
    if (userToken != nil) {
        [parameters setObject:userToken forKey:LFSCollectionPostUserTokenKey];
    }
    if (parentId != nil) {
        [parameters setObject:parentId forKey:LFSCollectionPostParentIdKey];
    }
    
    [self postContentType:LFSPostTypeDefault
            forCollection:collectionId
               parameters:parameters
                onSuccess:success
                onFailure:failure];
}

- (void)postContentType:(LFSPostType)postType
          forCollection:(NSString *)collectionId
             parameters:(NSDictionary*)parameters
              onSuccess:(LFSSuccessBlock)success
              onFailure:(LFSFailureBlock)failure
{
    NSString *contentBody = [parameters objectForKey:LFSCollectionPostBodyKey];
    NSString *userToken = [parameters objectForKey:LFSCollectionPostUserTokenKey];
    
    NSParameterAssert(contentBody != nil);
    NSParameterAssert(userToken != nil);
    NSParameterAssert(collectionId != nil);
    NSParameterAssert((NSUInteger)postType < LFS_POST_TYPE_LENGTH);
    
    NSString *path;
    if (postType == LFSPostTypeDefault) {
        path = [NSString stringWithFormat:@"/api/v3.0/collection/%@/post/",
                  collectionId];
    } else {
        path = [NSString stringWithFormat:@"/api/v3.0/collection/%@/post/%@/",
           collectionId, LFSPostTypes[postType]];
    }
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    id rating = [mutableParameters objectForKey:LFSCollectionPostRatingKey];
    if (rating != nil && ![rating isKindOfClass:[NSString class]]) {
        NSError *serializationError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rating options:0 error:&serializationError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [mutableParameters setObject:jsonString forKey:LFSCollectionPostRatingKey];
    }
    
    [self postPath:path
        parameters:mutableParameters
           success:success
           failure:failure];
}


-(void)postArticleForSite:(NSString*)siteId
              withSiteKey:(NSString*)siteKey
           collectionMeta:(NSDictionary*)collectionMeta
                onSuccess:(LFSSuccessBlock)success
                onFailure:(LFSFailureBlock)failure
{
    // https://github.com/Livefyre/lfdj/blob/production/lfwrite/lfwrite/api/v3_0/site/collection.py#L26
    // https://github.com/Livefyre/lfdj/blob/production/lfcore/lfcore/v2/network/steps.py#L476
    //
    static NSString *const LFSCollectionMetaParameterKey = @"collectionMeta";
    static NSString *const LFSCollectionChecksumParameterKey = @"checksum";
    
    NSString *articleId = [collectionMeta objectForKey:LFSCollectionMetaArticleIdKey];
    NSString *urlString = [collectionMeta objectForKey:LFSCollectionMetaURLKey];
    NSString *title = [collectionMeta objectForKey:LFSCollectionMetaTitleKey];

    NSParameterAssert(articleId != nil && [articleId length] <= 255);
    NSParameterAssert(urlString != nil);
    NSParameterAssert(siteId != nil);
    NSParameterAssert(siteKey == nil || (title != nil && [title length] <= 255));

    NSMutableDictionary *mutableMeta = [collectionMeta mutableCopy];
    
    // tags are optional and have to be stringified
    NSArray *tagArray = [collectionMeta objectForKey:LFSCollectionMetaTagsKey];
    if (tagArray != nil) {
        [mutableMeta setObject:[tagArray componentsJoinedByString:@","]
                        forKey:LFSCollectionMetaTagsKey];
    }
    
    NSDictionary *parameters;
    if (siteKey != nil) {
        // signed request
        NSString *collectionMetaString = [JWT encodePayload:mutableMeta withSecret:siteKey];
        parameters = @{LFSCollectionMetaParameterKey     : collectionMetaString,
                       LFSCollectionChecksumParameterKey : [collectionMetaString md5]};
    } else {
        // unsigned request
        parameters = @{LFSCollectionMetaParameterKey     : mutableMeta};
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/v3.0/site/%@/collection/create", siteId];
    
    [self postPath:path
        parameters:parameters
 parameterEncoding:AFJSONParameterEncoding
           success:success
           failure:failure];
}

@end
