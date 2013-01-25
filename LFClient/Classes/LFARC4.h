//
//  ARC4.h
//  LivefyreClient
//
//  Created by Thomas Goyne on 5/17/12.
//

#import <Foundation/Foundation.h>

@interface LFARC4 : NSObject
/** @name eref decoding. */

/** 
 * A method to assist with decoding content erefs using a Livefyre user's key or keys.
 *
 * @param eref The eref to attempt to decode.
 * @param keys The keys to apply to the encoded content.
 * @return NSString
 */
+ (NSString *)tryToDecodeEref:(NSString *)eref WithKeys:(NSArray *)keys;

/**
 * A method to assist with decoding Livefyre content ciphers.
 * @param string The cipher text.
 * @param key The secret key.
 * @return NSString
 */
+ (NSString *)decrypt:(NSString *)string withKey:(NSString *)key;
@end
