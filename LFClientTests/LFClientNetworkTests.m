//
//  LFClientTests.m
//  LFClientTests
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
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

#import "LFClientNetworkTests.h"
#import "LFPublicAPIClient.h"
#import "LFBootstrapClient.h"
#import "LFWriteClient.h"
#import "LFStreamClient.h"
#import "LFAdminClient.h"
#import "LFConstants.h"
#import "Config.h"

@interface LFClientNetworkTests()
@property (nonatomic) NSString *event;
@end

@implementation LFClientNetworkTests

- (void)setUp
{
    [super setUp];
    if (![Config objectForKey:@"domain"])
        STFail(@"No test settings");
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCollectionRetrieval {
    __block NSDictionary *coll;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [LFBootstrapClient getInitForArticle:[Config objectForKey:@"article"]
                                 site:[Config objectForKey:@"site"]
                               network:[Config objectForKey:@"domain"]
                         environment:[Config objectForKey:@"environment"]
                                 onSuccess:^(NSDictionary *collection) {
                                     coll = collection;
                                     dispatch_semaphore_signal(sema);
                                 }
                                 onFailure:^(NSError *error) {
                                     if (error)
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                     dispatch_semaphore_signal(sema);
                                 }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    //Need status code from backend
    self.event = [[coll objectForKey:@"collectionSettings"] objectForKey:@"event"];
    STAssertNotNil(self.event, @"Should have fetched a head document");
}

- (void)testHeatAPIResultRetrieval {
    __block NSArray *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [LFPublicAPIClient getHottestCollectionsForTag:@"tag"
                                             site:[Config objectForKey:@"site"]
                                          network:[Config objectForKey:@"domain"]
                                     desiredResults:10
                                            onSuccess:^(NSArray *results) {
                                                res = results;
                                                dispatch_semaphore_signal(sema);
                                            } onFailure:^(NSError *error) {
                                                NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                                dispatch_semaphore_signal(sema);
                                            }];
 
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertNotNil(res, @"Should have returned results");
}

- (void)testUserDataRetrieval {
    __block NSArray *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [LFPublicAPIClient getUserContentForUser:[Config objectForKey:@"system user"]
                                   withToken:nil
                                   forNetwork:[Config objectForKey:@"labs network"]
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

    STAssertNotNil(res, @"Should have returned results");
}

- (void)testUserAuthentication {
    //with article and site ids
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSString *userToken = [Config objectForKey:@"moderator user auth token"];
    
    [LFAdminClient authenticateUserWithToken:userToken
                               forCollection:nil
                                  article:[Config objectForKey:@"article"]
                                     site:[Config objectForKey:@"site"]
                                   network:[Config objectForKey:@"domain"]
                                     onSuccess:^(NSDictionary *gotUserData) {
                                         res = gotUserData;
                                         dispatch_semaphore_signal(sema);
                                     } onFailure:^(NSError *error) {
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                         dispatch_semaphore_signal(sema);
                                     }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
    
    //with collection id
    res = nil;    
    [LFAdminClient authenticateUserWithToken:userToken
                               forCollection:[Config objectForKey:@"collection"]
                                  article:nil
                                     site:nil
                                   network:[Config objectForKey:@"domain"]
                                     onSuccess:^(NSDictionary *gotUserData) {
                                         res = gotUserData;
                                         dispatch_semaphore_signal(sema);
                                     } onFailure:^(NSError *error) {
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                         dispatch_semaphore_signal(sema);
                                     }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
}

- (void)testLikes {
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSString *userToken = [Config objectForKey:@"moderator user auth token"];

    [LFWriteClient likeContent:[Config objectForKey:@"content"]
                       forUser:userToken
                  collection:[Config objectForKey:@"collection"]
                     network:[Config objectForKey:@"domain"]
                       onSuccess:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } onFailure:^(NSError *error) {
                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
    
    res = nil;
    [LFWriteClient unlikeContent:[Config objectForKey:@"content"]
                       forUser:userToken
                  collection:[Config objectForKey:@"collection"]
                     network:[Config objectForKey:@"domain"]
                       onSuccess:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } onFailure:^(NSError *error) {
                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
}

- (void)testPost {
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSString *userToken = [Config objectForKey:@"moderator user auth token"];
    NSUInteger ran = arc4random();
    
    [LFWriteClient postContent:[NSString stringWithFormat:@"test post, %d", ran]
                       forUser:userToken
                     inReplyTo:nil
                  forCollection:[Config objectForKey:@"collection"]
                     network:[Config objectForKey:@"domain"]
                       onSuccess:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } onFailure:^(NSError *error) {
                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
    
    //in reply to
    NSString *parent = [Config objectForKey:@"content"];
    ran = arc4random();
    [LFWriteClient postContent:[NSString stringWithFormat:@"test reply, %d", ran]
                       forUser:userToken
                     inReplyTo:parent
                  forCollection:[Config objectForKey:@"collection"]
                     network:[Config objectForKey:@"domain"]
                       onSuccess:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } onFailure:^(NSError *error) {
                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));

    NSString *prent = [[[[[res objectForKey:@"data"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"content"] objectForKey:@"parentId"];
    STAssertEqualObjects(prent, parent, @"This response should have been a child.");
    
    //share to
//    ran = arc4random();
//    [LFWriteClient postContent:[NSString stringWithFormat:@"test reply, %d", ran]
//                       forUser:userToken
//                     inReplyTo:nil
//                       shareTo:@[kShareTypeTwitter]
//                  inCollection:@"10665123"
//                     onNetwork:[Config objectForKey:@"domain"]
//                       success:^(NSDictionary *content) {
//                           res = content;
//                           dispatch_semaphore_signal(sema);
//                       } failure:^(NSError *error) {
//                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
//                           dispatch_semaphore_signal(sema);
//                       }];
//    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
//    STAssertEqualObjects(prent, parent, @"This response should have been a child.");
//    NSLog(@"Successfully posted w/ shareTo");
}

//- (void)testStream {
//    __block NSDictionary *res;
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//    
//    LFStreamClient *streamer = [LFStreamClient new];
//    [streamer startStreamForCollection:[Config objectForKey:@"collection"]
//                             fromEvent:@"2648462675" //the past
//                             onNetwork:[Config objectForKey:@"domain"]
//                               success:^(NSDictionary *updates) {
//                                   res = updates;
//                                   dispatch_semaphore_signal(sema);
//                               } failure:^(NSError *error) {
//                                   NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
//                                   dispatch_semaphore_signal(sema);
//                               }];
//    
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    NSLog(@"Successfully streamed");
//    
//    [streamer stopStreamForCollection:[Config objectForKey:@"collection"]];
//}

- (void)testFlag {
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [LFWriteClient flagContent:[Config objectForKey:@"content"]
                 forCollection:[Config objectForKey:@"collection"]
                       network:[Config objectForKey:@"domain"]
                      withFlag:OFF_TOPIC
                          user:[Config objectForKey:@"moderator user auth token"]
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

    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
}
@end
