//
//  YBCDN.h
//  YouboraLib
//
//  Created by Joan on 12/04/16.
//  Copyright © 2016 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBCDNHeader.h"

typedef NSString * _Nullable (^YBCDNInfoListener) (NSDictionary * _Nullable responseHeaders, NSString * _Nullable cdnHeader);


/**
 * This class allows to define a CDN for the <YBResourceParser>. Each CDN definition consists of a set of <YBCDNHeader>s and a dictionary of request headers:
 * 
 * - the request headers are key-value entries to send as http headers when performing the http head requests to get info about the CDN.
 * - the <YBCDNHeader> instances tell us what and how to extract from the headers in the http head responses.
 */
@interface YBCDN : NSObject
/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Init
 * @param headers NSArray of <YBCDNHeader>s
 * @param code NSString representing the cdn name or code
 * @param requestHeaders NSDictionary containing key-value entries to send as http headers when performing the http head requests to get info about the CDN.
 */
- (_Nonnull instancetype)initWithHeaders:(NSArray <YBCDNHeader *> * _Nullable) headers code:(NSString * _Nullable) code andRequestHeaders:(NSDictionary <NSString *, NSString *> * _Nullable) requestHeaders;

/// <YBCDNHeader> instances tell us what and how to extract from the headers in the http head responses.
@property (nonatomic, strong) NSArray <YBCDNHeader *> * _Nullable headers;
/// Key-value entries to send as http headers when performing the http head requests to get info about the CDN.
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> * _Nullable requestHeaders;
/// CDN code
@property (nonatomic, strong) NSString * _Nullable code;
/// CDN Info listener callback
@property (nonatomic, copy) YBCDNInfoListener _Nullable cdnInfoListener;

@end
