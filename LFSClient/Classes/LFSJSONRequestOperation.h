//
//  LFSJSONRequestOperation.h
//  LFSClient
//
//  Created by Eugene Scherba on 8/20/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "LFSConstants.h"

/**
 `LFJSONRequestOperation` is a subclass of `AFHTTPRequestOperation` for downloading and working with JSON response data.
 
 ## Acceptable Content Types
 
 By default, `LFJSONRequestOperation` accepts the following MIME types, which includes the official standard, `application/json`, as well as other commonly-used types:
 
 - `application/json`
 - `application/javascript`
 - `application/x-javascript`
 - `text/json`
 - `text/javascript`
 - `text/x-javascript`

 @note JSON parsing will use a modified copy of `JSONKit`. Numbers that over- or underflow their representing types will be truncated to their corresponding uppper or lower type bounds, respectively.
 */
@interface LFSJSONRequestOperation : AFHTTPRequestOperation

///----------------------------
/// @name Getting Response Data
///----------------------------

/**
 A JSON object constructed from the response data. If an error occurs while parsing, `nil` will be returned, and the `error` property will be set to the error.
 */
@property (readonly, nonatomic, strong) id responseJSON;

/**
 Options for reading the response JSON data and creating the Foundation objects. For possible values, see the `JSONKit` documentation section "JKParseOptionFlags".
 */
@property (nonatomic, assign) NSJSONReadingOptions JSONReadingOptions;

///----------------------------------
/// @name Creating Request Operations
///----------------------------------

/**
 Creates and returns an `LFJSONRequestOperation` object and sets the specified success and failure callbacks.
 
 @param urlRequest The request object to be loaded asynchronously during execution of the operation
 @param success A block object to be executed when the operation finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the JSON object created from the response data of request.
 @param failure A block object to be executed when the operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data as JSON. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the error describing the network or parsing error that occurred.
 @return A new JSON request operation
 */
+ (instancetype)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
