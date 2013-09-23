//
//  LFSClientTests.m
//  LFSClientTests
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


#import <SenTestingKit/SenTestingKit.h>
#import <Base64/MF_Base64Additions.h>
#import <AFHTTPRequestOperationLogger/AFHTTPRequestOperationLogger.h>

#import "LFSClient.h"
#import "LFSConfig.h"
#import "LFSStreamClient.h"
#import "LFSBootstrapClient.h"
#import "LFSAdminClient.h"
#import "LFSWriteClient.h"
#import "LFSJSONRequestOperation.h"

#define EXP_SHORTHAND YES
#import <Expecta/Expecta.h>

@interface LFSClientNetworkTests : SenTestCase
@end

@implementation LFSClientNetworkTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    if (![LFSConfig objectForKey:@"domain"]) {
        STFail(@"No test settings");
    }
    
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    
    // set timeout to 60 seconds
    [Expecta setAsynchronousTestTimeout:600.0f];
}

- (void)tearDown
{
    // Tear-down code here.
    [[AFHTTPRequestOperationLogger sharedLogger] stopLogging];
    
    [super tearDown];
}

#pragma mark - Get init
- (void)testInitWithLFJSONRequestOperation
{
    __block id result = nil;
    
    // Most complicated way to use LFHTTPClient... Nevertheless it should work
    NSString* path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/init",
                      [LFSConfig objectForKey:@"domain"],
                      [LFSConfig objectForKey:@"site"],
                      [[LFSConfig objectForKey:@"article"] base64String]];
    
    LFSBootstrapClient *client = [LFSBootstrapClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                       environment:[LFSConfig objectForKey:@"environment"]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
    LFSJSONRequestOperation *op = [LFSJSONRequestOperation
                                   JSONRequestOperationWithRequest:request
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                       result = JSON;
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                       NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                   }];
    [client enqueueHTTPRequestOperation:op];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(op.response.statusCode).to.equal(200);
    // Collection dictionary should have 4 keys: headDocument, collectionSettings, networkSettings, siteSettings
    expect(result).to.haveCountOf(4);
}

- (void)testInitWithGetPath
{
    __block AFHTTPRequestOperation *op = nil;
    __block id result = nil;
    
    // Second easiest way to use LFHTTPClient
    NSString* path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/init",
                      [LFSConfig objectForKey:@"domain"],
                      [LFSConfig objectForKey:@"site"],
                      [[LFSConfig objectForKey:@"article"] base64String]];
    
    LFSBootstrapClient *client = [LFSBootstrapClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                           environment:[LFSConfig objectForKey:@"environment"]];
    [client getPath:path
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id JSON){
                     op = operation;
                     result = JSON;
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     op = operation;
                     NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                 }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    // Collection dictionary should have 4 keys: headDocument, collectionSettings, networkSettings, siteSettings
    expect(result).to.haveCountOf(4);
}

- (void)testInitWithGetInitForArticle
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // This is the easiest way to use LFHTTPClient
    LFSBootstrapClient *client = [LFSBootstrapClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                           environment:[LFSConfig objectForKey:@"environment"]];
    [client getInitForSite:[LFSConfig objectForKey:@"site"]
                        article:[LFSConfig objectForKey:@"article"]
                      onSuccess:^(NSOperation *operation, id JSON){
                          op = (LFSJSONRequestOperation*)operation;
                          result = JSON;
                      }
                      onFailure:^(NSOperation *operation, NSError *error) {
                          op = (LFSJSONRequestOperation*)operation;
                          NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                      }
     ];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    // Collection dictionary should have 4 keys: headDocument, collectionSettings, networkSettings, siteSettings
    expect(result).to.haveCountOf(4);
}

#pragma mark - Retrieve Hottest Collections
- (void)testHeatAPIWithGetHottestCollections
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block NSArray *result = nil;
    
    // Actual call would look something like this:
    LFSBootstrapClient *client = [LFSBootstrapClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                           environment:[LFSConfig objectForKey:@"environment"]];
    [client getHottestCollectionsForSite:[LFSConfig objectForKey:@"site"]
                                          tag:@"tag"
                               desiredResults:10u
                                    onSuccess:^(NSOperation *operation, id responseObject) {
                                        op = (LFSJSONRequestOperation *)operation;
                                        result = (NSArray *)responseObject;
                                    } onFailure:^(NSOperation *operation, NSError *error) {
                                        op = (LFSJSONRequestOperation *)operation;
                                        NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                    }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
}

#pragma mark - Retrieve User Data
- (void)testUserDataRetrieval
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block NSArray *result = nil;
    
    // Actual call would look something like this:
    LFSBootstrapClient *clientLabs = [LFSBootstrapClient clientWithNetwork:[LFSConfig objectForKey:@"labs network"] environment:[LFSConfig objectForKey:@"environment"]];
    [clientLabs getUserContentForUser:[LFSConfig objectForKey:@"system user"]
                                token:nil
                             statuses:nil
                               offset:0
                            onSuccess:^(NSOperation *operation, id responseObject) {
                                op = (LFSJSONRequestOperation *)operation;
                                result = (NSArray *)responseObject;
                            } onFailure:^(NSOperation *operation, NSError *error) {
                                op = (LFSJSONRequestOperation *)operation;
                                NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                            }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
}

