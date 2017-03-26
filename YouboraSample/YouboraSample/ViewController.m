//
//  ViewController.m
//  YouboraSample
//
//  Created by Gal Orlanczyk on 20/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"
#import "PlayKit-Swift.h"

/*
 This sample will show you how to create a player with youbora plugin.
 The steps required:
 1. Create youbora plugin config.
 2. Load player with plugin config.
 3. Register events.
 4. Prepare Player.
 */
@interface ViewController ()

@property (strong, nonatomic) id<Player> player;
@property (strong, nonatomic) NSTimer *playheadTimer;
@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@property (weak, nonatomic) IBOutlet UISlider *playheadSlider;

@end

@implementation ViewController

/*********************************/
#pragma mark - LifeCycle
/*********************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playheadSlider.continuous = NO;
    
    // 1. create plugin config
    PluginConfig *pluginConfig = [self createPluginConfig];
    // 2. Load the player
    NSError *error = nil;
    self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:pluginConfig error:&error];
    // make sure player loaded
    if (!error) {
        // 3. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        [self addYouboraObservations];
        
        // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        [self preparePlayer];
    } else {
        // error loading the player
    }
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.player.view.frame = self.playerContainer.bounds;
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (PluginConfig *)createPluginConfig {
    NSMutableDictionary *pluginConfigDict = [[NSMutableDictionary alloc] init];
    pluginConfigDict[YouboraPlugin.pluginName] = [self createYouboraPluginConfig];
    return [[PluginConfig alloc] initWithConfig:pluginConfigDict];
}

- (void)preparePlayer {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"sintel";
    MediaSource* source = [[MediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<MediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    MediaEntry *mediaEntry = [[MediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    [self.player prepare:mediaConfig];
    
    [self.playerContainer addSubview:self.player.view];
    self.player.view.frame = self.playerContainer.bounds;
}

/*********************************/
#pragma mark - Youbora
/*********************************/

- (AnalyticsConfig *)createYouboraPluginConfig {
    // account code is mandatory, make sure to put the correct one.
    NSDictionary *youboraPluginParams = @{
                                          @"accountCode": @"nicetest",
                                          @"httpSecure": @YES,
                                          @"parseHLS": @YES,
                                          @"media": @{
                                                  @"title": @"Sintel",
                                                  @"duration": @600
                                                  },
                                          @"properties": @{
                                                  @"year": @"2001",
                                                  @"genre": @"Fantasy",
                                                  @"price": @"free"
                                                  },
                                          @"network": @{
                                                  @"ip": @"1.2.3.4"
                                                  },
                                          @"ads": @{
                                                  @"adsExpected": @YES,
                                                  @"campaign": @"Ad campaign name"
                                                  },
                                          @"extraParams": @{
                                                  @"param1": @"Extra param 1 value",
                                                  @"param2": @"Extra param 2 value"
                                                  }
                                          };
    return [[AnalyticsConfig alloc] initWithParams:youboraPluginParams];
}

// adds analytics observers
- (void)addYouboraObservations {
    [self.player addObserver:self events:@[YouboraEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received youbora report event: %@", event.youboraMessage);
    }];
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
