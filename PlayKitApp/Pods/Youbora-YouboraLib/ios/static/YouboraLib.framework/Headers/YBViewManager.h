//
//  YBViewManager.h
//  YouboraLib
//
//  Created by Joan on 27/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import "YBRequest.h"

@class YBChrono, YBCommunication, YBInfoManager, YBResourceParser;
/**
 * Class that manages all the view-related events, logic and info. Any Youbora event is
 * sent by this class. It has the flags that represent the view status and a set of
 * <YBChrono>s to ease the calculation of time intervals.
 */
@interface YBViewManager : NSObject

NS_ASSUME_NONNULL_BEGIN
/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// Flag when Start has been sent.
@property (nonatomic, assign) bool isStartSent;
/// Flag when Join has been sent.
@property (nonatomic, assign) bool isJoinSent;
/// Flag when Player is paused.
@property (nonatomic, assign) bool isPaused;
/// Flag when Player is seeking.
@property (nonatomic, assign) bool isSeeking;
/// Flag when Player is buffering.
@property (nonatomic, assign) bool isBuffering;
/// Flag when there are ads showing.
@property (nonatomic, assign) bool isShowingAds;
/// Flag when an error has been sent.
@property (nonatomic, assign) bool isErrorSent;

/// Flag when Ad Start has been sent
@property (nonatomic, assign) bool isAdStartSent;
/// Flag when Join has been sent
@property (nonatomic, assign) bool isAdJoinSent;
/// Flag when Ad is paused.
@property (nonatomic, assign) bool isAdPaused;
/// Flag when Ad is buffering
@property (nonatomic, assign) bool isAdBuffering;

/** 
 * Flag to tell the ViewManager to enable the auto buffer for video content.
 * If this flag is true, a periodic check will run in order to detect the buffering.
 */
@property (nonatomic, assign) bool enableBufferMonitor;
/**
 * Flag to tell the ViewManager to enable the auto seek for video content.
 * If this flag is true, a periodic check will run in order to detect seeking.
 */
@property (nonatomic, assign) bool enableSeekMonitor;
/**
 * Flag to tell the ViewManager to enable the auto buffer for ads.
 * If this flag is true, a periodic check will run in order to detect the buffering.
 */
@property (nonatomic, assign) bool enableAdBufferMonitor;
/**
 * Flag to tell the ViewManager to enable the auto seek for ads.
 * If this flag is true, a periodic check will run in order to detect the seeking.
 */
@property (nonatomic, assign) bool enableAdSeekMonitor;

/// <YBChrono> to calculate seek duration
@property (nonatomic, strong) YBChrono * chronoSeek;
/// <YBChrono> to calculate pause duration
@property (nonatomic, strong) YBChrono * chronoPause;
/// <YBChrono> to calculate join time
@property (nonatomic, strong) YBChrono * chronoJoinTime;
/// <YBChrono> to calculate the sum of generic (aka. non-tracked) ads
@property (nonatomic, strong) YBChrono * chronoGenericAd;
/// <YBChrono> to calculate buffer duration
@property (nonatomic, strong) YBChrono * chronoBuffer;

/// <YBChrono> to calculate the total sum of ad time
@property (nonatomic, strong) YBChrono * chronoAdTotal;
/// <YBChrono> to calculate ad join time
@property (nonatomic, strong) YBChrono * chronoAdJoinTime;
/// <YBChrono> to calculate ad pause duration
@property (nonatomic, strong) YBChrono * chronoAdPause;
/// <YBChrono> to calculate ad buffer duration
@property (nonatomic, strong) YBChrono * chronoAdBuffer;

/// Instance of <YBCommunication>
@property (nonatomic, strong) YBCommunication * communication;
/// Instance of <YBInfoManager>
@property (nonatomic, strong) YBInfoManager * infoManager;
/// Instance of <YBResourceParser>
@property (nonatomic, strong) YBResourceParser * resourceParser;

/// An NSMutableDictionary of entries changed to be sent in pings
@property (nonatomic, strong) NSMutableDictionary * changedEntities;

/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Constructor method
 *
 * @param infoManager An instance of <YBInfoManager> from where all the requires info will be gathered.
 * @returns An instance of YBViewManager
 */
- (instancetype)initWithInfoManager:(YBInfoManager *) infoManager;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Convenience method to call <sendPingWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendPingWtihParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /ping event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendPingWtihParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock)callback;
/**
 * Convenience method to call <sendStartWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendStart;
/**
 * Convenience method to call <sendStartWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendStartWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /start event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendStartWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendJoinWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendJoin;
/**
 * Convenience method to call <sendJoinWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendJoinWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /join event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendJoinWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendStopWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendStop;
/**
 * Convenience method to call <sendStopWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendStopWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /stop event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendStopWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendPauseWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendPause;
/**
 * Convenience method to call <sendPauseWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendPauseWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /pause event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendPauseWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendResumeWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendResume;
/**
 * Convenience method to call <sendResumeWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendResumeWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /resume event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendResumeWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Starts the <chronoBuffer> and updates class flags.
 */
- (void) sendBufferStart;
/**
 * Convenience method to call <sendBufferEndWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendBufferEnd;
/**
 * Convenience method to call <sendBufferEndWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendBufferEndWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /bufferUnderrun event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendBufferEndWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendErrorWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendError;
/**
 * Convenience method to call <sendErrorWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendErrorWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /error event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendErrorWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Starts the <chronoSeek> and updates class flags.
 */