#pragma mark - Test user authentication
- (void)testUserAuthenticationSiteArticle {
    //with collection id
    __block LFSJSONRequestOperation *op = nil;
    __block NSDictionary *result = nil;
    
    NSString *userToken = [LFSConfig objectForKey:@"moderator user auth token"];
    
    LFSAdminClient *clientAdmin = [LFSAdminClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                   environment:nil ];
    [clientAdmin authenticateUserWithToken:userToken
                                      site:[LFSConfig objectForKey:@"site"]
                                   article:[LFSConfig objectForKey:@"article"]
                                 onSuccess:^(NSOperation *operation, id responseObject) {
                                     op = (LFSJSONRequestOperation *)operation;
                                     result = (NSDictionary *)responseObject;
                                 }
                                 onFailure:^(NSOperation *operation, NSError *error) {
                                     op = (LFSJSONRequestOperation *)operation;
                                     NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                 }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
    expect([result valueForKeyPath:@"auth_token.value"]).to.equal(userToken);
}

- (void)testUserAuthenticationCollection {
    //with collection id
    __block LFSJSONRequestOperation *op = nil;
    __block NSDictionary *result = nil;
    
    NSString *userToken = [LFSConfig objectForKey:@"moderator user auth token"];
    
    LFSAdminClient *clientAdmin = [LFSAdminClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                   environment:nil ];
    [clientAdmin authenticateUserWithToken:userToken
                                     collection:[LFSConfig objectForKey:@"collection"]
                                      onSuccess:^(NSOperation *operation, id responseObject) {
                                          op = (LFSJSONRequestOperation *)operation;
                                          result = (NSDictionary *)responseObject;
                                      }
                                      onFailure:^(NSOperation *operation, NSError *error) {
                                          op = (LFSJSONRequestOperation *)operation;
                                          NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                                      }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    expect(result).to.beTruthy();
    expect([result valueForKeyPath:@"auth_token.value"]).to.equal(userToken);
}

#pragma mark - test opines
- (void)testLikes {
    __block LFSJSONRequestOperation *op = nil;
    __block NSDictionary *result = nil;
    
    LFSWriteClient *clientWrite = [LFSWriteClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                        environment:nil ];
    [clientWrite postOpinion:LFSOpinionLike
                          forUser:[LFSConfig objectForKey:@"moderator user auth token"]
                       forContent:[LFSConfig objectForKey:@"content"]
                     inCollection:[LFSConfig objectForKey:@"collection"]
                        onSuccess:^(NSOperation *operation, id responseObject) {
                            op = (LFSJSONRequestOperation *)operation;
                            result = (NSDictionary *)responseObject;
                        }
                        onFailure:^(NSOperation *operation, NSError *error) {
                            op = (LFSJSONRequestOperation *)operation;
                            NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                        }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
}

- (void)testUnlikes {
    __block LFSJSONRequestOperation *op = nil;
    __block NSDictionary *result = nil;
    
    LFSWriteClient *clientWrite = [LFSWriteClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                        environment:nil ];
    [clientWrite postOpinion:LFSOpinionUnlike
                          forUser:[LFSConfig objectForKey:@"moderator user auth token"]
                       forContent:[LFSConfig objectForKey:@"content"]
                     inCollection:[LFSConfig objectForKey:@"collection"]
                        onSuccess:^(NSOperation *operation, id responseObject) {
                            op = (LFSJSONRequestOperation *)operation;
                            result = (NSDictionary *)responseObject;
                        }
                        onFailure:^(NSOperation *operation, NSError *error) {
                            op = (LFSJSONRequestOperation *)operation;
                            NSLog(@"Error code %d, with description %@", error.code, [error localizedDescription]);
                        }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
}

#pragma mark - test posts
- (void)testPost
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Actual call would look something like this:
    LFSWriteClient *clientWrite = [LFSWriteClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                        environment:nil ];
    [clientWrite postNewContent:[NSString stringWithFormat:@"test post, %d", arc4random()]
                             forUser:[LFSConfig objectForKey:@"moderator user auth token"]
                       forCollection:[LFSConfig objectForKey:@"collection"]
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

- (void)testPostInReplyTo
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    NSString *parent = [LFSConfig objectForKey:@"content"];
    
    // Actual call would look something like this:
    LFSWriteClient *clientWrite = [LFSWriteClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                        environment:nil ];
    [clientWrite postNewContent:[NSString stringWithFormat:@"test reply, %d", arc4random()]
                             forUser:[LFSConfig objectForKey:@"moderator user auth token"]
                       forCollection:[LFSConfig objectForKey:@"collection"]
                           inReplyTo:parent
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
    NSString *parent1 = [[[result objectForKey:@"messages"] objectAtIndex:0]
                         valueForKeyPath:@"content.parentId"];
    expect(parent1).to.equal(parent);
}

#pragma mark - test flagging
- (void)testFlag
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Actual call would look something like this:
    LFSWriteClient *clientWrite = [LFSWriteClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                        environment:nil ];
    [clientWrite postFlag:LFSFlagOfftopic
                       forUser:[LFSConfig objectForKey:@"moderator user auth token"]
                    forContent:[LFSConfig objectForKey:@"content"]
                  inCollection:[LFSConfig objectForKey:@"collection"]
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

#pragma mark - test collection creation
- (void)testCreateCollectionWithSecret
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Modify article Id to a unique one to avoid error 409
    LFSWriteClient *clientWrite = [LFSWriteClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                        environment:nil ];
    [clientWrite postNewArticle:@"justTesting7"
                             forSite:[LFSConfig objectForKey:@"site"]
                       secretSiteKey:[LFSConfig objectForKey:@"site key"]
                               title:@"La la la la"
                                tags:@[@"hey", @"hello"]
                             withURL:[NSURL URLWithString:@"http://erere.com/ererereer"]
                           onSuccess:^(NSOperation *operation, id responseObject) {
                               op = (LFSJSONRequestOperation*)operation;
                               result = responseObject;
                           }
                           onFailure:^(NSOperation *operation, NSError *error) {
                               op = (LFSJSONRequestOperation*)operation;
                               NSLog(@"Error code %d. Description: %@. Recovery Suggestion: %@",
                                     error.code,
                                     [error localizedDescription],
                                     [error localizedRecoverySuggestion]);
                           }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    if (op.error) {
        // HTTP 409:
        // Collection already exists for site_id ... and article_id ... Use update instead
        expect(op.response.statusCode).to.equal(409);
    } else {
        // HTTP 202:
        // This request is being processed
        expect(op.response.statusCode).to.equal(202);
    }
}

- (void)testCreateCollectionUnsigned
{
    //Note: this test fails when the URL is wrong (the way it's meant to be)
    __block LFSJSONRequestOperation *op = nil;
    __block id result = nil;
    
    // Modify article Id to a unique one to avoid error 409
    LFSWriteClient *clientWrite = [LFSWriteClient clientWithNetwork:[LFSConfig objectForKey:@"domain"]
                                                        environment:nil ];
    [clientWrite postNewArticle:@"justTesting8"
                             forSite:[LFSConfig objectForKey:@"site"]
                       secretSiteKey:nil
                               title:@"La la la la"
                                tags:@[@"hey", @"hello"]
                             withURL:[NSURL URLWithString:@"http://erere.com/ererereer"]
                           onSuccess:^(NSOperation *operation, id responseObject) {
                               op = (LFSJSONRequestOperation*)operation;
                               result = responseObject;
                           }
                           onFailure:^(NSOperation *operation, NSError *error) {
                               op = (LFSJSONRequestOperation*)operation;
                               NSLog(@"Error code %d. Description: %@. Recovery Suggestion: %@",
                                     error.code,
                                     [error localizedDescription],
                                     [error localizedRecoverySuggestion]);
                           }];
    
    // Wait 'til done and then verify that everything is OK
    expect(op.isFinished).will.beTruthy();
    expect(op).to.beInstanceOf([LFSJSONRequestOperation class]);
    expect(op.error).notTo.equal(NSURLErrorTimedOut);
    if (op.error) {
        // HTTP 409: Collection already exists for site_id ... and article_id .... Use update instead.
        expect(op.response.statusCode).to.equal(409);
    } else {
        // HTTP 202: This request is being processed.
        expect(op.response.statusCode).to.equal(202);
    }
}

/*
- (void)testStream {
    // Get Init
    __block LFSJSONRequestOperation *op0 = nil;
    
    // This is the easiest way to use LFHTTPClient
    __block NSDictionary *bootstrapInitInfo = nil;
    LFSBootstrapClient *clientStreamBootstrap = [LFSBootstrapClient clientWithNetwork:@"livefyre.com"
 environment:@"t402.livefyre.com"];
    [clientStreamBootstrap getInitForSite:@"303613"
                              article:@"215"
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
    
    NSDictionary *collectionSettings = [bootstrapInitInfo objectForKey:@"collectionSettings"];
    NSString *collectionId = [collectionSettings objectForKey:@"collectionId"];
    NSNumber *eventId = [collectionSettings objectForKey:@"event"];
    
    __block id result = nil;
 
    LFSStreamClient *clientStream = [LFSStreamClient clientWithNetwork:@"livefyre.com"
 environment:@"t402.livefyre.com"];
 
    [clientStream setCollectionId:collectionId];
    
    
    [clientStream setResultHandler:^(id responseObject) {
        NSLog(@"%@", responseObject);
        result = nil;
    } success:nil failure:nil];
    [clientStream startStreamWithEventId:eventId];
    
    expect(result).will.beTruthy();
    NSLog(@"%@", result);
}
*/

@end
