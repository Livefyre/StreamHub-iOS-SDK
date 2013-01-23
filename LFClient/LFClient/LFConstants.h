//
//  LFConstants.h
//  LivefyreClient
//
//  Created by zjj on 1/9/13.
//
//

#import <Foundation/Foundation.h>

//TODO add constants and enums to appledoc.
@interface LFConstants : NSObject
extern NSString *const kLFSDKScheme;
extern NSString *const kLFError;
extern NSString *const kShareTypeTwitter;
extern NSString *const kShareTypeFacebook;
extern NSString *const kShareTypeLinkedin;
extern NSString *const kCommentStatusActive;
extern NSString *const kCommentStatusBozo;
extern NSString *const kCommentStatusPending;
extern NSString *const kCommentStatusSpam;
extern NSString *const kCommentStatusHidden;
extern NSString *const kCommentStatusDeleted;

enum ContentType {
    // A message posted by a user in reply to an article or another comment.
    ContentTypeMessage = 0,
    // An opinion from a user indicating that they like a comment or an embed.
    ContentTypeOpine = 1,
    // An embedded image which is part of a comment.
    ContentTypeEmbed = 3
};

enum ContentVisibility {
    // The content is visible to no one, usually due to being deleted.
    ContentVisibilityNone = 0,
    // The content is visible to everyone.
    ContentVisibilityEveryone = 1,
    // The content is visible to only the author due to bozoing.
    ContentVisibilityOwner = 2,
    // The content is visible to the author and any moderators for the
    // collection, usually meaning that it's waiting for approval.
    ContentVisibilityGroup = 3
};

enum Permissions {
    PermissionsNone = 0,
    PermissionsWhitelist = 1,
    PermissionsBlacklist = 2,
    PermissionsGraylist = 3,
    PermissionsModerator = 4
};

enum PermissionScope {
    PermissionScopeGlobal = 0,
    PermissionScopeNetwork = 1,
    PermissionScopeSite = 2,
    PermissionScopeCollection = 3,
    PermissionScopeCollectionRule = 4
};
@end
