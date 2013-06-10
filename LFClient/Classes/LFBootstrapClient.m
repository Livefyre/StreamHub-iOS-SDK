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

@implementation LFBootstrapClient
+ (void)getInitForArticle:(NSString *)articleId
                     site:(NSString *)siteId
                  network:(NSString *)networkDomain
              environment:(NSString *)environment
                onSuccess:(void (^)(NSDictionary *))success
                onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(networkDomain != nil);
    NSParameterAssert(siteId != nil);
    NSParameterAssert(articleId != nil);
    
    NSString *host = [NSString stringWithFormat:@"%@.%@", kBootstrapDomain, networkDomain];
    NSString *path;
    if (environment) {
        path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/%@/init", environment, networkDomain, siteId, [articleId base64EncodedString]];
    } else {
        path = [NSString stringWithFormat:@"/bs3/%@/%@/%@/init", networkDomain, siteId, [articleId base64EncodedString]];
    }
    
    [self requestWithHost:host
                 path:path
              payload:nil
               method:@"GET"
            onSuccess:success
            onFailure:failure];
}

+ (void)getContentForPage:(NSUInteger)pageIndex
             withInitInfo:(NSDictionary *)initInfo
                onSuccess:(void (^)(NSDictionary *))success
                onFailure:(void (^)(NSError *))failure
{
    NSParameterAssert(pageIndex != NSNotFound);
    NSParameterAssert(initInfo != nil);
    
    // If page index is zero we already have the content as part of the init data.
    if (!pageIndex) {
        success([initInfo objectForKey:@"headDocument"]);
        return;
    }
    
    NSUInteger nPages = [[initInfo valueForKeyPath:@"collectionSettings.archiveInfo.nPages"] integerValue];
    
    if (pageIndex >= nPages) {
        failure([NSError errorWithDomain:kLFError code:400u userInfo:[NSDictionary dictionaryWithObject:@"Page index outside of collection page bounds."
                                                                                                 forKey:NSLocalizedDescriptionKey]]);
        return;
    }
    
    NSString *networkDomain = [initInfo valueForKeyPath:@"collectionSettings.networkId"];
    NSString *pageUrlPathBase = [initInfo valueForKeyPath:@"collectionSettings.archiveInfo.pathBase"];

    NSString *host = [NSString stringWithFormat:@"%@.%@", kBootstrapDomain, networkDomain];
    NSString *path = [NSString stringWithFormat:@"/bs3%@%lu.json", pageUrlPathBase, (unsigned long)pageIndex];
    
    [self requestWithHost:host
                 path:path
              payload:nil
               method:@"GET"
            onSuccess:success
            onFailure:failure];
}
@end
