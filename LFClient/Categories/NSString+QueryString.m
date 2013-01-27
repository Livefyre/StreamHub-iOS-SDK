//
//  NSString+QueryString.m
//  LivefyreClient
//
//  Created by zjj on 1/7/13.
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
