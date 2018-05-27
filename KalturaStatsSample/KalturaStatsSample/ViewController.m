//
//  ViewController.m
//  KalturaStatsSample
//
//  Created by Gal Orlanczyk on 21/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"
#import "PlayKit-Swift.h"

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
 This sample will show you how to create a player with kaltura stats plugin.
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
        [self addKalturaStatsObservations];
        
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

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)preparePlayer {
    // setup the player's view
    self.player.view = self.playerContainer;
    
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
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
    NSMutableDictionary *pluginConfigDict = [[NSMutableDictionary alloc] init];
    pluginConfigDict[KalturaStatsPlugin.pluginName] = [self createKalturaStatsPluginConfig];
    return [[PluginConfig alloc] initWithConfig:pluginConfigDict];
}

- (void)addKalturaStatsObservations {
    [self.player addObserver:self events:@[KalturaStatsEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received kaltura stats event: %@", event.kalturaStatsMessage);
    }];
}

// remove observers
- (void)removeAnalyticsObservations {
    [self.player removeObserver:self events:@[KalturaStatsEvent.report]];
}

- (KalturaStatsPluginConfig *)createKalturaStatsPluginConfig {
    return [[KalturaStatsPluginConfig alloc] initWithUiconfId:0
                                                    partnerId:0
                                                      entryId:@""
                                                  hasKanalony:NO];
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
