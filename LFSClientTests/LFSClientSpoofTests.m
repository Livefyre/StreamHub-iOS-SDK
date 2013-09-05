//
//  LFSClientSpoofTests.m
//  LFSClient
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

#import <SenTestingKit/SenTestingKit.h>

#import "LFSTestingURLProtocol.h"
#import "LFSClient.h"
#import "LFSConfig.h"
#import "LFSBoostrapClient.h"
#import "LFSAdminClient.h"
#import "LFSWriteClient.h"

#define EXP_SHORTHAND YES
#import "Expecta.h"


@interface LFSClientSpoofTests : SenTestCase
@end

@interface LFSClientSpoofTests()
@property (readwrite, nonatomic, strong) LFSBoostrapClient *client;
@property (readwrite, nonatomic, strong) LFSBoostrapClient *clientHottest;
@property (readwrite, nonatomic, strong) LFSBoostrapClient *clientUserContent;
@property (readwrite, nonatomic, strong) LFSAdminClient *clientAdmin;
@property (readwrite, nonatomic, strong) LFSWriteClient *clientLike;
@property (readwrite, nonatomic, strong) LFSWriteClient *clientPost;
@property (readwrite, nonatomic, strong) LFSWriteClient *clientFlag;
@end

@implementation LFSClientSpoofTests
- (void)setUp
{
    [super setUp];
    //These tests are nominal.
    [NSURLProtocol registerClass:[LFSTestingURLProtocol class]];
    
    self.client = [LFSBoostrapClient clientWithEnvironment:nil network:@"init-sample"];
    self.clientHottest = [LFSBoostrapClient clientWithEnvironment:nil network:@"hottest-sample"];
    self.clientUserContent = [LFSBoostrapClient clientWithEnvironment:nil network:@"usercontent-sample"];
    
    self.clientAdmin = [LFSAdminClient clientWithEnvironment:nil network:@"usercontent-sample"];
    
    self.clientLike = [LFSWriteClient clientWithEnvironment:nil network:@"like-sample"];
    self.clientPost = [LFSWriteClient clientWithEnvironment:nil network:@"post-sample"];
    self.clientFlag = [LFSWriteClient clientWithEnvironment:nil network:@"flag-sample"];
    
    // set timeout to 60 seconds
    [Expecta setAsynchronousTestTimeout:60.0f];
}

- (void)tearDown
{
    // Tear-down code here.
    [NSURLProtocol unregisterClass:[LFSTestingURLProtocol class]];
    
    // cancelling all operations just in case (not strictly required)
    for (NSOperation *operation in self.client.operationQueue.operations) {
        [operation cancel];
    }
    self.client = nil;
    
    [super tearDown];
}

#pragma mark - Test Bootstrap Client
- (void)testLFHTTPClient
{
    // Get Init
    __block LFSJSONRequestOperation *op0 = nil;
    
    // This is the easiest way to use LFHTTPClient
    __block NSDictionary *bootstrapInitInfo = nil;
    [self.client getInitForSite:@"fakeSite"
                        article:@"fakeArticle"
                      onSuccess:^(NSOperation *operation, id JSON){
                          op0 = (LFSJSONRequestOperation*)operation;
                          bootstrapInitInfo = JSON;
                      }
                      onFailure:^(NSOperation *operation, NSError *error) {
                          op0 = (LFSJSONRequestOperation*)operation;
                          NSLog(@"Error code %d, with description %@",
                                error.code,
                                [error localizedDescription]);
                      }
     ];
    
    // Wait 'til done and then verify that everything is OK
    expect(op0.isFinished).will.beTruthy();
    expect(op0).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op0.error).notTo.equal(NSURLErrorTimedOut);
    // Collection dictionary should have 4 keys: headDocument, collectionSettings, networkSettings, siteSettings
    expect(bootstrapInitInfo).to.haveCountOf(4);
    
    
    // Get Page 1
    __block NSDictionary *contentInfo1 = nil;
    __block LFSJSONRequestOperation *op1 = nil;
    [self.client getContentForPage:0
                         onSuccess:^(NSOperation *operation, id JSON){
                             op1 = (LFSJSONRequestOperation*)operation;
                             contentInfo1 = JSON;
                         }
                         onFailure:^(NSOperation *operation, NSError *error) {
                             op1 = (LFSJSONRequestOperation*)operation;
                             NSLog(@"Error code %d, with description %@",
                                   error.code,
                                   [error localizedDescription]);
                         }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op1.isFinished).will.beTruthy();
    //expect(op1).to.beInstanceOf([LFJSONRequestOperation class]);
    //expect(op1.error).notTo.equal(NSURLErrorTimedOut);
    expect(contentInfo1).to.beTruthy();
    
    // Get Page 2
    __block NSDictionary *contentInfo2 = nil;
    __block LFSJSONRequestOperation *op2 = nil;
    [self.client getContentForPage:1
                         onSuccess:^(NSOperation *operation, id JSON){
                             op2 = (LFSJSONRequestOperation*)operation;
                             contentInfo2 = JSON;
                         }
                         onFailure:^(NSOperation *operation, NSError *error) {
                             op2 = (LFSJSONRequestOperation*)operation;
                             NSLog(@"Error code %d, with description %@",
                                   error.code,
                                   [error localizedDescription]);
                         }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op2.isFinished).will.beTruthy();
    expect(op2).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op2.error).notTo.equal(NSURLErrorTimedOut);
    expect(contentInfo2).to.beTruthy();
}

