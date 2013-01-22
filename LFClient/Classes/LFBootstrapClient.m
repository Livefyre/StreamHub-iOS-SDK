//
//  LFBootstrapClient.m
//  LFClient
//
//  Created by zjj on 1/14/13.
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

#import "LFBootstrapClient.h"
#import "NSString+Base64Encoding.h"

static NSString *_bootstrap = @"bootstrap";

@implementation LFBootstrapClient
+ (void)getInitForArticle:(NSString *)articleId
                  forSite:(NSString *)siteId
                onNetwork:(NSString *)networkDomain
          withEnvironment:(NSString *)environment
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failure
{
    if (!networkDomain || !siteId || !articleId) {
        failure([NSError errorWithDomain:kLFError code:400u userInfo:[NSDictionary dictionaryWithObject:@"Lacking necessary parameters to call bootstrap init."
                                                                                                 forKey:NSLocalizedDescriptionKey]]);
        return;
    }
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", _bootstrap, networkDomain];
    NSString *path;
    if (environment) {
        path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/%@/init", environment, networkDomain, siteId, [articleId base64EncodedString]];
    } else {
        path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/init", networkDomain, siteId, [articleId base64EncodedString]];
    }
    
    [self requestWithHost:host
                 WithPath:path
              WithPayload:nil
               WithMethod:@"GET"
              WithSuccess:success
              WithFailure:failure];
}
@end