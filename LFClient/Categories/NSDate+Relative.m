//
//  NSDate+Relative.m
//  LivefyreClient
//
//  Created by Thomas Goyne on 8/29/12.
//

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
