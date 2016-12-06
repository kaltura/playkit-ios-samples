//
//  YBPluginGeneric.h
//  YouboraLib
//
//  Created by Joan on 01/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBCommunication, YBViewManager, YBInfoManager, YBAdnalyzerGeneric, YBOptions;

/**
 * This class is the generic plugin from which specifics plugins will extend.
 *
 * Internally, it coordinates a number of inner components such as <YBViewManager> and <YBInfoManager>
 */
@interface YBPluginGeneric : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// Name and platform of the plugin.
@property (nonatomic, strong) NSString * pluginName;

/// Version of the plugin. ie: 5.1.0-name
@property (nonatomic, strong) NSString * pluginVersion;

/// Reference to the player object
@property (nonatomic, weak) NSObject * player;

/// An instance of <YBViewManager>
@property (nonatomic, strong) YBViewManager * viewManager;

/// An instance of <YBInfoManager>
@property (nonatomic, strong) YBInfoManager * infoManager;

/// An instance inherited from <YBAdnalyzerGeneric>
@property (nonatomic, strong) YBAdnalyzerGeneric * adnalyzer;

/// If this is enabled, plugin will try to automatically detect /start events (YES by default)
@property (nonatomic, assign) BOOL startAutoDetectionEnabled;

/// ---------------------------------
/// @name Init
/// ---------------------------------
- (instancetype)initWithOptions:(NSObject *) options;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Starts monitoring player events.
 *
 * Same as calling <startMonitoringWithPlayer:forceStart:> with start = false.
 * @param player The player object.
 */
- (void) startMonitoringWithPlayer:(NSObject *) player;

/**
 * Starts monitoring player events.
 *
 * This method should be overriden by specific plugins in order to prepare
 * data structures, set listeners, observers, and anything required to
 * detect the player events.
 * If the monitoring has been already started previously (ie. <player> is not nil),
 * <stopMonitoring> will be called in first place.
 * Passing start = true means the player will send a /start event right away. This also
 * sets the <startAutoDetectionEnabled> to NO. So you will have to call <playHandler>
 * in order to create new views (for example in a playlist).
 * @param player The player object.
 * @param start If true, the plugin will send a /start event right away.
 * @warning If you force the /start event, you should have previously set the resource
 * calling <setOptions:>.
 */
- (void) startMonitoringWithPlayer:(NSObject *) player forceStart:(BOOL) start;

/**
 * Stops monitoring player events.
 * 
 * If there's an ongoing view, it will be closed calling <endedHandler>. 
 * This method should be overriden by specific plugins in order to remove listeners,
 * observers, etc.
 */ 
- (void) stopMonitoring;
/**
 * This method should be called whenever the app goes background, usually in ViewController's
 * viewWillDisappear method or when the app goes to background. It will stop the timers,
 * such as ping and buffer or seek monitors (if enabled). This will prevent the plugin from
 * sending pings when the app is in background.
 * See <resumeMonitoring>
 */
- (void) pauseMonitoring;
/**
 * Should be called in order to re-enable the timers. The call is usually placed in ViewController's
 * viewWillAppear method, or when the app comes back from background.
 * See <pauseMonitoring>
 */
- (void) resumeMonitoring;
/**
 * Sets <YBViewManager>'s flag to enable the auto buffer feature
 */
- (void) enableBufferMonitor;
/**
 * Sets <YBViewManager>'s flag to enable the auto seek feature
 */
- (void) enableSeekMonitor;
/**
 * This method must be called when the resource starts loading (a.k.a. /start)
 */
- (void) playHandler;
/**
 * This method must be called as soon as the video starts actually playing; when
 * the first frame is displayed or the first time the playhead is greater than 0. (a.k.a. /join)
 */
- (void) joinHandler;
/**
 * This method is a convenience method to automatically send /join, /seek, /resume and /bufferUnderrun
 * events depending on the flag status of the <YBViewManager>.
 * @warning This will not always work depending on the player behavior. Some plugins must use the specific method calls instead of this one.
 */
- (void) playingHandler;
/**
 * This method must be called when the playback pauses (a.k.a. /pause)
 */
