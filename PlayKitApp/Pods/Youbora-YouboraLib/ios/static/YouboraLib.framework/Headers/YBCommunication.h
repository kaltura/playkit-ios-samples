//
//  YBCommunication.h
//  YBPluginGeneric
//
//  Created by Joan on 31/03/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBRequest.h"
@class YBPluginGeneric;


NS_ASSUME_NONNULL_BEGIN


typedef NSMutableDictionary * _Nullable (^YBAdditionalOperationsCallback) (NSMutableDictionary * params);

/**
 * YBCommunication implements the last abstraction layer against NQS calls.
 * Internally, YBCommunication implements an array of <YBRequest> objects, executing one after another.
 * All requests will be blocked until a first /data call is made, before context, any request sent will be queued.
 */
@interface YBCommunication : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// Ping time interval in milliseconds.
@property (nonatomic, strong) NSNumber * pingTime;

/// Host where all the requests will be made to.
@property (nonatomic, strong) NSString * host;

/// Boolean wich indicates wether to use https or not.
@property (nonatomic, assign) NSValue * httpSecure;

/**
 * If defined, and extra data may be required (such as resource parser info), YBCommunication
 * will call this callback to give the chance of completing the params.
 */
@property (nonatomic, copy) YBAdditionalOperationsCallback _Nullable additionalOperationsCallback;

/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Constructor method
 *
 * @param host The host where to send the requests
 * @param httpSecure Use https if @YES, http if @NO
 * @returns An instance of YBCommunication
 */
- (instancetype) initWithHost:(NSString *)host andHTTPSecure:(NSValue *) httpSecure;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * @returns the current view code
 */
- (NSString *) getViewCode;

/**
 * Creates and returns a new view code.
 * @param isLive If true the new code will have a leading "L", or a "V" otherwise.
 * @returns The newly-generated view code.
 */
- (NSString *) nextView:(NSValue *) isLive;

/**
 * Convenience mehtod to call <requestDataWithParams:andCallback:> with no callback.
 * @param params An NSDictionary of parameters sent with the request.
 */
- (void) requestDataWithParams:(NSDictionary *) params;

/**
 * Sends '/data' request.
 *
 * This has to be the first request and all
 * other requests will wait until we got the response from this one.
 *
 * @param params An NSDictionary of parameters sent with the request:
 * 
 * - system: System code.
 * - pluginVersion: Something like "X.Y.Z-\<pluginName\>"
 * - live: true if the content is live. False if VOD. Do not set if unknown.
 * @param callback The success callback for the YBRequest object
 */
- (void) requestDataWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;

/**
 * Parse the /data params from the NSData got in a success callback
 * @param data The NSData to get the /data parameters from. This should be a jsonp.
 */
- (void) receiveDataFromData:(NSData *) data;

/**
 * Sends a generic request. All the specific functions use this method.
 *
 * @param service A string with the service to be called. ie: 'nqs.nice264.com/data', '/joinTime'...
 * @param params An NSDictionary with the argumentss of the call.
 * @param callback The success callback for the <YBRequest> object
 */
- (void) sendRequestWithServiceName:(NSString *) service params:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;

/**
 * Sends a service request.
 *
 * @param service A string with the service to be called. ie: 'nqs.nice264.com/data', '/joinTime'...
 * @param params An NSDictionary with the argumentss of the call.
 * @param callback The success callback for the YBRequest object
 */
- (void) sendServiceWithServiceName:(NSString *) service params:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;

/**
 * Checks if a preloader exists.
 *
 * @param preloader Unique identifier of the blocker. ie: "CDNParser".
 * @returns true if the preloader is in the list, false otherwise
 */
- (bool) hasPreloader:(NSString *) preloader;

/**
 * Adds a preloader to the queue. 
 *
 * While this queue is not empty, all requests will be stoped.
 * @warning Remember to call removePreloader: to unblock the main queue
 *
 * @param preloader Unique identifier of the blocker. ie: 'CDNParser'.
 */
- (void) addPreloader:(NSString *) preloader;

/**
 * Removes a preloader.
 *
 * The preloader has to be previously set with the addPreloader: method. 
 * If it was the last preloader, all queued requests will be sent.
 *
 * @param preloader Unique identifier of the blocker. ie: 'CDNParser'.
 */
- (void) removePreloader:(NSString *) preloader;

@end

NS_ASSUME_NONNULL_END