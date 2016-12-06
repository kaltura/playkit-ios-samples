//
//  YBCDNHeader.h
//  YouboraLib
//
//  Created by Joan on 12/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * HeaderType
 * This identifies what into to extract from a header response
 */
typedef enum {
    kHeaderHost,
    kHeaderType,
    kHeaderHostAndType,
    kHeaderTypeAndHost,
    kHeaderNone
} HeaderType;

/**
 * This class is used to inform the <YBResourceParser> what to expect when reading the
 * response headers. Each instance represents an expected response header for a given CDN.
 */
@interface YBCDNHeader : NSObject
/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Init mehtod
 *
 * @param type HeaderType of this CDNHeader. This is what info are we expecting to extract from this header.
 * @param name Name of the header
 * @param regexPattern pattern to extract the CDN-related info from the response headers
 */
- (instancetype)initWithType:(HeaderType)type name:(NSString *)name andRegexPattern:(NSString *)regexPattern;
/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// What info are we expecting to extract from this header.
@property (nonatomic, assign) HeaderType type;
/// Name of the header
@property (nonatomic, strong) NSString * name;
/// pattern to extract the CDN-related info from the response headers
@property (nonatomic, strong) NSString * regexPattern;

@end
