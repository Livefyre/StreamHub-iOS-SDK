//
//  lftypes.h
//  LFClient
//
//  Created by Eugene Scherba on 8/22/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#ifndef LFClient_types_h
#define LFClient_types_h

#import "AFHTTPRequestOperation.h"

typedef void (^LFSuccessBlock) (NSOperation *operation, id responseObject);
typedef void (^LFFailureBlock) (NSOperation *operation, NSError *error);
typedef void (^AFSuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFFailureBlock) (AFHTTPRequestOperation *operation, NSError *error);


#endif