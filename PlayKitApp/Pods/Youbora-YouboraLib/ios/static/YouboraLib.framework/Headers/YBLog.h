//
//  YBLog.h
//  YouboraLib
//
//  Created by Joan on 05/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int YBLogLevelSilent;
extern const int YBLogLevelError;
extern const int YBLogLevelWarning;
extern const int YBLogLevelLifeCycle;
extern const int YBLogLevelDebug;
extern const int YBLogLevelHTTPRequests;


@protocol YBLogger

- (void) logYouboraMessage:(NSString *) message withLogLevel:(int) logLevel;

@end

/**
 * YBLog class
 * Provides a set of convenience methods to ease the logging.
 */
@interface YBLog : NSObject

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Generic logging method
 *
 * @param logLevel the log level to use for this message
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) reportLogMessageWithLevel:(int) logLevel andMessage:(NSString *) format, ... ;
/**
 * Set a logger delegate
 *
 * If this is set, the logger delegate will be called whenever a log method is called passing it the log message and level
 * @param delegate An object that conforms to the YBLogger protocol.
 */
+ (void) setLoggerDelegate:(NSObject<YBLogger> *) delegate;
/**
 * @returns the current debug level
 */
+ (int) debugLevel;
/**
 * Sets the debug level.
 *
 * @param debugLevel the debug level to set
 */
+ (void) setDebugLevel:(int) debugLevel;
/**
 * Log with error level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) error:(NSString *) format, ... ;
/**
 * Log with warning level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) warn:(NSString *) format, ... ;
/**
 * Log with lifecycle level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) notice:(NSString *) format, ... ;
/**
 * Log with debug level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) debug:(NSString *) format, ... ;
/**
 * Log with XHR level
 * @param format format string
 * @param ... variable length argument list.
 */
+ (void) requestLog:(NSString *) format, ... ;
/**
 * Log an exception
 * @param exception The exception to log
 */
+ (void) logException:(NSException *) exception;

@end
