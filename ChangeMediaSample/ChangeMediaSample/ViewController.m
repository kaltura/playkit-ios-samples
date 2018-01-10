//
//  ViewController.m
//  ChangeMediaSample
//
//  Created by Gal Orlanczyk on 20/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"
#import "PlayKit-Swift.h"

/*
 This sample will show you how to change media on player with basic functionality.
 The steps required to Chgange Media:
 1. Stop Player
 2. Call Prepare with new MediaConfig
 
 ** Not Recommended **
 Just in case you wish to remove Player and Recreate when Media Changed 
 go to "changeMediaByRecreation" method.
 */

@interface ViewController ()

@property (strong, nonatomic) id<Player> player;
@property (strong, nonatomic) NSTimer *playheadTimer;
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
    [self setupPlayerWithMediaConfig:[self getDefaultMediaConfig]];
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.player.view.frame = self.playerContainer.bounds;
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)setupPlayerWithMediaConfig:(MediaConfig *)mediaConfig {
    // 1. Load the player
    NSError *error = nil;
    self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:nil error:&error];
    // make sure player loaded
    if (!error) {
        // 2. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        
        // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        [self preparePlayerWithMediaConfig:mediaConfig];
    } else {
        // error loading the player
    }
}

- (void)preparePlayerWithMediaConfig:(MediaConfig *)mediaConfig {
    // setup the view
    self.player.view = self.playerContainer;
    // prepare the player
    [self.player prepare:mediaConfig];
    // need to set player view each setup because we create the player when changing media.
    self.player.view.frame = self.playerContainer.bounds;
}

// creates default media config for this sample, in real app media config will need to be different for each media entry.
- (MediaConfig *)getDefaultMediaConfig {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    NSString *entryId = @"sintel";
    PKMediaEntry *mediaEntry = [self createMediaEntryWithId:entryId andContentURL:contentURL];
    // create media config
    return [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
}

- (PKMediaEntry *)createMediaEntryWithId:(NSString *)entryId andContentURL:(NSURL *)contentURL {
    // create media source and initialize a media entry with that source
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    return [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
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

- (IBAction)changeMediaTouched:(UIButton *)sender {
    // create mediaEntry for change media, you can use differrent params here.
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8"];
    NSString *entryId = @"KalturaMedia";
    PKMediaEntry *mediaEntry = [self createMediaEntryWithId:entryId andContentURL:contentURL];
    // Resets The Player And Prepares for Change Media
    [self.player stop]; // 1. Stop Player
    // Create new Media Config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    // Call Prepare
    [self.player prepare:mediaConfig]; // 2. Call Prepare with new MediaConfig
    
    // don't forget to use weak self to prevent retain cycles when needed
    __weak __typeof(self) weakSelf = self;
    // After preparing if you wish to play make sure to wait `canPlay` event.
    [self.player addObserver:self events:@[PlayerEvent.canPlay] block:^(PKEvent * _Nonnull event) {
        [weakSelf playTouched:nil];
    }];
}

// ** Not Recommended **
// Change Media by Remove & Recreation
- (void)changeMediaByRecreation {
    // to change the media we remove player view from container, destroy the player and create a new instance.
        [self.player.view removeFromSuperview];
        [self.player destroy];
        self.player = nil;

    // setup our player instance
    [self setupPlayerWithMediaConfig:[self getDefaultMediaConfig]];
}

@end
