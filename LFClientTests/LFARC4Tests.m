//
//  ARC4Tests.m
//  LivefyreClient
//
//  Created by Thomas Goyne on 5/29/12.
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

#import "LFARC4Tests.h"

#import "LFARC4.h"

@implementation LFARC4Tests
- (void)testDecrypt {
    const char rawKey[] = "secret key"; // 736563726574206B6579
    NSString *cipherText = @"0DC9D79D144D7B0C491F2ACF8F8B9B";
    NSString *plainText = @"a sample string";

    NSMutableString *key = [NSMutableString stringWithCapacity:(sizeof(rawKey) * 2)];
    for (size_t i = 0; i < sizeof(rawKey) - 1; ++i) {
        [key appendFormat:@"%02X", (unsigned char)rawKey[i]];
    }

    NSString *decrypted = [LFARC4 decrypt:cipherText withKey:key];
    STAssertEqualObjects(decrypted, plainText, nil);
}
@end
