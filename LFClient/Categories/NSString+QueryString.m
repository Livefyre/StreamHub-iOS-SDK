//
//  NSString+QueryString.m
//  LivefyreClient
//
//  Created by zjj on 1/7/13.
//
//

#import "NSString+QueryString.h"

static char _syntacticGlue = '?';

@implementation NSString(QueryString)
- (NSString *)initWithParams:(NSDictionary *)params {
    self = [self init];
    if (!self)
        return self;
    
    for (NSString *key in params) {
        NSString *escapedKey = [key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *escapedValue = [[params objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        self = [self stringByAppendingFormat:@"%c%@=%@", _syntacticGlue, escapedKey, escapedValue];
        if (_syntacticGlue != '&')
            _syntacticGlue = '&';
    }
    //reset
    _syntacticGlue = '?';
    return self;
}
@end
