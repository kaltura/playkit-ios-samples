//
//  YBChrono.h
//  YouboraLib
//
//  Created by Joan on 06/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Simple class to calculate the elapsed time between <start> and <stop> calls.
 */
@interface YBChrono : NSObject
/// ---------------------------------
/// @name Public properties
/// ---------------------------------
@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) double lastTime;
/// ---------------------------------
/// @name Init
/// ---------------------------------
- (instancetype) initAndStart;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Returns the time between start and the last stop in ms. Returns -1 if start wasn't called.
 * @param stop If true, it will force a stop if it wasn't sent before.
 * @return Time lapse in ms or -1 if start was not called.
 */
- (double) getDeltaTime:(bool) stop;
/**
 * Same as calling <getDeltaTime:> with stop = false
 * @returns the elapsed time in ms since the start call.
 */
- (double) getDeltaTime;
/**
 * Starts timing
 */
- (void) start;
/**
 * Stop the timer and returns the difference since it <start>ed
 * @returns the difference since it <start>ed
 */
- (double) stop;
/**
 * @returns the current time in milliseconds
 */
+ (double) getCurrentTimeMsec;

@end
