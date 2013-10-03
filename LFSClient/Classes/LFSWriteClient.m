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

#define LFS_OPINE_ENDPOINTS_LENGTH 2u
static const NSString* const LFSOpineEndpoints[LFS_OPINE_ENDPOINTS_LENGTH] =
{
    @"like",
    @"unlike"
};

#define LFS_USER_FLAGS_LENGTH 4u
static const NSString* const LFSUserFlags[LFS_USER_FLAGS_LENGTH] =
{
    @"spam",
    @"offensive",
    @"disagree",
    @"off-topic"
};

@implementation LFSWriteClient

#pragma mark - Overrides
-(NSString*)subdomain { return @"quill"; }

#pragma mark - Methods

- (void)postOpinion:(LFSOpine)action
            forUser:(NSString*)userToken
         forContent:(NSString *)contentId
       inCollection:(NSString *)collectionId
          onSuccess:(LFSSuccessBlock)success
          onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(contentId != nil);
    NSParameterAssert((NSUInteger)action < LFS_OPINE_ENDPOINTS_LENGTH);
    
    const NSString *actionEndpoint = LFSOpineEndpoints[action];
    NSDictionary *parameters = @{@"collection_id":collectionId,
                                 @"lftoken": userToken};
    NSString *path = [NSString
                      stringWithFormat:@"/api/v3.0/message/%@/%@/",
                      contentId, actionEndpoint];
    
    [self postPath:path
        parameters:parameters
           success:success
           failure:failure];
}

- (void)postFlag:(LFSUserFlag)flag
         forUser:(NSString*)userToken
      forContent:(NSString *)contentId
    inCollection:(NSString *)collectionId
      parameters:(NSDictionary*)parameters
       onSuccess:(LFSSuccessBlock)success
       onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(contentId != nil);
    NSParameterAssert((NSUInteger)flag < LFS_USER_FLAGS_LENGTH);
    
    const NSString *flagString = LFSUserFlags[flag];
    NSMutableDictionary *parameters1 =
    [NSMutableDictionary
     dictionaryWithObjects:@[contentId, collectionId, flagString, userToken]
     forKeys:@[@"message_id", @"collection_id", @"flag", @"lftoken"]];
    
    // parameters passed in can be { notes: @"...", email: @"..." }
    [parameters1 addEntriesFromDictionary:parameters];
    NSString *path = [NSString
                      stringWithFormat:@"/api/v3.0/message/%@/flag/%@/",
                      contentId, flagString];
    
    [self postPath:path
        parameters:parameters1
           success:success
           failure:failure];
    
}

- (void)postNewContent:(NSString *)body
               forUser:(NSString*)userToken
         forCollection:(NSString *)collectionId
             inReplyTo:(NSString *)parentId
             onSuccess:(LFSSuccessBlock)success
             onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(body != nil);
    NSParameterAssert(collectionId != nil);
    
    // TODO: figure out whether to use defaults like this throughout
    if (userToken == nil) {
        userToken = @"";
    }
    
    NSMutableDictionary *parameters =
    [NSMutableDictionary
     dictionaryWithObjects:@[body, userToken]
     forKeys:@[@"body", @"lftoken"]];
    
    if (parentId) {
        [parameters setObject:parentId forKey:@"parent_id"];
    }
    
    NSString *path = [NSString
                      stringWithFormat:@"/api/v3.0/collection/%@/post/",
                      collectionId];
    
    [self postPath:path
        parameters:parameters
           success:success
           failure:failure];
}

- (void)postNewArticle:(NSString*)articleId
               forSite:(NSString*)siteId
         secretSiteKey:(NSString*)secretSiteKey
                 title:(NSString*)title
                  tags:(NSArray*)tagArray
               withURL:(NSURL *)newURL
             onSuccess:(LFSSuccessBlock)success
             onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(articleId != nil);
    NSParameterAssert(newURL != nil);
    NSParameterAssert(siteId != nil);
    NSParameterAssert([title length] <= 255);
    NSParameterAssert([articleId length] <= 255);
    
    NSDictionary *dict = @{@"title":title,
                           @"url":[newURL absoluteString],
                           @"tags":[tagArray componentsJoinedByString:@","],
                           @"articleId":articleId,
                           @"signed":[NSNumber numberWithBool:(secretSiteKey != nil)]};
    
    NSDictionary *parameters;
    if (secretSiteKey != nil) {
        NSString *collectionMeta = [JWT encodePayload:dict
                                           withSecret:secretSiteKey];
        parameters = @{@"collectionMeta":collectionMeta,
                       @"checksum":[collectionMeta md5]};
    } else {
        parameters = @{@"collectionMeta":dict};
    }
    
    NSURL *fullURL = [self.baseURL
                      URLByAppendingPathComponent:
                      [NSString stringWithFormat:@"/api/v3.0/site/%@/collection/create",
                       siteId]];
    
    [self postURL:fullURL
       parameters:parameters
parameterEncoding:AFJSONParameterEncoding
          success:success
          failure:failure];
}

@end
