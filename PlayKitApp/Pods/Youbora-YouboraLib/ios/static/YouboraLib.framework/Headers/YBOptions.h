//
//  YBOptions.h
//  YouboraLib
//
//  Created by Joan on 07/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class encapsulates an NSMutableDictionary where all the view info is stored.
 * In addition, it provides the <setOptions:> method to ease the value setting of the dictionary.
 */
@interface YBOptions : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// The NSMutableDictionary encapsulated by this class
@property (nonatomic, strong) NSMutableDictionary * dict;

/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Constructor method
 * Creates the instance and calls the <setOptions:> method with the parameter value.
 * @param options NSString (JSON-formatted) or NSDictionary to send to <setOptions:>
 */
- (instancetype)initWithOptions:(NSObject *) options;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Sets the options in the <dict>.
 *
 * This will recursively evaluate the options object (either a String or a Dictionary) and will only
 * overwrite <dict> values when the corresponding key in options is informed.
 * This is the method to call whenever any field should change.
 * @param options NSString (JSON-formatted) or NSDictionary to get the key-value pairs to set into <dict>
 */
- (void) setOptions:(NSObject *) options;

@end
