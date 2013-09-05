//
//  NSDictionary+QueryString.h
//  LFClient
//
//  Created by Eugene Scherba on 9/5/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QueryString)

- (NSString*)queryString;
- (NSString*)queryStringWithEncoding:(NSStringEncoding)stringEncoding;

@end