- (void) pauseHandler;
/**
 * This method will send a /resume event if it was paused, or a /pause if it was not.
 * @warning if <resumeHandler> and <pauseHandler> are being used, this method must not be called.
 */
- (void) pauseToggleHandler;
/**
 * This method must be called when the playback resumes after a pause (a.k.a. /resume)
 */
- (void) resumeHandler;
/**
 * This method must be called when the resource successfully plays to the end (a.k.a. /stop)
 */
- (void) endedHandler;
/**
 * Convenience method to call <errorHandlerWithMessage:message:andErrorMetadata:> with no metadata.
 * @param msg Error message and code (the same string will be sent in both fields)
 * @warning use this method only when you cannot get the code or the message.
 */
- (void) errorHandlerWithMessage:(NSString *) msg;
/**
 * Convenience method to call <errorHandlerWithMessage:message:andErrorMetadata:> with no metadata
 * @param code Error code reported
 * @param msg Error message (should be unique for the code)
 */
- (void) errorHandlerWithCode:(NSString *) code andMessage:(NSString *) msg;
/**
 * This method must be called when the player or the asset being played report an error.
 * @param code Error code reported
 * @param msg Error message (should be unique for the code)
 * @param errorMetadata Extra error info, if available.
 */
- (void) errorHandlerWithCode:(NSString *) code message:(NSString *) msg andErrorMetadata:(NSString *) errorMetadata;
/**
 * This method must be called when the player detects a 'jump' in the playhead, or when a seek event is detected.
 * If this method is called after a <bufferingHandler> but before <bufferedHandler>, it will convert the existing
 * buffer to a seek event.
 */
- (void) seekingHandler;
/**
 * This method must be called when the player detects a seek end (a.k.a. /seek).
 * If the player cannot differentiate between seek and buffer end events, it is fine to call <bufferedHandler> instead.
 */
- (void) seekedHandler;
/**
 * This method must be called when the player starts buffering.
 */
- (void) bufferingHandler;
/**
 * This method must be called when the player ends buffering.
 * It will first check if there's an open seek event. If that is the case, it will close the seek, otherwise it will close the buffer (if any).
 */
- (void) bufferedHandler;
/**
 * This method should be called whenever a non-tracked ad starts (no adnalyzer). 
 * The plugin will ignore all events from this call until <ignoredAdHandler> is called.
 */
- (void) ignoringAdHandler;
/**
 * This method should be called whenever a non-tracked ad ends (no adnalyzer).
 * The plugin will ignore all events from <ignoringAdHandler> until this method is called.
 */
- (void) ignoredAdHandler;
/**
 * @returns <YBOptions>'s inner NSDictionary
 */
- (NSMutableDictionary *) getOptions;
/**
 * Sets the key-value pairs onto <YBOptions>
 * @param options NSString (JSON-formatted) or NSDictionary with the key-value pairs to set
 */
- (void) setOptions:(NSObject *) options;

/**
 * Override this function to return the player version.
 * @returns "Generic"
 */
- (NSString *) getPlayerVersion;
/**
 * Override this function to return the resource.
 * @returns "unknown"
 */
- (NSString *) getResource;
/**
 * Override this function to return the media duration in seconds.
 * @returns nil
 */
- (NSNumber *) getMediaDuration;
/**
 * Override this function to return the current rendition.
 * @returns nil
 */
- (NSString *) getRendition;
/**
 * Override this function to return @YES if the current resource is live or @NO if VoD.
 * @returns @NO
 */
- (NSValue *) getIsLive;
/**
 * Override this function to return the title.
 * @returns nil
 */
- (NSString *) getTitle;
- (NSNumber *) getTotalBytes;
/**
 * Override this function to return the current playhead in seconds.
 * @returns nil
 */
- (NSNumber *) getPlayhead;
/**
 * Override this function to return the current bitrate.
 * @returns nil
 */
- (NSNumber *) getBitrate;
/**
 * Override this function to return the current network throughput.
 * @returns nil
 */
- (NSNumber *) getThroughput;

@end
