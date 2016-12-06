//
//  YBUtils.h
//  YouboraLib
//
//  Created by Joan on 01/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A string that informs about the current Lib version
 */
FOUNDATION_EXPORT NSString * const YBYouboraLibVersion;

/**
 * Set of non class-specific helper methods. This is static class.
 */
@interface YBUtils : NSObject

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Transforms the input string from jsonp to json
 * @param jsonp NSString with jsonp format.
 * @returns A NSString with json format, or nil if the parameter is not properly formatted.
 */
+ (NSString *) jsonFromJsonp:(NSString *) jsonp;


/**
 * Return number if it is non-nil and greater or equal than 0. In any other case, return defaultValue.
 * @param number NSNumber to be parsed.
 * @param defaultValue NSNumber to return if number is not valid.
 * @returns Either number or defaultValue.
 */
+ (NSNumber *) parseNumber:(NSNumber *) number withDefault:(NSNumber *) defaultValue;

/**
 * Convention method to call <buildRenditionStringWithWidth:height:andBitrate:> with width and height 0.
 *
 * @param bitrate The indicated bitrate (in the manifest) of the asset.
 * @returns A string with the following format: bitrate<suffix?>
 */
+ (NSString *) buildRenditionStringWithBitrate:(double) bitrate;

/**
 * Convention method to call <buildRenditionStringWithWidth:height:andBitrate:> with bitrate = 0.
 *
 * @param width The width of the asset.
 * @param height The height of the asset.
 * @returns A string with the following format: <width>x<height>
 */
+ (NSString *) buildRenditionStringWithWidth:(int) width andHeight:(int) height;

/**
 * Builds a string that represents the rendition.
 *
 * The returned string will have the following format: <width>x<height>@bitrate<suffix?>.
 * If either the width or height are < 1, only the bitrate will be returned.
 * If the bitrate is < 1, only the dimensions will be returned.
 * If all three params are < 1 an empty string will be returned.
 * The bitrate will also have one of the following suffixes depending on its magnitude: bps, Kbps, Mbps
 *
 * @param width The width of the asset.
 * @param height The height of the asset.
 * @param bitrate The indicated bitrate (in the manifest) of the asset.
 * @returns A string with the following format: <width>x<height>@bitrate<suffix?>
 */
+ (NSString *) buildRenditionStringWithWidth:(int) width height:(int) height andBitrate:(double) bitrate;

@end
