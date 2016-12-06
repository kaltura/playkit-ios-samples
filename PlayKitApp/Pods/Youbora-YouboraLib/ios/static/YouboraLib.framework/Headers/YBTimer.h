//
//  YBTimer.h
//  YouboraLib
//
//  Created by Joan on 27/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBTimer, YBChrono;

NS_ASSUME_NONNULL_BEGIN
/**
 * Type of the success block
 *
 *  - timer: (YBTimer *) The <YBTimer> from where the callback is being invoked.
 *  - diffTime: (double) the time difference between the previous call.
 */
typedef void (^TimerCallback) (YBTimer * timer, double diffTime);

/**
 * Simple class that will execute a callback every <interval> milliseconds.
 */
@interface YBTimer : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// The period at witch to execute the callback
@property (nonatomic, assign) double interval;
/// An instance of <YBChrono>
@property (nonatomic, strong) YBChrono * chrono;

/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Init
 * Same as calling <initWithCallback:andInterval:> with an interval of 5000
 * @param callback the block to execute every <interval> milliseconds
 * @returns an instance of YBTimer
 */
- (instancetype)initWithCallback:(TimerCallback) callback;
/**
 * Init
 * @param callback the block to execute every <interval> milliseconds
 * @param interval interval of the timer
 * @returns an instance of YBTimer
 */
- (instancetype)initWithCallback:(TimerCallback) callback andInterval:(double) interval;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Starts the timer.
 */
- (void) start;

/**
 * Stops the timer.
 */
- (void) stop;

@end

NS_ASSUME_NONNULL_END