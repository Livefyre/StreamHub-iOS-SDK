//
//  LFSConfig.m
//  LivefyreClient
//
//  Created by Thomas Goyne on 5/27/12.
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

#import "LFSConfig.h"

@implementation LFSConfig
+ (NSDictionary *)ConfigDictionary {
    static NSDictionary *configDictionary = nil;
    if (!configDictionary) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"LFSTestConfig" ofType:@"plist"];
        configDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return configDictionary;
}

+ (id)objectForKey:(id)key {
    return [[self ConfigDictionary] objectForKey:key];
}

/*
- (NSCondition *)condition
{
    if (!self.condition)
        self.condition = [NSCondition new];
    return self.condition;
}*/
@end