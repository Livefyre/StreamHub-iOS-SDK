//
//  RelativeToDateTest.m
//  LFSClient
//
//  Created by Eugene Scherba on 9/6/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "NSDateFormatter+RelativeTo.h"

#define EXP_SHORTHAND YES
#import <Expecta/Expecta.h>

@interface LFSRelativeToDateTest : SenTestCase

@end

@implementation LFSRelativeToDateTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFuture
{
    // TODO: add more tests
    NSDate *date = [NSDate distantFuture];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar currentCalendar]];
    expect([formatter relativeStringFromDate:date]).to.equal(@"");
}

- (void)testPast
{
    NSDate *date = [NSDate distantPast];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar currentCalendar]];
    expect([formatter relativeStringFromDate:date]).to.equal(@"29 Dec 1");
}

- (void)testSpecificDate1
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:10];
    [comps setMonth:10];
    [comps setYear:2010];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar currentCalendar]];
    expect([formatter relativeStringFromDate:date]).to.equal(@"10 Oct 2010");
}

- (void)testRelativeDates
{
    // date 1 (< date 2)
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setCalendar:[NSCalendar currentCalendar]];
    [comps setSecond:3];
    [comps setMinute:15];
    [comps setHour:4];
    [comps setDay:10];
    [comps setMonth:10];
    [comps setYear:2010];
    NSDate *date = [comps.calendar dateFromComponents:comps];
    
    // date 2 (> date 1)
    NSDateComponents *anotherComps = [[NSDateComponents alloc] init];
    [anotherComps setCalendar:[NSCalendar currentCalendar]];
    [anotherComps setSecond:13];
    [anotherComps setMinute:15];
    [anotherComps setHour:4];
    [anotherComps setDay:10];
    [anotherComps setMonth:10];
    [anotherComps setYear:2010];
    NSDate *anotherDate = [anotherComps.calendar dateFromComponents:anotherComps];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar currentCalendar]];
    expect([formatter relativeStringFromDate:date relativeTo:anotherDate]).to.equal(@"10s");
}

@end
