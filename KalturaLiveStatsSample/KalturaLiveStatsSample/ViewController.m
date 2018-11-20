//
//  ViewController.m
//  KalturaLiveStatsSample
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
 This sample will show you how to create a player with kaltura live stats plugin.
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
    NSError *error = nil;
    self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:pluginConfig error:&error];
    // make sure player loaded
    if (!error) {
        // 3. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        [self addKalturaLiveStatsObservations];
        
        // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        [self preparePlayer];
    } else {
        // error loading the player
    }
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
    // setup the player's view
    self.player.view = self.playerContainer;
    
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://www.kaltura.com/p/1953371/sp/0/playManifest/entryId/0_ghzg9q0q/format/applehttp/protocol/https/a.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"sintel";
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    
    // setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    // prepare the player
    [self.player prepare:mediaConfig];
}

/*********************************/
#pragma mark - Analytics
/*********************************/

// creates plugin config by adding params under the plugin name.
- (PluginConfig *)createPluginConfig {
    NSDictionary *pluginConfigDict = @{KalturaLiveStatsPlugin.pluginName: [self createKalturaLiveStatsPluginConfig]};

    return [[PluginConfig alloc] initWithConfig:pluginConfigDict];
}

- (void)addKalturaLiveStatsObservations {
    [self.player addObserver:self events:@[KalturaLiveStatsEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received kaltura live stats event (buffer time): %@", event.kalturaLiveStatsBufferTime);
    }];
}

// remove observers
- (void)removeAnalyticsObservations {
    [self.player removeObserver:self events:@[KalturaLiveStatsEvent.report]];
}

- (KalturaLiveStatsPluginConfig *)createKalturaLiveStatsPluginConfig {
    return [[KalturaLiveStatsPluginConfig alloc] initWithEntryId:@""
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
