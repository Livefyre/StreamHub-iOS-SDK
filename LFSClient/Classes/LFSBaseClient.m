//
//  LFSBaseClient.m
//  LFSClient
//
//  Created by Eugene Scherba on 8/27/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import "LFSBaseClient.h"

@interface LFSBaseClient ()
@property (readwrite, nonatomic, strong) NSMutableDictionary *defaultHeaders;
@end

@implementation LFSBaseClient

@synthesize lfEnvironment = _lfEnvironment;
@synthesize lfNetwork = _lfNetwork;
@dynamic subdomain; // implemented by subclass
@dynamic defaultHeaders; // implemented by superclass

#pragma mark - Initialization

+ (instancetype)clientWithNetwork:(NSString*)network
                      environment:(NSString *)environment
{
    return [[self alloc] initWithNetwork:network environment:environment];
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke `initWithEnvironment:network:` instead.", NSStringFromClass([self class])]
                                 userInfo:nil];
}

// this is the designated initializer
- (id)initWithNetwork:(NSString *)network
          environment:(NSString *)environment
{
    NSParameterAssert(network != nil);
    
    // cache passed parameters into readonly properties
    _lfEnvironment = environment;
    _lfNetwork = network;

    NSString *hostname = [NSString stringWithFormat:@"%@.%@",
                          [self subdomain],
                          ((environment && [network isEqualToString:@"livefyre.com"]) ? environment : network)];
    NSURL *baseURL = [[NSURL alloc] initWithScheme:LFSScheme
                            host:hostname
                            path:@"/"];
    self = [super initWithBaseURL:baseURL];
    if (self) {
        [self registerHTTPOperationClass:[LFSJSONRequestOperation class]];
    
        // Accept HTTP Header;
        // see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setParameterEncoding:AFFormURLParameterEncoding];
    }
    return self;
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
parameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding
         success:(AFSuccessBlock)success
         failure:(AFFailureBlock)failure
{
    [self postURL:[self.baseURL URLByAppendingPathComponent:path]
       parameters:parameters
parameterEncoding:parameterEncoding
          success:success
          failure:failure];
}

- (void)postURL:(NSURL *)url
     parameters:(NSDictionary *)parameters
parameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding
        success:(AFSuccessBlock)success
        failure:(AFFailureBlock)failure
{
    
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                                url:url
                                         parameters:parameters
                                  parameterEncoding:parameterEncoding];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                       url:(NSURL *)url
                                parameters:(NSDictionary *)parameters
                         parameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding
{
    NSParameterAssert(method);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    if (parameters) {
        if ([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"]) {
            url = [url URLByAppendingPathComponent:[NSString stringWithFormat:
                                                    ([[url absoluteString] rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@"),
                                                    AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding)]];
            [request setURL:url];
        } else {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            NSError *error = nil;
            
            switch (parameterEncoding) {
                case AFFormURLParameterEncoding:
                    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding) dataUsingEncoding:self.stringEncoding]];
                    break;
                case AFJSONParameterEncoding:
                    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
                    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
#pragma clang diagnostic pop
                    break;
                case AFPropertyListParameterEncoding:
                    [request setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:parameters format:NSPropertyListXMLFormat_v1_0 options:0 error:&error]];
                    break;
            }
            
            if (error) {
                NSLog(@"%@ %@: %@", [self class], NSStringFromSelector(_cmd), error);
            }
        }
    }
    return request;
}
@end
