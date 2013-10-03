//
//  LFSConstants.h
//  LivefyreClient
//
//  Created by zjj on 1/9/13.
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

#ifndef LFSClient_types_h
#define LFSClient_types_h

#import <AFNetworking/AFHTTPRequestOperation.h>

typedef void (^LFSSuccessBlock) (NSOperation *operation, id responseObject);
typedef void (^LFSFailureBlock) (NSOperation *operation, NSError *error);
typedef void (^LFHandleBlock) (id responseObject);
typedef void (^AFSuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFFailureBlock) (AFHTTPRequestOperation *operation, NSError *error);

#define LFS_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define LFS_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define LFS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define LFS_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define LFS_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif

@interface LFSConstants : NSObject

extern NSString* const LFSSystemVersion70;

extern NSString *const LFSScheme;
extern NSString *const LFSErrorDomain;

// Various constants to help with parsing JSON files
extern NSString *const LFSCollectionSettings;
extern NSString *const LFSHeadDocument;
extern NSString *const LFSNetworkSettings;
extern NSString *const LFSSiteSettings;

// user content preferences (like, unlike, etc)
typedef NS_ENUM(NSUInteger, LFSOpine) {
    LFSOpineLike = 0u,
    LFSOpineUnlike
};

// moderator content flags
// https://github.com/Livefyre/lfdj/blob/production/lfwrite/lfwrite/api/v3_0/msg/opine.py#L168
typedef NS_ENUM(NSUInteger, LFSUserFlag) {
    LFSFlagSpam = 0u,
    LFSFlagOffensive,
    LFSFlagDisagree,
    LFSFlagOfftopic
};

// https://github.com/Livefyre/lfdj/blob/production/lfcore/lfcore/v2/publishing/models.proto#L74
typedef NS_ENUM(NSUInteger, LFSContentType) {
    LFSContentTypeMessage = 0u, //A message posted by a user in reply to an article or another comment
    LFSContentTypeOpine, // An opinion from a user indicating that they like a comment or an embed
    LFSContentTypeShare, //Unused?
    LFSContentTypeOEmbed, // An embedded image which is part of a comment
    LFSContentTypeStruct //A primitive structure which the engine treats as an opaque object.
};

// https://github.com/Livefyre/lfdj/blob/rc/lfcore/lfcore/v2/fulfillment/bootstrap/models.proto#L106
typedef NS_ENUM(NSUInteger, LFSContentVisibility) {
    LFSContentVisibilityNone = 0u, //content is visible to no one, usually due to being deleted
    LFSContentVisibilityEveryone, //content is visible to everyone
    LFSContentVisibilityOwner, //content is visible to only the author due to bozoing
    LFSContentVisibilityGroup //content is visible to the author and any moderators for the
    // collection, usually meaning that it's waiting for approval
};

// https://github.com/Livefyre/lfdj/blob/production/lfcore/lfcore/v2/publishing/models.proto#L179
typedef NS_ENUM(NSUInteger, LFSPermission) {
    LFSPermissionNone = 0u,
    LFSPermissionWhitelist,
    LFSPermissionBlacklist,
    LFSPermissionGraylist,
    LFSPermissionModerator
};

// https://github.com/Livefyre/lfdj/blob/production/lfcore/lfcore/v2/util/models.proto#L21
typedef NS_ENUM(NSUInteger, LFSPermissionScope) {
    LFSPermissionScopeGlobal = 0u,
    LFSPermissionScopeNetwork,
    LFSPermissionScopeSite,
    LFSPermissionScopeCollection,
    LFSPermissionScopeCollectionRule
};


@end
