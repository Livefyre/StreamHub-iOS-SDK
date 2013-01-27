//
//  LFTestingURLProtocol.m
//  LFClient
//
//  Created by zjj on 1/23/13.
//

#import "LFTestingURLProtocol.h"
#import "LFConstants.h"

@implementation LFTestingURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [[[request URL] scheme] isEqualToString:kLFSDKScheme];
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    [self loadSpoofData];
}

- (void)stopLoading
{
    //stop the madness
}

- (void)loadSpoofData;
{
    NSURLRequest *request = [self request];
    id client = [self client];
    NSHTTPURLResponse *response =
    [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200u HTTPVersion:@"1.1" headerFields:[request allHTTPHeaderFields]];
    
    //grabbing the networkId
    NSString *methodId;
    if ([[[[request URL] host] componentsSeparatedByString:@"."] objectAtIndex:1]) {
        methodId = [[[[request URL] host] componentsSeparatedByString:@"."] objectAtIndex:1];
    } else {
        [NSException raise:@"Spoof Network Fail" format:@"Fix your test methodology, it's bad and you should feel bad."];
    }
    
    NSString *spoofPath = [[NSBundle bundleForClass:[self class]] pathForResource:methodId ofType:@"json"];
    NSData *responseData = [[NSData alloc] initWithContentsOfFile:spoofPath];
    
    [client URLProtocol:self didReceiveResponse:response
     cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self didLoadData:responseData];
    [client URLProtocolDidFinishLoading:self];
}

@end
