//
//  LFSAdminClient.m
//  LFSClient
//
//  Created by Eugene Scherba on 8/22/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFSAdminClient.h"
#import <Base64/MF_Base64Additions.h>

@implementation LFSAdminClient

#pragma mark - Overrides
-(NSString*)subdomain { return @"admin"; }

#pragma mark - Methods

- (void)authenticateUserWithToken:(NSString *)userToken
                       collection:(NSString *)collectionId
                        onSuccess:(LFSSuccessBlock)success
                        onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(userToken != nil);
    NSParameterAssert(collectionId != nil);
    
    [self getPath:@"/api/v3.0/auth/"
       parameters:@{@"lftoken": userToken,
                    @"collectionId": collectionId}
          success:(AFSuccessBlock)success
          failure:(AFFailureBlock)failure];
}

- (void)authenticateUserWithToken:(NSString *)userToken
                             site:(NSString *)siteId
                          article:(NSString *)articleId
                        onSuccess:(LFSSuccessBlock)success
                        onFailure:(LFSFailureBlock)failure
{
    NSParameterAssert(userToken != nil);
    NSParameterAssert(siteId != nil);
    NSParameterAssert(articleId != nil);
    
    [self getPath:@"/api/v3.0/auth/"
       parameters:@{@"lftoken": userToken,
                    @"siteId": siteId,
                    @"articleId":[articleId base64String]}
          success:(AFSuccessBlock)success
          failure:(AFFailureBlock)failure];
}

@end
