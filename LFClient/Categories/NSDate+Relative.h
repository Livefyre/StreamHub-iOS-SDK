//
//  NSDate+Relative.h
//  LivefyreClient
//
//  Created by Thomas Goyne on 8/29/12.
//

@interface NSDate (Relative)
// Returns fuzzy, human readable, time deltas.
- (NSString *)relativeTime;
@end
