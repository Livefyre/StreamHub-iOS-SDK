//
//  LFJSONKitTests.m
//  LFSClient
//
//  Created by Eugene Scherba on 8/22/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "JSONKit.h"

#define EXP_SHORTHAND YES
#import <Expecta/Expecta.h>

@interface LFSJSONKitTests : SenTestCase
@end

@interface LFSJSONKitTests ()
@end

@implementation LFSJSONKitTests

- (void)setUp
{
    [super setUp];
    // setup code here
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

#pragma mark -
- (void)testJSONNumberWithTruncate
{
    NSString *spoofPath = [[NSBundle bundleForClass:[self class]]
                           pathForResource:@"number-test" ofType:@"json"];
    NSData *responseData = [[NSData alloc] initWithContentsOfFile:spoofPath];
    JSONDecoder *decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionTruncateNumbers];
    
    // expect no error with "-Truncate" option
    NSError *error = nil;
    id parsedData = [decoder objectWithData:responseData error:&error];
    
    expect(parsedData).to.beTruthy();
    expect(error).to.beFalsy();
}

- (void)testJSONNumberStrict
{
    NSString *spoofPath = [[NSBundle bundleForClass:[self class]]
                           pathForResource:@"number-test" ofType:@"json"];
    NSData *responseData = [[NSData alloc] initWithContentsOfFile:spoofPath];
    JSONDecoder *decoder = [JSONDecoder decoderWithParseOptions:JKParseOptionStrict];
    
    // expect an error on parsing with "-Strict" JSON parse option
    NSError *error = nil;
    id parsedData = [decoder objectWithData:responseData error:&error];
    expect(parsedData).to.beFalsy();
    expect(error).to.beTruthy();
}

/*
 - (void)testNumber
 {
 NSString *spoofPath = [[NSBundle bundleForClass:[self class]] 
                        pathForResource:@"number-test" ofType:@"json"];
 NSData *responseData = [[NSData alloc] initWithContentsOfFile:spoofPath];
 NSError *error;
 id parsedData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
 STAssertNotNil(parsedData, @"no error");
 STAssertNil(error, @"no error");
 }
 */

@end
