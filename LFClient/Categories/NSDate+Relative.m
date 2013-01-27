//
//  NSDate+Relative.m
//  LivefyreClient
//
//  Created by Thomas Goyne on 8/29/12.
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

#import "NSDate+Relative.h"

@implementation NSDate (Relative)
- (NSString *)relativeTime {
    NSTimeInterval time = -[self timeIntervalSinceNow];

    if (time < 0)
        return @"In the future";
    if (time < 1)
        return @"Now";
    if (time < 2)
        return @"One second ago";
    if (time < 60)
        return [NSString stringWithFormat:@"%d seconds ago", (int)time];
    if (time < 120)
        return @"One minute ago";
    if (time < 3600)
        return [NSString stringWithFormat:@"%d minutes ago", (int)time / 60];
    if (time < 7200)
        return @"One hour ago";
    if (time < 86400)
        return [NSString stringWithFormat:@"%d hours ago", (int)time / 3600];

    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:NSDateFormatterShortStyle
                                          timeStyle:NSDateFormatterShortStyle];
}
@end
