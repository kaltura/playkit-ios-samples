//
//  IMALiveStreamRequest.h
//  GoogleIMA3_ios
//
//  Declares a representation of a stream request for live streams.
//
//

#import "IMAStreamRequest.h"

@class IMAAdDisplayContainer;
@protocol IMAVideoDisplay;

/**
 * Data object describing a live stream reqeust.
 */

@interface IMALiveStreamRequest : IMAStreamRequest

/**
 *  The live stream request asset key. This is used to determine which stream should be played.
 */
@property(nonatomic, copy, readonly) NSString *assetKey;

/**
 *  Whether the SDK should attempt to play a preroll during server side ad insertion.
 *  Defaults to false. This setting is only used for live streams.
 */
@property(nonatomic) BOOL attemptPreroll;

/**
 *  Initializes a live stream request instance with the given assetKey. Uses the given ad display
 *  container to display the stream.
 *
 *  @param assetKey           the stream assetKey
 *  @param adDisplayContainer the IMAAdDisplayContainer for rendering the ad UI
 *  @param videoDisplay       the IMAVideoDisplay for playing the stream
 *
 *  @return the IMALiveStreamRequest instance
 */
- (instancetype)initWithAssetKey:(NSString *)assetKey
              adDisplayContainer:(IMAAdDisplayContainer *)adDisplayContainer
                    videoDisplay:(id<IMAVideoDisplay>)videoDisplay;

- (instancetype)init NS_UNAVAILABLE;

@end
