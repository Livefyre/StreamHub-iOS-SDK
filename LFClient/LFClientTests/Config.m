//
//  Config.m
//  LivefyreClient
//
//  Created by Thomas Goyne on 5/27/12.
//  Copyright (c) 2012 7x7 Labs. All rights reserved.
//

#import "Config.h"

@implementation Config
+ (NSDictionary *)ConfigDictionary {
    static NSDictionary *configDictionary = nil;
    if (!configDictionary) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestConfig" ofType:@"plist"];
        configDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }

    return configDictionary;
}

+ (id)objectForKey:(id)key {
    return [[self ConfigDictionary] objectForKey:key];
}

- (NSCondition *)condition
{
    if (!self.condition)
        self.condition = [NSCondition new];
    return self.condition;
}
@end
