//
//  YBInfoManager.h
//  YouboraLib
//
//  Created by Joan on 11/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBPluginGeneric;

/**
 * This class gathers the required info for each event. This info is collected from the <YBOptions> instance, the plugin and its adnalyzer using their 'getX' methods (ie: getResource).
 */
@interface YBInfoManager : NSObject

/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Init
 *
 * Same as calling <initWithPluginInstance:andOptions:> with nil options.
 * @param plugin The plugin instance to manage. Normally, the plugin from where it was called.
 * @returns An instance of YBInfoManager
 */
- (instancetype)initWithPluginInstance:(YBPluginGeneric *) plugin;
/**
 * Constructor method
 *
 * @param plugin The plugin instance to manage. Normally, the plugin from where it was called.
 * @param options NSDictionary or NSString (json-formatted) with the Youbora options to set.
 * @returns An instance of YBInfoManager
 */
- (instancetype)initWithPluginInstance:(YBPluginGeneric *) plugin andOptions:(NSObject *) options;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Convenience method to call <getDataParams:> with no params
 */
- (NSDictionary *) getDataParams;
/**
 * Creates and returns the parameters required for the /data event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getDataParams:(NSDictionary *) params;
/**
 * Convenience method to call <getStartParams:> with no params
 */
- (NSDictionary *) getStartParams;
/**
 * Creates and returns the parameters required for the /start event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getStartParams:(NSDictionary *) params;
/**
 * Convenience method to call <getJoinParams:> with no params
 */
- (NSDictionary *) getJoinParams;
/**
 * Creates and returns the parameters required for the /join event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getJoinParams:(NSDictionary *) params;
/**
 * Convenience method to call <getStopParams:> with no params
 */
- (NSDictionary *) getStopParams;
/**
 * Creates and returns the parameters required for the /stop event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getStopParams:(NSDictionary *) params;
/**
 * Convenience method to call <getPauseParams:> with no params
 */
- (NSDictionary *) getPauseParams;
/**
 * Creates and returns the parameters required for the /pause event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getPauseParams:(NSDictionary *) params;
/**
 * Convenience method to call <getResumeParams:> with no params
 */
- (NSDictionary *) getResumeParams;
/**
 * Creates and returns the parameters required for the /resume event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getResumeParams:(NSDictionary *) params;
/**
 * Convenience method to call <getSeekEndParams:> with no params
 */
- (NSDictionary *) getSeekEndParams;
/**
 * Creates and returns the parameters required for the /seek event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getSeekEndParams:(NSDictionary *) params;
/**
 * Convenience method to call <getBufferEndParams:> with no params
 */
- (NSDictionary *) getBufferEndParams;
/**
 * Creates and returns the parameters required for the /bufferUnderrun event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getBufferEndParams:(NSDictionary *) params;
/**
 * Convenience method to call <getErrorParams:> with no params
 */
- (NSDictionary *) getErrorParams;
/**
 * Creates and returns the parameters required for the /error event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getErrorParams:(NSDictionary *) params;
/**
 * Convenience method to call <getPingParams:> with no params
 */
- (NSDictionary *) getPingParams;
/**
 * Creates and returns the parameters required for the /ping event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getPingParams:(NSDictionary *) params;
/**
 * Convenience method to call <getAdPingParams:> with no params
 */
- (NSDictionary *) getAdPingParams;
/**
 * Creates and returns the ad-related parameters required for the /ping event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getAdPingParams:(NSDictionary *) params;
/**
 * Convenience method to call <getAdStartParams:> with no params
 */
- (NSDictionary *) getAdStartParams;
/**
 * Creates and returns the parameters required for the /adStart event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getAdStartParams:(NSDictionary *) params;
/**
 * Convenience method to call <getAdJoinParams:> with no params
 */
- (NSDictionary *) getAdJoinParams;
/**
 * Creates and returns the parameters required for the /adJoin event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getAdJoinParams:(NSDictionary *) params;
/**
 * Convenience method to call <getAdStopParams:> with no params
 */
- (NSDictionary *) getAdStopParams;
/**
 * Creates and returns the parameters required for the /adStop event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getAdStopParams:(NSDictionary *) params;
/**
 * Convenience method to call <getAdPauseParams:> with no params
 */
- (NSDictionary *) getAdPauseParams;
/**
 * Creates and returns the parameters required for the /adPause event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getAdPauseParams:(NSDictionary *) params;
/**
 * Convenience method to call <getAdResumeParams:> with no params
 */
