//
//  LFClientTests.m
//  LFClientTests
//
//  Created by zjj on 1/14/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

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
                                 forSite:[Config objectForKey:@"site"]
                               onNetwork:[Config objectForKey:@"domain"]
                         withEnvironment:[Config objectForKey:@"environment"]
                                 success:^(NSDictionary *collection) {
                                     coll = collection;
                                     dispatch_semaphore_signal(sema);
                                 }
                                 failure:^(NSError *error) {
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

    [LFPublicAPIClient getTrendingCollectionsForTag:@"tag"
                                             forSite:[Config objectForKey:@"site"]
                                          onNetwork:[Config objectForKey:@"domain"]
                                     desiredResults:10
                                            success:^(NSArray *results) {
                                                res = results;
                                                dispatch_semaphore_signal(sema);
                                            } failure:^(NSError *error) {
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
                                   onNetwork:[Config objectForKey:@"labs network"]
                                 forStatuses:nil
                                  withOffset:nil
                                     success:^(NSArray *results) {
                                         res = results;
                                         dispatch_semaphore_signal(sema);
                                   } failure:^(NSError *error) {
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
                                  forArticle:[Config objectForKey:@"article"]
                                     forSite:[Config objectForKey:@"site"]
                                   onNetwork:[Config objectForKey:@"domain"]
                                     success:^(NSDictionary *gotUserData) {
                                         res = gotUserData;
                                         dispatch_semaphore_signal(sema);
                                     } failure:^(NSError *error) {
                                         NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                         dispatch_semaphore_signal(sema);
                                     }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
    
    //with collection id
    res = nil;    
    [LFAdminClient authenticateUserWithToken:userToken
                               forCollection:[Config objectForKey:@"collection"]
                                  forArticle:nil
                                     forSite:nil
                                   onNetwork:[Config objectForKey:@"domain"]
                                     success:^(NSDictionary *gotUserData) {
                                         res = gotUserData;
                                         dispatch_semaphore_signal(sema);
                                     } failure:^(NSError *error) {
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
                  inCollection:[Config objectForKey:@"collection"]
                     onNetwork:[Config objectForKey:@"domain"]
                       success:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } failure:^(NSError *error) {
                           NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    STAssertEqualObjects([res objectForKey:@"status"], @"ok", @"This response should have been ok");
    
    res = nil;
    [LFWriteClient unlikeContent:[Config objectForKey:@"content"]
                       forUser:userToken
                  inCollection:[Config objectForKey:@"collection"]
                     onNetwork:[Config objectForKey:@"domain"]
                       success:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } failure:^(NSError *error) {
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
                  inCollection:[Config objectForKey:@"collection"]
                     onNetwork:[Config objectForKey:@"domain"]
                       success:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } failure:^(NSError *error) {
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
                  inCollection:[Config objectForKey:@"collection"]
                     onNetwork:[Config objectForKey:@"domain"]
                       success:^(NSDictionary *content) {
                           res = content;
                           dispatch_semaphore_signal(sema);
                       } failure:^(NSError *error) {
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

- (void)testStream {
    __block NSDictionary *res;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    LFStreamClient *streamer = [LFStreamClient new];
    [streamer startStreamForCollection:[Config objectForKey:@"collection"]
                             fromEvent:@"2648462675" //the past
                             onNetwork:[Config objectForKey:@"domain"]
                               success:^(NSDictionary *updates) {
                                   res = updates;
                                   dispatch_semaphore_signal(sema);
                               } failure:^(NSError *error) {
                                   NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                   dispatch_semaphore_signal(sema);
                               }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"Successfully streamed");
    
    [streamer stopStreamForCollection:[Config objectForKey:@"collection"]];
}
@end
