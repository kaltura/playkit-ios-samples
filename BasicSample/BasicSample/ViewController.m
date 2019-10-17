//
//  ViewController.m
//  BasicSample
//
//  Created by Gal Orlanczyk on 15/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"
#import "PlayKit-Swift.h"

/*
 This sample will show you how to create a player with basic functionality.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Register player events.
 3. Prepare Player.
 */
@interface ViewController ()

@property (strong, nonatomic) id<Player> player;
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
    
    // 1. Load the player
    self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:nil];
    
    // 2. Register events if have ones.
    // Event registeration must be after loading the player successfully to make sure events are added,
    // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
    __weak __typeof__(self) weakSelf = self;
    [self.player addObserver:self event:PlayerEvent.playheadUpdate block:^(PKEvent *event) {
        __typeof__(self) strongSelf = weakSelf;
        strongSelf.playheadSlider.value = strongSelf.player.currentTime / strongSelf.player.duration;
    }];
    // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
    [self preparePlayer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
    
/*********************************/
#pragma mark - Player Setup
/*********************************/
    
- (void)preparePlayer {
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
#pragma mark - Actions
/*********************************/
    
- (IBAction)playTouched:(UIButton *)sender {
    if(!self.player.isPlaying) {
        [self.player play];
    }
}
    
- (IBAction)pauseTouched:(UIButton *)sender {
    if(self.player.isPlaying) {
        [self.player pause];
    }
}
    
- (IBAction)playheadValueChanged:(UISlider *)sender {
    NSLog(@"playhead value: %f", sender.value);
    self.player.currentTime = self.player.duration * sender.value;
}
   
- (void)playheadUpdate {
    
}
    
@end