- (NSDictionary *) getAdResumeParams;
/**
 * Creates and returns the parameters required for the /adResume event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getAdResumeParams:(NSDictionary *) params;
/**
 * Convenience method to call <getAdBufferEndParams:> with no params
 */
- (NSDictionary *) getAdBufferEndParams;
/**
 * Creates and returns the parameters required for the /adBufferUnderrun event
 *
 * @param params Any parameter specified in this object will be sent along the AJAX request. The manager will try to populate every param, so use this only if you need to override a specific param. Refer to the NQS API for more information.
 * @returns the params required to make the http call.
 */
- (NSDictionary *) getAdBufferEndParams:(NSDictionary *) params;

/**
 * Tries to get the resource of the video.
 * The order is resourceParser.realResource, YBOptions, plugin getResource, "unknown".
 * @returns Resource or "unknown".
 */
- (NSString *) getResource;

/**
 * Tries to get the media duration of the video from YBOptions, plugin getMediaDuration.
 * @returns Duration in seconds (rounded) or 0;
 */
- (NSNumber *) getMediaDuration;

/**
 * Tries to get if the video is Live.
 * The order is YBOptions, plugin getIsLive, false.
 * @returns true if live, false if vod.
 */
- (NSValue *) getIsLive;

/**
 * Tries to get the player version from plugin getPlayerVersion.
 * @returns The player version or "".
 */
- (NSString *) getPlayerVersion;

/**
 * Tries to get the title from YBOptions, plugin getTitle.
 * @returns Title or empty string.
 */
- (NSString *) getTitle;

/**
 * Tries to get the rendition of the video from plugin getRendition.
 * @returns Rendition of the media.
 */
- (NSString *) getRendition;

/**
 * Tries to get the bitrate of the video with plugin getBitrate.
 * @returns Bitrate or -1.
 */
- (NSNumber *) getBitrate;

/**
 * Tries to get the throughput of the video with plugin getThroughput.
 * @returns Throughput or -1.
 */
- (NSNumber *) getThroughput;

/**
 * Tries to get the total bytes loaded from the video from plugin getTotalBytes.
 * @returns Total Bytes or nil;
 */
- (NSNumber *) getTotalBytes;

/**
 * Tries to get the playhead of the video.
 * The order adnalyzer getMediaPlayhead, plugin getPlayhead, 0.
 * @returns Playhead in seconds (NOT rounded) or 0
 */
- (NSNumber *) getPlayhead;

/**
 * Tries to get the playhead of the ad from adnalyzer getAdPlayhead.
 * @returns Playhead in seconds or 0
 */
- (NSNumber *) getAdPlayhead;

/**
 * Tries to get the bitrate of the video with adnalyzer getAdBitrate.
 * @returns Bitrate or -1.
 */
- (NSNumber *) getAdBitrate;

/**
 * Tries to get the resource of the ad.
 * The order is YBOptions, adnalyzer getAdResource, "".
 * @returns Resource or empty string.
 */
- (NSString *) getAdResource;

/**
 * Tries to get the position of the roll (pre, mid, post) of the ad from adnalyzer getAdPosition.
 * The order is YBOptions, adnalyzer getPosition, @"unknown".
 * @returns Position (pre, mid, post) or 'unknown';
 */
- (NSString *) getAdPosition;

/**
 * Tries to get the title of the ad, from YBOptions, adnalyzer getAdTitle;
 * The order is YBOptions, adnalyzer getAdTitle, "".
 * @returns Title of the ad or "";
 */
- (NSString *) getAdTitle;

/**
 * Tries to get the media duration of the ad from YBOptions, adnalyzer getAdDuration.
 * @returns The duration in seconds (rounded) or 0;
 */
- (NSNumber *) getAdDuration;

/**
 * Tries to get the ads player version from adnalyzer getAdPlayerVersion.
 * @returns The ad player version or "".
 */
- (NSString *) getAdPlayerVersion;

/**
 * @returns <YBOptions>'s internal NSMutableDictionary.
 */
- (NSMutableDictionary *) getOptions;

/**
 * Sets the key-value pairs onto <YBOptions>
 * @param options NSString (JSON-formatted) or NSDictionary with the key-value pairs to set
 */
- (void) setOptions:(NSObject *) options;

@end
