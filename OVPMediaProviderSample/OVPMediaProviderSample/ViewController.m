//
//  ViewController.m
//  OVPMediaProviderSample
//
//  Created by Gal Orlanczyk on 20/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"

@import PlayKit;
@import PlayKitOVP;

#define ovpServerUrl @"http://cdnapisec.kaltura.com"
#define ovpPartnerId 1424501
#define ovpEntryId @"1_djnefl4e"

/*
 This sample will show you how to create a player and fetch mediaEntry from kaltura providers.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Register player events.
 3. Prepare Player.
 */
@interface ViewController ()

@property (strong, nonatomic) id<Player> player;
@property (strong, nonatomic) NSTimer *playheadTimer;
@property (strong, nonatomic) OVPMediaProvider *provider;

@property (weak, nonatomic) IBOutlet PlayerView *playerContainer;
@property (weak, nonatomic) IBOutlet UISlider *playheadSlider;

@end

@implementation ViewController

/*********************************/
#pragma mark - LifeCycle
/*********************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playheadSlider.continuous = NO;
    
    [OVPWidgetSession getWithBaseUrl:ovpServerUrl partnerId:ovpPartnerId completion:^(NSString *ks, NSError *err) {
        // 1. Load the player
        NSError *error = nil;
        self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:nil error:&error];
        // make sure player loaded
        if (!error) {
            // 2. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            
            // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            [self preparePlayer:ks];
        } else {
            // error loading the player
        }
    }];
    
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)preparePlayer:(NSString *)ks {
    _provider = [OVPMediaProvider new];
    _provider.baseUrl = ovpServerUrl;
    _provider.partnerId = [NSNumber numberWithInt:ovpPartnerId];
    _provider.ks = ks;
    _provider.entryId = ovpEntryId;
    
    [_provider loadMediaWithCallback:^(PKMediaEntry * _Nullable mediaEntry, NSError * _Nullable error) {
        if (!error) {
            // create media config
            MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
            
            // prepare the player
            [self.player prepare:mediaConfig];
            // setup the player's view
            self.player.view = self.playerContainer;
        }
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
