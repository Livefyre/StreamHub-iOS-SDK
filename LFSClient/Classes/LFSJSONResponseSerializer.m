//
//  LFSJSONResponseSerializer.m
//  LFSClient
//
//  Created by Eugene Scherba on 4/6/14.
//  Copyright (c) 2014 Livefyre. All rights reserved.
//

#import "LFSJSONResponseSerializer.h"

NSError* getErrorFromObject(NSDictionary* object)
{
    NSInteger errorCode = [[object objectForKey:@"code"] integerValue];
    NSString *errorMessage = [NSString stringWithFormat:@"Error %zd: %@",
                              errorCode,
                              [object objectForKey:@"msg"]];
    NSString *errorType = [object objectForKey:@"error_type"];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (errorMessage != nil) {
        [dictionary setObject:errorMessage forKey:NSLocalizedDescriptionKey];
    }
    if (errorType != nil) {
        [dictionary setObject:errorType forKey:NSLocalizedFailureReasonErrorKey];
    }
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                         code:errorCode
                                     userInfo:dictionary];
    return error;
}

@interface LFSJSONResponseSerializer ()

@property (nonatomic, strong) JSONDecoder* decoder;

@end


@implementation LFSJSONResponseSerializer

@synthesize readingOptions = _readingOptions;

static NSError * AFErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

static BOOL AFErrorOrUnderlyingErrorHasCode(NSError *error, NSInteger code) {
    if (error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCode(error.userInfo[NSUnderlyingErrorKey], code);
    }
    
    return NO;
}

+ (instancetype)serializerWithReadingOptions:(JKFlags)readingOptions
{
    return [(LFSJSONResponseSerializer*)[self alloc] initWithReadingOptions:readingOptions];
}

-(id)initWithReadingOptions:(JKFlags)jkflags {
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/javascript", @"application/x-javascript", @"text/json", @"text/javascript", @"text/x-javascript", nil];
        self.decoder = [JSONDecoder decoderWithParseOptions:(JKParseOptionTruncateNumbers | jkflags)];
        
        NSMutableSet* acceptableContentTypes = [self.acceptableContentTypes mutableCopy];
        
        self.acceptableContentTypes = acceptableContentTypes;
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (AFErrorOrUnderlyingErrorHasCode(*error, NSURLErrorCannotDecodeContentData)) {
            return nil;
        }
    }
    
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    //
    // TODO: this is most certainly not necessary for Livefyre API
    //
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    id responseObject = nil;
    NSError *serializationError = nil;
    @autoreleasepool {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
        if (responseString && ![responseString isEqualToString:@" "]) {
            // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
            // See http://stackoverflow.com/a/12843465/157142
            //
            // TODO: this may not be necessary with JSONKit
            data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data) {
                if ([data length] > 0) {
                    // To use NSJSONSerialization instead of JSONKit simply replace
                    // the line below with (note that this may cause failure on some endpoints
                    // because of the large numbers problem):
                    // responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&serializationError];
                    responseObject = [self.decoder objectWithData:data error:&serializationError];
                } else {
                    return nil;
                }
            } else {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Data failed decoding as a UTF-8 string", nil, @"AFNetworking"),
                                           NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Could not decode string: %@", nil, @"AFNetworking"), responseString]
                                           };
                
                serializationError = [NSError errorWithDomain:AFNetworkingErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }
    }
    
    if ([responseObject respondsToSelector:@selector(objectForKey:)]) {
        NSString *status = [responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"ok"]) {
            responseObject = [responseObject objectForKey:@"data"];
        }
        else if ([status isEqualToString:@"error"]) {
            NSError *lfserror = getErrorFromObject(responseObject);
            *error = lfserror;
        }
    } else if (error) {
        *error = AFErrorWithUnderlyingError(serializationError, *error);
    }

    return responseObject;
}

@end
