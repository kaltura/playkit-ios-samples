//
//  YBRequest.h
//  YBPluginGeneric
//
//  Created by Joan on 31/03/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kOptionsKeyMethod;
extern NSString * const kOptionsKeyRequestHeaders;
extern NSString * const kOptionsKeyMaxRetries;
extern NSString * const kOptionsKeyRetryAfter;
extern NSString * const kOptionsKeyNormalizeUserAgent;

/** 
 * Type of the success block
 *
 *  - data: (NSData *) the data as returned by the completionHandler.
 *  - response: (NSURLResponse *) the response as returned by the completionHandler.
 */
typedef void (^YBRequestSuccessBlock) (NSData * _Nullable data, NSURLResponse * _Nullable response);

/** 
 * Type of the error block
 *
 *  - error: (NSError *) error as returned by the completionHandler.
 */
typedef void (^YBRequestErrorBlock) (NSError * _Nullable error);


/**
 * This class encapsulates the http requests. It performs as an inferface against the system http calls.
 * YBRequests are highly customizable via the params property and the <setSuccessListener:> and <setErrorListener:> methods.
 */
@interface YBRequest : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// The host where the YBRequest is performed to
@property (nonatomic, strong) NSString * host;

/// The service. This will be the "/something" part of the url.
/// For instance the "/start" in "nqs.nice264.com/start"
@property (nonatomic, strong) NSString * service;

/// NSDictionary with params to add to the http request
@property (nonatomic, strong) NSMutableDictionary * params;

/// NSDictionary with options for the class
@property (nonatomic, strong) NSMutableDictionary * options;

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * YBRequest will generate the URL call. 
 *
 * @param host NSString with the URL of the request. Example: nqs.nice264.com
 * @param service NSString with the name of the service. ie '/start'
 * @param params NSDictionary of parameters. Example: `@{@"system":@"nicetv", @"user":@"user"}`.
 * @param options NSDictionary with custom options. *
 * Options keys. These are the (NSString) keys to pass custom options for the request.
 *
 *  - method: Specifies the method of the request ie: "GET", "POST", "HEAD". Default: "GET".
 *  - requestHeaders: A literal with options of requestHeaders. Example: '@{@"header": @"value"}`. Default: empty.
 *  - retryAfter: Time in ms before sending a failed request again. 0 to disable. Default: 5000.
 *  - maxRetries: Max number of retries. 0 to disable.. Default: 3.
 * @returns An instance of YBRequest
 */
- (instancetype) initWithHost:(NSString * _Nullable) host service:(NSString * _Nullable) service params:(NSDictionary * _Nullable) params andOptions:(NSDictionary * _Nullable) options;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * @returns the full url; host + service + params
 */
- (NSString *) getUrl;

/**
 * @returns the encoded parameters
 */
- (NSString *) getParams;

/** 
 * Sets a key-value pair in the NSDictionary params
 * @param value the value of the param
 * @param key the key of the param
 * @returns the YBRequest instance
 */
- (YBRequest *) setParamValue:(NSObject *) value forKey:(NSString *) key;

/**
 * Sets the callback for completion (optional)
 * @param callbackBlock This callback will be invoked whenever the `error` param in the completionHandler callback is nil.
 */
- (void) setSuccessListener:(YBRequestSuccessBlock) callbackBlock;

/**
 * Sets the callback for error (optional).
 * @param callbackBlock This callback will be invoked whenever the `error` param in the completionHandler callback is non-nil.
 * @warning If this callback is set, then is the caller code's responsibility to make retries if needed.
 */
- (void) setErrorListener:(YBRequestErrorBlock) callbackBlock;

/**
 * Performs the request.
 * @warning This should be the last method to call for an YBRequest class instance.
 */
- (void) send;

/**
 * Sets an extra callback for completion.
 *
 * In addition to the <setSuccessListener:>, this callback will also be called for ALL the requests. This can be
 * useful for debugging.
 * @param callbackBlock This callback will be invoked whenever the `error` param in the completionHandler callback is nil.
 * @warning This is a static method and setting the callback here will affect all the instances of YBRequest.
 */
+ (void) setGlobalSuccessListener:(YBRequestSuccessBlock) callbackBlock;

@end

NS_ASSUME_NONNULL_END