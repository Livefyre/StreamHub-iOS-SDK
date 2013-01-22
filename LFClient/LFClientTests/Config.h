//
//  Config.h
//  LivefyreClient
//
//  Created by Thomas Goyne on 5/27/12.
//  Copyright (c) 2012 7x7 Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (id)objectForKey:(id)key;
@property (strong, nonatomic) NSCondition *condition;
@end