#pragma mark -
- (void)testHeatAPIWithGetHottestCollections
{
    __block LFSJSONRequestOperation *op = nil;
    __block NSArray *result = nil;
    
    // Actual call would look something like this:
    [self.clientHottest getHottestCollectionsForSite:@"site"
                                                 tag:@"taggy"
                                      desiredResults:10u
                                           onSuccess:^(NSOperation *operation, id responseObject) {
                                               op = (LFSJSONRequestOperation *)operation;
                                               result = (NSArray *)responseObject;
                                           } onFailure:^(NSOperation *operation, NSError *error) {
                                               op = (LFSJSONRequestOperation *)operation;
                                               NSLog(@"Error code %d, with description %@",
                                                     error.code,
                                                     [error localizedDescription]);
                                           }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
    expect(result).to.beKindOf([NSArray class]);
    expect(result).to.haveCountOf(10u);
}


#pragma mark -
- (void)testUserDataWithGetContentForUser
{
    __block LFSJSONRequestOperation *op = nil;
    __block NSArray *result = nil;
    
    // Actual call would look something like this:
    [self.clientUserContent getUserContentForUser:@"fakeUser"
                                            token:nil
                                         statuses:nil
                                           offset:nil
                                        onSuccess:^(NSOperation *operation, id responseObject) {
                                            op = (LFSJSONRequestOperation *)operation;
                                            result = (NSArray *)responseObject;
                                        } onFailure:^(NSOperation *operation, NSError *error) {
                                            op = (LFSJSONRequestOperation *)operation;
                                            NSLog(@"Error code %d, with description %@",
                                                  error.code,
                                                  [error localizedDescription]);
                                        }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
    expect(result).to.beKindOf([NSArray class]);
    expect(result).to.haveCountOf(12u);
}

#pragma mark - Test Admin Client
- (void)testUserAuthentication1
{
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Actual call would look something like this:
    [self.clientAdmin authenticateUserWithToken:@"fakeToken"
                                     collection:@"fakeColl"
                                      onSuccess:^(NSOperation *operation, id responseObject) {
                                          op = (LFSJSONRequestOperation *)operation;
                                          result = (NSArray *)responseObject;
                                      }
                                      onFailure:^(NSOperation *operation, NSError *error) {
                                          op = (LFSJSONRequestOperation *)operation;
                                          NSLog(@"Error code %d, with description %@",
                                                error.code,
                                                [error localizedDescription]);
                                      }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
}

#pragma mark -
- (void)testUserAuthentication2
{
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Actual call would look something like this:
    [self.clientAdmin authenticateUserWithToken:@"fakeToken"
                                           site:@"fakeSite"
                                        article:@"fakeArticle"
                                      onSuccess:^(NSOperation *operation, id responseObject) {
                                          op = (LFSJSONRequestOperation *)operation;
                                          result = (NSArray *)responseObject;
                                      }
                                      onFailure:^(NSOperation *operation, NSError *error) {
                                          op = (LFSJSONRequestOperation *)operation;
                                          NSLog(@"Error code %d, with description %@",
                                                error.code,
                                                [error localizedDescription]);
                                      }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
}

#pragma mark - Test Write Client
- (void)testLikes
{
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Actual call would look something like this:
    [self.clientLike postOpinion:LFSOpinionLike
                         forUser:@"fakeUserToken"
                      forContent:@"fakeContent"
                    inCollection:@"fakeColl"
                       onSuccess:^(NSOperation *operation, id responseObject) {
                           op = (LFSJSONRequestOperation*)operation;
                           result = responseObject;
                       }
                       onFailure:^(NSOperation *operation, NSError *error) {
                           op = (LFSJSONRequestOperation*)operation;
                           NSLog(@"Error code %d, with description %@",
                                 error.code,
                                 [error localizedDescription]);
                       }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
}

#pragma mark -
- (void)testPost
{
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Actual call would look something like this:
    NSString *content = [NSString
                         stringWithFormat:@"test post, %d",
                         arc4random()];
    [self.clientPost postNewContent:content
                         forUser:@"fakeUser"
                   forCollection:@"fakeColl"
                       inReplyTo:nil
                       onSuccess:^(NSOperation *operation, id responseObject) {
                           op = (LFSJSONRequestOperation*)operation;
                           result = responseObject;
                       }
                       onFailure:^(NSOperation *operation, NSError *error) {
                           op = (LFSJSONRequestOperation*)operation;
                           NSLog(@"Error code %d, with description %@",
                                 error.code,
                                 [error localizedDescription]);
                       }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
}

#pragma mark -
- (void)testFlag
{
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Actual call would look something like this:
    [self.clientFlag postFlag:LFSFlagOfftopic
                      forUser:@"fakeUserToken"
                   forContent:@"fakeContent"
                 inCollection:@"fakeCollection"
                   parameters:@{@"notes":@"fakeNotes", @"email":@"fakeEmail"}
                    onSuccess:^(NSOperation *operation, id responseObject) {
                        op = (LFSJSONRequestOperation*)operation;
                        result = responseObject;
                    }
                    onFailure:^(NSOperation *operation, NSError *error) {
                        op = (LFSJSONRequestOperation*)operation;
                        NSLog(@"Error code %d, with description %@",
                              error.code,
                              [error localizedDescription]);
                    }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
}


//- (void)testStream {
//    __block NSDictionary *res = nil;
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


@end
