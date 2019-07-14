//
//  ViewController.m
//  PhoenixAnalyticsSample
//
//  Created by Gal Orlanczyk on 21/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"

@import PlayKit;
@import PlayKitProviders;

@interface ViewController ()

@property (strong, nonatomic) id<Player> player;
@property (strong, nonatomic) NSTimer *playheadTimer;
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
    
    // 1. Create plugin config
    PluginConfig *pluginConfig = [self createPluginConfig];
    // 2. Load the player
    self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:pluginConfig];
    // 3. Register events if have ones.
    // Event registeration must be after loading the player successfully to make sure events are added,
    // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
    [self addPhoenixAnalyticsObservations];
    
    // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
    [self preparePlayer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // remove observers
    [self removeAnalyticsObservations];
}
    
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)preparePlayer {
    // Setup the player's view
    self.player.view = self.playerContainer;
    
    // Create a session provider
    SimpleSessionProvider *sessionProvider = [[SimpleSessionProvider alloc] initWithServerURL:@"https://api-preprod.ott.kaltura.com/v5_1_0/api_v3"
                                                                                    partnerId:198
                                                                                           ks:nil];
    
    // Create the media provider
    PhoenixMediaProvider *phoenixMediaProvider = [[PhoenixMediaProvider alloc] init];
    [phoenixMediaProvider setAssetId:@"277170"];
    [phoenixMediaProvider setType:AssetTypeMedia];
    [phoenixMediaProvider setFormats:@[@"Mobile_Devices_Main_SD"]];
    [phoenixMediaProvider setPlaybackContextType:PlaybackContextTypePlayback];
    [phoenixMediaProvider setSessionProvider:sessionProvider];
    
    [phoenixMediaProvider loadMediaWithCallback:^(PKMediaEntry *pkMediaEntry, NSError *error) {
        if (pkMediaEntry != nil) {
            // Create media config
            MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:pkMediaEntry startTime:0.0];
            
            // Prepare the player
            [self.player prepare:mediaConfig];
        }
    }];
}

/*********************************/
#pragma mark - Analytics
/*********************************/

// creates plugin config by adding params under the plugin name.
- (PluginConfig *)createPluginConfig {
    NSMutableDictionary *pluginConfigDict = [[NSMutableDictionary alloc] init];
    pluginConfigDict[PhoenixAnalyticsPlugin.pluginName] = [self createPhoenixPluginConfig];
    return [[PluginConfig alloc] initWithConfig:pluginConfigDict];
}

- (void)addPhoenixAnalyticsObservations {
    [self.player addObserver:self events:@[OttEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received ott event: %@", event.ottEventMessage);
    }];
    
    [self.player addObserver:self events:@[OttEvent.bookmarkError] block:^(PKEvent * _Nonnull event) {
        NSLog(@"Received bookmark error: %@", event.ottEventMessage);
    }];
}

// remove observers
- (void)removeAnalyticsObservations {
    [self.player removeObserver:self events:@[OttEvent.report, OttEvent.bookmarkError]];
}

- (PhoenixAnalyticsPluginConfig *)createPhoenixPluginConfig {
    return [[PhoenixAnalyticsPluginConfig alloc] initWithBaseUrl:@"https://rest-eus1.ott.kaltura.com/restful_v4_8/api_v3/"
                                                   timerInterval:30.0f
                                                              ks:@""
                                                       partnerId:0];
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
