//
//  NSString+QueryString.h
//  LivefyreClient
//
//  Created by zjj on 1/7/13.
//
//

@interface NSString(QueryString)
//Returns a query string beginning with '?' and with each key/value pair 
//joined by a '=' and separated by a '&'. 
- (NSString *)initWithParams:(NSDictionary *)params;
@end
