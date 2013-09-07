//
//  LFSStreamClient.m
//  LFSClient
//
//  Created by Eugene Scherba on 9/3/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFSStreamClient.h"

// Various constants to help with parsing JSON files
static const NSString *const kLFSMaxEventId = @"maxEventId";

@interface LFSStreamClient ()

@property (nonatomic, strong) LFSSuccessBlock successBlock;
@property (nonatomic, strong) LFSFailureBlock failureBlock;
@property (nonatomic, strong) LFHandleBlock resultHandler;

@end

@implementation LFSStreamClient

@synthesize collectionId = _collectionId;
@synthesize collectionStreamURLString = _collectionStreamURLString;
@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;
@synthesize resultHandler = _resultHandler;
@synthesize eventId = _eventId;

#pragma mark - Overrides
// TODO: implement ring with consistent hashing for managing streams
-(NSString*)subdomain { return @"stream1"; }

- (instancetype)initWithEnvironment:(NSString *)environment
                            network:(NSString *)network
{
    self = [super initWithNetwork:network environment:environment];
    if (self) {
        _collectionId = nil;
        _collectionStreamURLString = nil;
        _successBlock = nil;
        _failureBlock = nil;
        _resultHandler = nil;
        _eventId = nil;
    }
    return self;
}

#pragma mark - Properties

- (void)setCollectionId:(NSString *)collectionId
{
    _collectionId = collectionId;
    _collectionStreamURLString = nil;
}

- (NSURL*)collectionStreamURLString
{
    if (_collectionStreamURLString != nil) {
        return _collectionStreamURLString;
    } else {
        NSString *component = [NSString stringWithFormat:@"v3.0/collection/%@", _collectionId];
        _collectionStreamURLString = [self.baseURL URLByAppendingPathComponent:component];
        return _collectionStreamURLString;
    }
}

#pragma mark - Public methods
- (void)setResultHandler:(LFHandleBlock)handler
                 success:(LFSSuccessBlock)success
                 failure:(LFSFailureBlock)failure
{
    self.resultHandler = handler;
    self.successBlock = success;
    self.failureBlock = failure;
}

- (void)stopStream
{
    [self.operationQueue cancelAllOperations];
}

- (void)pauseStream
{
    [self.operationQueue setSuspended:YES];
}

-(void)resumeStream
{
    [self.operationQueue setSuspended:NO];
    [self startStreamWithEventId:nil];
}

- (void)startStream
{
    [self startStreamWithEventId:nil];
}

- (void)startStreamWithEventId:(NSNumber*)eventId
{
    if ([self.operationQueue isSuspended]) {
        return;
    }
    LFSJSONRequestOperation *op =
    (LFSJSONRequestOperation *)[self HTTPRequestOperationWithRequest:[self buildRequestWithEventId:eventId]
                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                 
                                                                 if (self.successBlock) {
                                                                     self.successBlock(operation, responseObject);
                                                                 } else {
                                                                     // if success block is not provided, manually reschedule
                                                                     // polling
                                                                     NSDictionary *json = (NSDictionary*)responseObject;
                                                                     // received data
                                                                     if (self.resultHandler) {
                                                                         self.resultHandler(responseObject);
                                                                     }
                                                                     NSNumber *maxEventId = [json objectForKey:kLFSMaxEventId];
                                                                     // issue another request
                                                                     [self startStreamWithEventId:maxEventId];
                                                                 }
                                                             }
                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                 
                                                                 if (self.failureBlock) {
                                                                     // developer can choose to restart
                                                                     // by providing a custom failure block
                                                                     self.failureBlock(operation, error);
                                                                 } else if (error.domain == NSURLErrorDomain &&
                                                                            error.code == NSURLErrorTimedOut) {
                                                                     // time out
                                                                     [self performSelector:@selector(startStreamWithEventId:)
                                                                                withObject:eventId
                                                                                afterDelay:2.0];
                                                                 }
                                                             }];
    
    [self enqueueHTTPRequestOperation:op];
}

#pragma mark - Private methods

- (NSURLRequest*)buildRequestWithEventId:(NSNumber*)eventId
{
    if (eventId != nil) {
        // cache current value
        self.eventId = eventId;
    } else {
        // try using cached event id if nil
        eventId = self.eventId;
    }
    NSURL *streamURL = (eventId == nil)
    ? self.collectionStreamURLString
    : [self.collectionStreamURLString URLByAppendingPathComponent:[eventId stringValue]];
    return [self requestWithMethod:@"GET"
                              path:[streamURL absoluteString]
                        parameters:nil];
}


@end