- (void) sendSeekStart;
/**
 * Convenience method to call <sendSeekEndWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendSeekEnd;
/**
 * Convenience method to call <sendSeekEndWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendSeekEndWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /seek event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendSeekEndWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Starts the <chronoGenericAd> and updates class flags.
 */
- (void) sendIgnoreAdStart;
/**
 * Stops the <chronoGenericAd> and updates class flags.
 */
- (void) sendIgnoreAdEnd;
/**
 * Convenience method to call <sendAdStartWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendAdStart;
/**
 * Convenience method to call <sendAdStartWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendAdStartWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /adStart event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendAdStartWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendAdJoinWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendAdJoin;
/**
 * Convenience method to call <sendAdJoinWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendAdJoinWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /adJoin event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendAdJoinWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendAdStopWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendAdStop;
/**
 * Convenience method to call <sendAdStopWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendAdStopWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /adStop event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendAdStopWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendAdPauseWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendAdPause;
/**
 * Convenience method to call <sendAdPauseWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendAdPauseWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /adPause event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendAdPauseWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Convenience method to call <sendAdResumeWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendAdResume;
/**
 * Convenience method to call <sendAdResumeWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendAdResumeWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /adResume event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendAdResumeWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Starts the <chronoAdBuffer> and updates class flags.
 */
- (void) sendAdBufferStart;
/**
 * Convenience method to call <sendAdBufferEndWithParams:andCallback:> with neither params nor callback.
 */
- (void) sendAdBufferEnd;
/**
 * Convenience method to call <sendAdBufferEndWithParams:andCallback:> with no callback.
 * @param params NSDictionary to perform the call.
 */
- (void) sendAdBufferEndWithParams:(NSDictionary *) params;
/**
 * Fetch the required info and send the /adBufferUnderrun event.
 *
 * This method checks and updates the class flags if necessary.
 * @param params NSDictionary of params to perform the request.
 * @param callback Callback to invoke on success.
 */
- (void) sendAdBufferEndWithParams:(NSDictionary *) params andCallback:(_Nullable YBRequestSuccessBlock) callback;
/**
 * Returns if this kind of analytic is allowed (enableAnalytics must be true and the service shall not be in disabledRequests).
 * @param service Name of the service. ie: '/seek'.
 * @returns true if the analytic is allowed, false otherwise.
 */
- (bool) isAllowed:(NSString *) service;
/**
 * Informs if the view is halted. 
 *
 * This means that an error has occurred and haltOnError is true in the options.
 * @returns true if an error has occurred and haltOnError is true, false otherwise
 */
- (bool) isHalted;
/**
 * Reset ad counters to initial values.
 */
- (void) resetAdNumbers;
/**
 * Convenience method to call <getNumberWithPosition:andIncrement:> with increment false
 *
 * @param pos The position of the ad; "pre", "mid", or "post"
 * @returns the ad counter for the given position.
 */
- (NSNumber *) getNumberWithPosition:(NSString *) pos;
/**
 * Returns the counter for the given ad position.
 *
 * @param pos The position of the ad; "pre", "mid", or "post"
 * @param increment Wether to increment or not the counter befoure returning it
 * @returns the ad counter for the given position.
 */
- (NSNumber *) getNumberWithPosition:(NSString *) pos andIncrement:(bool) increment;
/**
 * Converts an ongoing buffer to a seek event.
 *
 * This is needed because some players report a seek event after the buffer start. If that's the case
 * the "buffer" event is really a seek, so this method should be called.
 * Internally it transfers the info from the <chronoBuffer> to <chronoSeek>, stops the chronoBuffer
 * and updates the required flags.
 */
- (void) convertBufferToSeek;
/**
 * Method to actually perform the service calls. This is just an encapsulation to access the <YBCommunication> class.
 * @param name Service name. ie '/data', '/start', etc.
 * @param params NSDictionary of params to perform the http request.
 * @param callback Callback to invoke on success.
 */
- (void) sendRequestWithServiceName:(NSString *) name params:(NSDictionary *) params andCallback:(YBRequestSuccessBlock _Nullable)callback;
/**
 * Stops the timers; pings and playhead checkers if they are enabled
 * See <startTimers>
 */
- (void) stopTimers;
/**
 * Starts the timers. These timers are the following:
 *
 * - pingTimer: Sends pings
 * - playheadMonitorTimer: (if enabled) checks for buffers and seeks
 * - adPlayheadMonitorTimer: (if enabled) checks for buffers for ads
 * See <stopTimers>
 */
- (void) startTimers;
/**
 * Monitoring interval in millis. This is how often the playhead
 * analysis will be done in order to auto detect buffers and seeks
 * if they are enabled.
 * @warning This is a static method, and the monitoring interval will be shared across all the instances. 
 */
+ (double) getMonitoringInterval;
/**
 * Sets the monitoring interval in millis.
 *
 * See <getMonitoringInterval>.
 * @param interval The global monitoring interval in milliseconds
 * @warning This is a static method, and the monitoring interval will be shared across all the instances. If it is desired to change this interval, it should be done BEFORE the YBViewManager is created
 */
+ (void) setMonitoringInterval:(double) interval;

@end

NS_ASSUME_NONNULL_END
