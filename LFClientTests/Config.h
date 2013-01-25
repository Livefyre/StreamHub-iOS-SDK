//
//  Config.h
//  LivefyreClient
//
//  Created by Thomas Goyne on 5/27/12.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (id)objectForKey:(id)key;
@property (strong, nonatomic) NSCondition *condition;
@end
