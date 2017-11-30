//
//  ViewController.m
//  PhoenixAnalyticsSample
//
//  Created by Gal Orlanczyk on 21/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"
@import PlayKit;
@import PlayKitOTT;

#define ottServerUrl @"http://api-preprod.ott.kaltura.com/v4_5/api_v3"
#define ottPartnerId 198
#define ottAssetId @"259153"
#define ottFileId @"804398"

@interface ViewController ()

@property (strong, nonatomic) id<Player> player;
@property (strong, nonatomic) NSTimer *playheadTimer;
@property (strong, nonatomic) PhoenixMediaProvider *provider;

@property (weak, nonatomic) IBOutlet PlayerView *playerContainer;
@property (weak, nonatomic) IBOutlet UISlider *playheadSlider;

@end

/*********************************/
// Plugin registration should be done in App Delegate!!!
// Don't forget to add it in your project.
// Look at `AppDelegate` to see the registration.
/*********************************/

/*
 This sample will show you how to create a player with phoenix analytics plugin.
 The steps required:
 1. Create plugin config.
 2. Load player with plugin config.
 3. Register player events.
 4. Prepare Player.
 */
@implementation ViewController

/*********************************/
#pragma mark - LifeCycle
/*********************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playheadSlider.continuous = NO;
    
    [PhoenixAnonymousSession getWithBaseUrl:ottServerUrl partnerId:ottPartnerId completion:^(NSString *ks, NSError *error) {
        // 1. Create plugin config
        PluginConfig *pluginConfig = [self createPluginConfig:ks];
        // 2. Load the player
        NSError *err = nil;
        self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:pluginConfig error:&err];
        // make sure player loaded
        if (!err) {
            // 3. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            [self addPhoenixAnalyticsObservations];
            
            // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            [self preparePlayer:ks];
        } else {
            // error loading the player
        }
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // remove observers
    [self removeAnalyticsObservations];
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)preparePlayer:(NSString *)ks {
    // setup the player's view
    self.player.view = self.playerContainer;
    
    _provider = [PhoenixMediaProvider new];
    _provider.baseUrl = ottServerUrl;
    _provider.ks = ks;
    _provider.assetId = ottAssetId;
    _provider.fileIds = [[NSArray alloc] initWithObjects:ottFileId, nil];
    _provider.playbackContextType = PlaybackContextTypePlayback;
    _provider.type = AssetTypeMedia;
    [_provider loadMediaWithCallback:^(PKMediaEntry *entry, NSError *error) {
        // create media config
        MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:entry startTime:0.0];
        
        // prepare the player
        [self.player prepare:mediaConfig];
    }];
}

/*********************************/
#pragma mark - Analytics
/*********************************/

// creates plugin config by adding params under the plugin name.
- (PluginConfig *)createPluginConfig:(NSString *)ks {
    NSMutableDictionary *pluginConfigDict = [[NSMutableDictionary alloc] init];
    pluginConfigDict[PhoenixAnalyticsPlugin.pluginName] = [self createPhoenixPluginConfig:ks];
    return [[PluginConfig alloc] initWithConfig:pluginConfigDict];
}

- (void)addPhoenixAnalyticsObservations {
    [self.player addObserver:self events:@[OttEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received ott event: %@", event.ottEventMessage);
    }];
}

// remove observers
- (void)removeAnalyticsObservations {
    [self.player removeObserver:self events:@[OttEvent.report]];
}

- (PhoenixAnalyticsPluginConfig *)createPhoenixPluginConfig:(NSString *)ks {
    return [[PhoenixAnalyticsPluginConfig alloc] initWithBaseUrl:ottServerUrl
                                                   timerInterval:30.0f
                                                              ks:ks
                                                       partnerId:ottPartnerId];
}

/*********************************/
#pragma mark - Actions
/*********************************/

- (IBAction)playTouched:(UIButton *)sender {
    if(!self.player.isPlaying) {
        self.playheadTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(playheadUpdate) userInfo:nil repeats:YES];
        [self.player play];
    }
}

- (IBAction)pauseTouched:(UIButton *)sender {
    if(self.player.isPlaying) {
        [self.playheadTimer invalidate];
        self.playheadTimer = nil;
        [self.player pause];
    }
}

- (IBAction)playheadValueChanged:(UISlider *)sender {
    NSLog(@"playhead value: %f", sender.value);
    self.player.currentTime = self.player.duration * sender.value;
}

- (void)playheadUpdate {
    self.playheadSlider.value = self.player.currentTime / self.player.duration;
}

@end
