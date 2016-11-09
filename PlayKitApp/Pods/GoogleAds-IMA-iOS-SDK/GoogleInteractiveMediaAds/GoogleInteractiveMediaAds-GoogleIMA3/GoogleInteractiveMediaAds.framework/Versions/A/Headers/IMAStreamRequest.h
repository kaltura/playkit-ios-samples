//
//  IMAStreamRequest.h
//  GoogleIMA3
//
//  Copyright (c) 2015 Google Inc. All rights reserved.
//
//  Declares a simple stream request class.

#import <Foundation/Foundation.h>

@class IMAAdDisplayContainer;
@protocol IMAVideoDisplay;

/**
 *  The inventory unit (iu).
 */
extern NSString *const kIMAStreamParamIU;

/**
 *  The description url (description_url).
 */
extern NSString *const kIMAStreamParamDescriptionURL;

/**
 *  The custom parameters (cust_params).
 */
extern NSString *const kIMAStreamParamCustomParameters;

/**
 *  Tag for child detection parameter (tfcd).
 */
extern NSString *const kIMAStreamParamTFCD;

/**
 *  The order variant parameter (dai-ov).
 */
extern NSString *const kIMAStreamParamOrderVariant;

/**
 *  The order type parameter (dai-ot).
 */
extern NSString *const kIMAStreamParamOrderType;

/**
 *  Data class describing the stream request.
 */
@interface IMAStreamRequest : NSObject

/**
 *  The stream display container for displaying the ad UI.
 */
@property(nonatomic, strong, readonly) IMAAdDisplayContainer *adDisplayContainer;

/**
 *  The video display where the stream can be played.
 */
@property(nonatomic, strong, readonly) id<IMAVideoDisplay> videoDisplay;

/**
 *  The stream request API key. This is used for content authentication. The API key is configured
 *  through the DFP Admin UI and provided to the publisher to unlock their content. It's a security
 *  measure used to verify the applications that are attempting to access the content.
 */
@property(nonatomic, copy) NSString *apiKey;

/**
 *  The parameters passed from the SDK to the stream server to append to the ad tag. The following
 *  parameters are allowed: "cust_params", "dai-ot", "dai-ov", "description_url", "durl", "iu", and
 *  "tfcd". All other parameters will be ignored.
 */
@property(nonatomic, copy) NSDictionary *adTagParameters;

- (instancetype)init NS_UNAVAILABLE;

@end
