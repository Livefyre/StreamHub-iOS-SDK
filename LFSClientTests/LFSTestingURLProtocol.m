//
//  LFTestingURLProtocol.m
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

#import "LFSTestingURLProtocol.h"
#import "LFSClient.h"

@implementation LFSTestingURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [[[request URL] scheme] isEqualToString:LFSScheme];
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
    NSURL *url = request.URL;
    NSHTTPURLResponse *response =
    [[NSHTTPURLResponse alloc] initWithURL:url MIMEType:@"application/json" expectedContentLength:-1 textEncodingName:nil];

    NSString *resourcePath = [[url.host componentsSeparatedByString:@"."] objectAtIndex:1];
    if (!resourcePath) {
        [NSException raise:@"Spoof Network Fail" format:@"Fix your test methodology, it's bad and you should feel bad."];
    }

    NSString *spoofPath = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"json"];
    NSData *responseData = [NSData dataWithContentsOfFile:spoofPath];
    
    id client = self.client;
    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self didLoadData:responseData];
    [client URLProtocolDidFinishLoading:self];
}


@end
