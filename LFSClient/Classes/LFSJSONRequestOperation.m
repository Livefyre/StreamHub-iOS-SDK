//
//  LFJSONRequestOperation.m
//  LFSClient
//
//  Created by Eugene Scherba on 8/20/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFSJSONRequestOperation.h"
#import "JSONKit.h"

static const NSString *const kLFSResponseTimeout = @"timeout";
static const NSString *const kLFSResponseHost = @"h";

static dispatch_queue_t json_request_operation_processing_queue() {
    static dispatch_queue_t lf_json_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lf_json_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.json-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return lf_json_request_operation_processing_queue;
}

@interface LFSJSONRequestOperation ()
@property (readwrite, nonatomic, strong) id responseJSON;
@property (readwrite, nonatomic, strong) NSError *JSONError;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation LFSJSONRequestOperation
@synthesize responseJSON = _responseJSON;
@synthesize JSONReadingOptions = _JSONReadingOptions;
@synthesize JSONError = _JSONError;
@dynamic lock;

+ (instancetype)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
										success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
										failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    LFSJSONRequestOperation *requestOperation = [(LFSJSONRequestOperation *)[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (success) {
            success(operation.request, operation.response, responseJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(LFSJSONRequestOperation *)operation responseJSON]);
        }
    }];
    
    return requestOperation;
}

// Override responseJSON to provide customized JSON parsing
- (id)responseJSON {
    [self.lock lock];
    if (!_responseJSON && [self.responseData length] > 0 && [self isFinished] && !self.JSONError)
    {
        NSError *error = nil;
        JSONDecoder *decoder = [JSONDecoder decoderWithParseOptions:(JKParseOptionTruncateNumbers | self.JSONReadingOptions)];
        id responseJSON = [decoder objectWithData:self.responseData error:&error];
        [self setResponseJSON:responseJSON withError:error];
    }
    [self.lock unlock];
    
    return _responseJSON;
}

- (void)setResponseJSON:(id)responseJSON withError:(NSError*)error
{
    if (error) {
        self.JSONError = error;
        _responseJSON = nil;
    } else {
        [self setResponseJSON:responseJSON];
    }
}

// TODO: better to unwrap JSON envelopes in appropriate methods in LFSBaseClient subclasses
- (void)setResponseJSON:(id)responseJSON
{
    NSString *status = nil;
    NSNumber *code = nil;
    if (!responseJSON)
    {
        // Empty payload
        _responseJSON = nil;
        self.JSONError = [NSError errorWithDomain:NSURLErrorDomain
                                             code:NSURLErrorZeroByteResource
                                         userInfo:@{NSLocalizedDescriptionKey:@"Response failed to return data."}];
    }
    else if (![responseJSON respondsToSelector:@selector(objectForKey:)])
    {
        // Payload of wrong type
        NSString *errorTemplate = @"Response was parsed as type `%@' whereas a dictionary was expected";
        NSString *errorDescription = [NSString stringWithFormat:errorTemplate,
                                      NSStringFromClass([responseJSON class])];
        _responseJSON = nil;
        self.JSONError = [NSError errorWithDomain:NSURLErrorDomain
                                             code:NSURLErrorCannotParseResponse
                                         userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
    }
    else if ((status = [responseJSON objectForKey:@"status"]) &&
             (code = [responseJSON objectForKey:@"code"]))
    {
        NSString *msg;
        if ([status isEqualToString:@"ok"])
        {
            // Unwrap API Envelope:
            // https://github.com/Livefyre/livefyre-docs/wiki/StreamHub-API-Reference#wiki-api-envelope
            _responseJSON = [responseJSON objectForKey:@"data"];
        }
        else if ((msg = [responseJSON objectForKey:@"msg"]))
        {
            // Report error with message
            NSInteger codeValue = [code integerValue];
            NSString *errorMsg = [NSString stringWithFormat:@"Error %d: %@", codeValue, msg];
            _responseJSON = nil;
            self.JSONError = [NSError errorWithDomain:LFSErrorDomain
                                                 code:codeValue
                                             userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        }
        else
        {
            // Report error with error code
            NSInteger codeValue = [code integerValue];
            NSString *errorMsg = [NSString stringWithFormat:@"Error %d (No Description Available)", codeValue];
            _responseJSON = nil;
            self.JSONError = [NSError errorWithDomain:LFSErrorDomain
                                                 code:codeValue
                                             userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        }
    }
    else if ([responseJSON objectForKey:LFSNetworkSettings] &&
             [responseJSON objectForKey:LFSHeadDocument] &&
             [responseJSON objectForKey:LFSCollectionSettings] &&
             [responseJSON objectForKey:LFSSiteSettings])
    {
        // Pass whole response (no unwrapping)
        _responseJSON = responseJSON;
    }
    else if ([responseJSON objectForKey:kLFSResponseTimeout] && [[responseJSON objectForKey:kLFSResponseTimeout] boolValue]) {
        // timeout
        NSString *host = [responseJSON objectForKey:kLFSResponseHost];
        _responseJSON = nil;
        self.JSONError = [NSError errorWithDomain:NSURLErrorDomain
                                             code:NSURLErrorTimedOut
                                         userInfo:@{NSURLErrorFailingURLStringErrorKey:host}];
    } else {
        // Unknown response type
        NSString *errorText = @"Unexpected response.";
        _responseJSON = nil;
        self.JSONError = [NSError errorWithDomain:LFSErrorDomain
                                             code:0
                                         userInfo:@{NSLocalizedDescriptionKey:errorText}];
    }
}

- (NSError *)error {
    if (_JSONError) {
        return _JSONError;
    } else {
        return [super error];
    }
}

#pragma mark - LFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"application/x-javascript", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[[request URL] pathExtension] isEqualToString:@"json"] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    
    self.completionBlock = ^ {
        if (self.error) {
            if (failure) {
                dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                    failure(self, self.error);
                });
            }
        } else {
            dispatch_async(json_request_operation_processing_queue(), ^{
                id JSON = self.responseJSON;
                
                if (self.error) {
                    if (failure) {
                        dispatch_async(self.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                            failure(self, self.error);
                        });
                    }
                } else {
                    if (success) {
                        dispatch_async(self.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                            success(self, JSON);
                        });
                    }
                }
            });
        }
    };
#pragma clang diagnostic pop
}

@end
