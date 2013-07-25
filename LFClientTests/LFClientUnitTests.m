//
//  LFClientUnitTests.m
//  LFClient
//
//  Created by zjj on 1/23/13.
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

#import "LFClientUnitTests.h"
#import "LFTestingURLProtocol.h"
#import "LFBootstrapClient.h"
#import "LFPublicAPIClient.h"
#import "LFAdminClient.h"
#import "LFWriteClient.h"
#import "LFStreamClient.h"
#import "Config.h"

@interface LFClientUnitTests()
@end

@implementation LFClientUnitTests
- (void)setUp
{
    [super setUp];
    //These tests are nominal.
    [NSURLProtocol registerClass:[LFTestingURLProtocol class]];
}

- (void)tearDown
{
    // Tear-down code here.
    [NSURLProtocol unregisterClass:[LFTestingURLProtocol class]];

    [super tearDown];
}

- (void)testBootstrapClient {
    // Get Init
    __block NSDictionary *bootstrapInitInfo;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [LFBootstrapClient getInitForArticle:@"fakeArticle"
                                    site:@"fakeSite"
                                 network:@"init-sample"
                             environment:nil
                               onSuccess:^(NSDictionary *collection) {
                                     bootstrapInitInfo = collection;
                                     dispatch_semaphore_signal(sema);
                                 }
                               onFailure:^(NSError *error) {
                                     if (error)
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                     dispatch_semaphore_signal(sema);
                                 }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    STAssertEquals([bootstrapInitInfo count], 4u, @"Collection dictionary should have 4 keys");

    // Get Content
    __block NSDictionary *contentInfo;
    sema = dispatch_semaphore_create(0);
    
    [LFBootstrapClient getContentForPage:0
                            withInitInfo:bootstrapInitInfo
                               onSuccess:^(NSDictionary *content) {
                                     contentInfo = content;
                                     dispatch_semaphore_signal(sema);
                                 }
                               onFailure:^(NSError *error) {
                                     if (error)
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                     dispatch_semaphore_signal(sema);
                                 }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    STAssertNotNil(contentInfo, @"Content head document fail");
    
    sema = dispatch_semaphore_create(0);
    
    [LFBootstrapClient getContentForPage:1
                            withInitInfo:bootstrapInitInfo
                               onSuccess:^(NSDictionary *content) {
                                     contentInfo = content;
                                     dispatch_semaphore_signal(sema);
                                 }
                               onFailure:^(NSError *error) {
                                     if (error)
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                     dispatch_semaphore_signal(sema);
                                 }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    STAssertNotNil(contentInfo, @"Content fetch fail");
}


- (void)testPublicAPIGetTrending {
    __block NSArray *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [LFPublicAPIClient getHottestCollectionsForTag:@"taggy"
                                              site:@"site"
                                           network:@"hottest-sample"
                                    desiredResults:10
                                         onSuccess:^(NSArray *results) {
                                                res = results;
                                                dispatch_semaphore_signal(sema);
                                         } onFailure:^(NSError *error) {
                                                NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                                dispatch_semaphore_signal(sema);
                                            }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEquals([res count], 10u, @"Heat API should return 10 items");
}

- (void)testUserDataRetrieval {
    __block NSArray *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [LFPublicAPIClient getUserContentForUser:@"fakeUser"
                                   withToken:nil
                                   forNetwork:@"usercontent-sample"
                                    statuses:nil
                                      offset:nil
                                   onSuccess:^(NSArray *results) {
                                         res = results;
                                         dispatch_semaphore_signal(sema);
                                } onFailure:^(NSError *error) {
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                         dispatch_semaphore_signal(sema);
                                     }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEquals([res count], 12u, @"User content API should return 12 items");
}

- (void)testUserAuthentication {
    //with article and site ids
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [LFAdminClient authenticateUserWithToken:@"fakeToken"
                               forCollection:@"fakeColl"
                                     article:nil
                                        site:nil
                                     network:@"auth-sample"
                                   onSuccess:^(NSDictionary *gotUserData) {
                                         res = gotUserData;
                                         dispatch_semaphore_signal(sema);
                                } onFailure:^(NSError *error) {
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                         dispatch_semaphore_signal(sema);
                                     }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));

    STAssertEquals([res count], 3u, @"User auth should return 3 items");
}

- (void)testLikes {
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [LFWriteClient likeContent:@"fakeContent"
                       forUser:@"fakeUserToken"
                    collection:@"fakeColl"
                       network:@"like-sample"
                     onSuccess:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                   } onFailure:^(NSError *error) {
                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEquals([res count], 3u, @"Like action should return 3 items");
}

- (void)testPost {
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSUInteger ran = arc4random();
    
    [LFWriteClient postContent:[NSString stringWithFormat:@"test post, %d", ran]
                       forUser:@"fakeUser"
                     inReplyTo:nil
                 forCollection:@"fakeColl"
                       network:@"post-sample"
                     onSuccess:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                   } onFailure:^(NSError *error) {
                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEquals([res count], 3u, @"Post content should return 3 items");
}

- (void)testFlag {
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [LFWriteClient flagContent:@"fakeContent"
                 forCollection:@"fakeCollection"
                       network:@"flag-sample"
                      withFlag:OFF_TOPIC
                          user:@"fakeUser"
                         notes:@"fakeNotes"
                         email:@"fakeEmail"
                     onSuccess:^(NSDictionary *opineData) {
                         res = opineData;
                         dispatch_semaphore_signal(sema);
                     } onFailure:^(NSError *error) {
                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                         dispatch_semaphore_signal(sema);
                     }];

    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));

    STAssertEquals([res count], 3u, @"Post content should return 3 items");
}

//- (void)testStream {
//    __block NSDictionary *res;
//    __block NSUInteger trips = 2;
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//     
//    LFStreamClient *streamer = [LFStreamClient new];
//    [streamer startStreamForCollection:@"fakeColl"
//                             fromEvent:@"fakeId"
//                             onNetwork:@"stream-sample"
//                               success:^(NSDictionary *updates) {
//                                   res = updates;
//                                   trips--;
//                                   if (trips == 0)
//                                       dispatch_semaphore_signal(sema);
//                               } failure:^(NSError *error) {
//                                   NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
//                                   dispatch_semaphore_signal(sema);
//                               }];
//    
//    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
//    STAssertEquals([res count], 3u, @"Stream should return 3 items");
//    
//    [streamer stopStreamForCollection:@"fakeColl"];
//    res = nil;
//    //Stop stream will stop, but due to async magic there is no gaurantee when it will stop.
//    //dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
//    STAssertNil(res, @"Stop stream should stop the stream");
//}

- (void)testFloat
{
    NSString *spoofPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"float-test" ofType:@"json"];
    NSData *responseData = [[NSData alloc] initWithContentsOfFile:spoofPath];
    NSError *JSONErr;
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&JSONErr];
    STAssertNotNil(parsedData, @"no error");
    STAssertNil(JSONErr, @"no error");
}
@end
