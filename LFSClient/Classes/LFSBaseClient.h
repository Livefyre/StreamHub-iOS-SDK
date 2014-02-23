//
//  LFSBaseClient.h
//  LFSClient
//
//  Created by Eugene Scherba on 8/27/13.
//  Copyright (c) 2013 Livefyre. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>
#import "LFSConstants.h"
#import "LFSJSONRequestOperation.h"

@interface LFSBaseClient : AFHTTPClient

/**
  @property lfEnvironment Environment with which this class instance was initialized
 */
@property (nonatomic, readonly) NSString* lfEnvironment;

/**
 @property lfNetwork Network with which this class instance was initialized
 */
@property (nonatomic, readonly) NSString* lfNetwork;

/**
 @property subdomain abstract (to be overriden) subdomain of the baseURL
 */
@property (nonatomic, readonly) NSString *subdomain;


/**
 * Initialize Livefyre client
 *
 * @param network network as identified by domain, i.e. livefyre.com.
 * @param environment (optional) Where collection(s) are hosted, i.e. t-402.
 *        Used for development/testing purposes.
 * @return LFSClient instance
 * @see -initWithNetwork:environment:
 */

+ (instancetype)clientWithNetwork:(NSString *)network
                      environment:(NSString *)environment;

/**
 * Initialize Livefyre client
 *
 * @param network network as identified by domain, i.e. livefyre.com.
 * @param environment (optional) Where collection(s) are hosted, i.e. t-402.
 *        Used for development/testing purposes.
 * @return LFSClient instance
 */
- (id)initWithNetwork:(NSString *)network
          environment:(NSString *)environment;


/**
 Creates an `LFSJSONRequestOperation` with a `POST` request, and enqueues it to the HTTP client's operation queue.
 Let developer specify the particular parameter encoding to use.
 
 @param path relative path
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param parameterEncoding The `AFHTTPClientParameterEncoding` value corresponding to how parameters are encoded into a request body
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments: the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
parameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding
         success:(AFSuccessBlock)success
         failure:(AFFailureBlock)failure;

/**
 Creates an `LFSJSONRequestOperation` with a `POST` request, and enqueues it to the HTTP client's operation queue.
 Let developer specify the particular parameter encoding to use.
 
 @param url URL to be used as request URL
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param parameterEncoding The `AFHTTPClientParameterEncoding` value corresponding to how parameters are encoded into a request body
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments: the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)postURL:(NSURL *)url
     parameters:(NSDictionary *)parameters
parameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding
        success:(AFSuccessBlock)success
        failure:(AFFailureBlock)failure;


/**
 Creates an `NSMutableURLRequest` object with the specified HTTP method and path.
 Let developer specify the particular parameter encoding to use.

 If the HTTP method is `GET`, `HEAD`, or `DELETE`, the parameters will be used to construct a url-encoded query string that is appended to the request's URL. Otherwise, the parameters will be encoded according to the value of the `parameterEncoding` property, and set as the request body.
 
 @param method The HTTP method for the request, such as `GET`, `POST`, `PUT`, or `DELETE`. This parameter must not be `nil`.
 @param url URL to be used as request URL
 @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @param parameterEncoding The `AFHTTPClientParameterEncoding` value corresponding to how parameters are encoded into a request body
 
 @return An `NSMutableURLRequest` object
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                       url:(NSURL *)url
                                parameters:(NSDictionary *)parameters
                         parameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding;
@end
