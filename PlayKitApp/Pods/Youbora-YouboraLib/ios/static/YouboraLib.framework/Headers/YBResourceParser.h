//
//  YBResourceParser.h
//  YouboraLib
//
//  Created by Joan on 12/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBCDN.h"

extern NSString * _Nonnull const CDN_AKAMAI;
extern NSString * _Nonnull const CDN_LEVEL3;
extern NSString * _Nonnull const CDN_HIGHWINDS;
extern NSString * _Nonnull const CDN_FASTLY;
extern NSString * _Nonnull const CDN_CUSTOM;

@class YBViewManager;

NS_ASSUME_NONNULL_BEGIN

/**
 * This class has two main tasks:
 *
 * - Resource parsing: recursively parse `.m3u` or `.m3u8` manifests up to the point when a video file is found (tipically a `.ts` file)
 * - CDN Node parsing: inferring the CDN where a given resource is hosted. If successfully parsed, the CDN node host and CDN node type are recovered.
 */
@interface YBResourceParser : NSObject
/// ---------------------------------
/// @name Public properties
/// ---------------------------------
/// Timeout in msec
@property (nonatomic, assign) long parseTimeout;

/// Final resource parsed
@property (readonly, strong) NSString * _Nullable realResource;

/// Node Host name after parsing it
@property (readonly, strong) NSString * _Nullable nodeHost;

/// Code of the Node Host type after parsing it
@property (readonly, strong) NSString * _Nullable nodeType;

/// CDN Name after parsing
@property (readonly, strong) NSString * cdnCode;

/// Array of available CDN names to try to match against. Originally this has the CDNs defined as constants.
//@property (nonatomic, strong) NSMutableArray <NSString *> * _Nullable cdnsEnabled;

/// ---------------------------------
/// @name Init
/// ---------------------------------
- (instancetype) initWithViewManager:(YBViewManager *) viewManager;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------
/**
 * Start the HLS and CDN parsing
 */
- (void) start;
/**
 * Reset the instance. After this call the ResourceParser will be ready to call <start> again.
 */
- (void) clear;
/**
 * Use this static method to add a CDN. This tells the ResourceParser how to check for a CDN with the given name.
 * @param cdn The <YBCDN> to add
 * @param name the CDN's name. Must be unique
 */
+ (void) addCDN:(YBCDN *) cdn withName:(NSString *) name;
/**
 * Retrieves the enabled cdns array. This is the CDNs against the ResourceParser will try to resolve the CDN node type and node host
 * @returns the array of enabled cdns. By default it has CDN_AKAMAI, CDN_LEVEL3, CDN_HIGHWINDS and CDN_FASTLY;
 */
+ (NSMutableArray <NSString *> *) getCDNSEnabled;
/**
 * Sets the enabled cdns array.
 * @param cdnNames the Array containing the CDN names to set as the enabled ones.
 * @warning if you just want to add a CDN it's better to get the array through <getCDNSEnabled> and add the CDN name to it.
 */
+ (void) setCDNsEnabled:(NSMutableArray <NSString *> *) cdnNames;

NS_ASSUME_NONNULL_END
@end

