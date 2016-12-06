//
//  YBAdnalyzerGeneric.h
//  YouboraLib
//
//  Created by Joan on 12/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBPluginGeneric;

/**
 * This class is the generic adnalyzers from which specifics adnalyzers will extend.
 */
@interface YBAdnalyzerGeneric : NSObject


/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/** Version of the plugin. ie: 1.0.0-name */
@property (nonatomic, strong) NSString * adnalyzerVersion;
/** Reference to the main plugin */
@property (nonatomic, weak, readonly) YBPluginGeneric * plugin;
/** Reference to the ads player. */
@property (nonatomic, weak, readonly) NSObject * adsPlayer;

/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Instantiates the adnalyzer libraries.
 *
 * @param plugin The main youbora plugin from where it is instantiated.
 * @returns An instace of YBAdnalyzerGeneric.
 */
- (instancetype)initWithPluginInstance:(YBPluginGeneric *) plugin;

/// ---------------------------------
/// @name Lifecycle
/// ---------------------------------
/**
 * This method should be called whenever the Adnalyzer should start listening for ad events.
 * Usually this is called from the PluginGeneric's startMonitoringWithPlayer: method.
 *
 * Have in mind that sometimes the content player and ads player is not the same. 
 * If that's the case you should create an overloaded version of PluginGeneric's startMonitoringWithPlayer: 
 * that accepts two params, being the second one the ads player instance, that should be sent to this method.
 *
 * @param player The ads player where to listen events from.
 */
- (void) startMonitoringWithPlayer:(NSObject *) player;

/**
 * Stop monitoring.
 *
 * Sends stop if necessary and sets the ad player to nil. This should be called once the Adnalyzer 
 * is no longer needed. Usually called from the (overriden) PluginGeneric's stopMonitoring: method.
 */
- (void) stopMonitoring;


/// ---------------------------------
/// @name Event Handlers
/// ---------------------------------

/**
 * Enables the buffer auto-detection.
 *
 * If enabled, a timer will periodically check the playhead. If at any time
 * it advances slower than expected, it will start buffering. Buffering ends
 * when the playhead continues to increment at the expected rate.
 */
- (void) enableBufferMonitor;

/**
 * Enables the seek auto-detection.
 *
 * If enabled, a timer will periodically check the playhead. If at any time
 * it advances faster than expected, it will start seeking. Seeking ends
 * when the playhead continues to increment at the expected rate.
 */
- (void) enableSeekMonitor;

/**
 * This function must be called when a new ad starts loading.
 */
- (void) playAdHandler;

/**
 * This function must be called when a new ad starts.
 *
 * It will /adStart + /adJoinTime.
 * If there was a bufferUnderrun running before this call, its time will be used as joinTime.
 */
- (void) startJoinAdHandler;

/**
 * This function must be called when the ad starts playing for the first time.
 * @warning If playingAdHandler is used, this function is not needed.
 */
- (void) joinAdHandler;

/**
 * This function must be called when the ad is paused.
 */
- (void) pauseAdHandler;

/**
 * This function must be called when a button of pause/resume is pressed.
 */
- (void) pauseToggleHandler;

/**
 * This function must be called when the ad is resumed from a pause.
 * @warning If playingAdHandler is used, this function is not needed.
 */
- (void) resumeAdHandler;

/**
 * This function must be called when the ad has ended.
 */
- (void) endedAdHandler;

/**
 * This function must be called when the ad has been stopped.
 */
- (void) skipAdHandler;

/**
 * This function must be called when the ad starts a buffer underrun.
 */
- (void) bufferingAdHandler;

/**
 * This function must be called when the ad ends buffering.
 * @warning If playingAdHandler is used, this function is not needed.
 */
- (void) bufferedAdHandler;

/// ---------------------------------
/// @name Ad info getters
/// ---------------------------------

/**
 * Override this function to return ad resource.
 * @returns An empty string.
 */
- (NSString *) getAdResource;

/**
 * Override this function to return ad playhead of the media.
 * By default this returns the plugin playhead
 * @returns [plugin getPlahyead]
 */
- (NSNumber *) getMediaPlayhead;

/**
 * Override this function to return ad playhead.
 * @returns 0
 */
- (NSNumber *) getAdPlayhead;

/**
 * Override this function to return ad position pre/mid/post/unknown.
 * @returns @"unknown"
 */
- (NSString *) getAdPosition;

/**
 * Override this function to return ad title.
 * @returns An empty string.
 */
- (NSString *) getAdTitle;

/**
 * Override this function to return ad duration.
 * @returns 0
 */
- (NSNumber *) getAdDuration;

/**
 * Override this function to return ad bitrate.
 * @returns -1
 */
- (NSNumber *) getAdBitrate;

/**
 * Override this function to return ad player version.
 * @returns Empty string
 */
- (NSString *) getAdPlayerVersion;


@end
