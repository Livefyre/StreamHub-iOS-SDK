//
//  NSDateFormatter+RelativeTo.h
//  LFSClient
//
//  Created by Eugene Scherba on 9/6/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (RelativeTo)

/** @name eref decoding. */

/**
 * Foramt date as relative to now
 *
 * @self   Date Formatter
 * @param  date target date
 * @return NSString
 */
- (NSString*)relativeStringFromDate:(NSDate*)date;

/** @name eref decoding. */

/**
 * Format date as relative to specified date
 *
 * @self   Date Formatter
 * @param  date target date
 * @param  anotherDate Date to use as baseline
 * @return NSString
 */
- (NSString*)relativeStringFromDate:(NSDate *)date relativeTo:(NSDate*)anotherDate;

@end
