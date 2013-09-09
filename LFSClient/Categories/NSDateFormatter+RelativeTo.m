//
//  NSDateFormatter+RelativeTo.m
//  LFSClient
//
//  Created by Eugene Scherba on 9/6/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "NSDateFormatter+RelativeTo.h"

@implementation NSDateFormatter (RelativeTo)

- (NSString*)relativeStringFromDate:(NSDate*)date
{
    return [self relativeStringFromDate:date relativeTo:[NSDate date]];
}

- (NSString*)relativeStringFromDate:(NSDate *)date relativeTo:(NSDate*)anotherDate
{
    NSTimeInterval diffSs = [anotherDate timeIntervalSinceDate:date];
    if (diffSs < 0) {
        // Future
        return @"";
    } else if (diffSs < 60) {
        // Less than 60s ago -> e.g. 5s
        return [NSString stringWithFormat:@"%ds", (int)diffSs];
    } else if (diffSs < 60 * 60) {
        // Less than 1h ago -> e.g. 5m
        return [NSString stringWithFormat:@"%dm", (int)diffSs / 60];
    } else if (diffSs < 60 * 60 * 24) {
        // Less than 24h ago -> e.g. 5h
        return [NSString stringWithFormat:@"%dh", (int)diffSs / 3600];
    } else {
        // >= 24 hours ago -> e.g. 6 Jul
        NSCalendar *calendar = self.calendar;
        NSDateComponents *components =
        [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                    fromDate:date];
        NSDateComponents *anotherDateComponents =
        [calendar components:NSYearCalendarUnit
                    fromDate:anotherDate];
        
        NSArray *months = self.shortMonthSymbols;
        if ([components year] == [anotherDateComponents year]) {
            // year is the same as relativeTo year
            return [NSString stringWithFormat:@"%d %@",
                    [components day],
                    [months objectAtIndex:[components month] - 1]];
        } else {
            // year is different than relativeTo year
            return [NSString stringWithFormat:@"%d %@ %d",
                    [components day],
                    [months objectAtIndex:([components month] - 1)],
                    [components year]];
        }
    }
}

@end
