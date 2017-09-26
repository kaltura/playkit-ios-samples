//
//  ViewController.m
//  BasicSample
//
//  Created by Gal Orlanczyk on 15/03/2017.
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

@implementation ViewController
   
/*********************************/
#pragma mark - LifeCycle
/*********************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playheadSlider.continuous = NO;
    
    // Load Player
    NSError *error = [self loadPlayer];
    // Register Player Events
    // >Note: Make sure to register befor `prepare` is called
    //        Otherwise you will miss events
    [self registerPlayerEvents];
    // Prepare Player
    [self preparePlayer:error];
}
 
- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.player.view.frame = self.playerContainer.bounds;
}
    
/*********************************/
#pragma mark - Player Setup
/*********************************/
- (NSError *)loadPlayer {
    // load the player
    NSError *error = nil;
    self.player = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:nil error:&error];
    
    return error;
}

- (void)preparePlayer:(NSError *)error {
    self.player.view = self.playerContainer;
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"sintel";
    MediaSource* source = [[MediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<MediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    MediaEntry *mediaEntry = [[MediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    if (!error) {
        // prepare the player
        [self.player prepare:mediaConfig];
    } else {
        // error loading the player
        NSLog(@"error:: %@",error.description);
    }
}

/*********************************/
#pragma mark - Events Registration
/*********************************/
- (void)registerPlayerEvents {
    [self registerPlayEvent];
    [self registerDurationChangedEvent];
    [self registerPlayerEventStateChangedEvent];
    [self registerErrorEvent];
}

// Handle basic event (Play, Pause, CanPlay ..)
- (void)registerPlayEvent {
    [self.player addObserver:self
                      events:@[PlayerEvent.playing, PlayerEvent.pause]
                       block:^(PKEvent * _Nonnull event) {
        NSLog(@"Several Events Callback");
    }];
    
    [self.player addObserver:self
                      event:PlayerEvent.playing
                       block:^(PKEvent * _Nonnull event) {
        NSLog(@"Playing Event");
    }];
}

// Handle Duration Changes
- (void)registerDurationChangedEvent {
    [self.player addObserver:self
                      events:@[PlayerEvent.durationChanged]
                       block:^(PKEvent * _Nonnull event) {
                           if (event.duration) {
                               NSNumber *duration = event.duration;
                               NSLog(@"Duration Changed Event: %@", duration);
                           }
                       }];
}

// Handle State Changes
- (void)registerPlayerEventStateChangedEvent {
    [self.player addObserver:self
                      events:@[PlayerEvent.stateChanged]
                       block:^(PKEvent * _Nonnull event) {
                           PlayerState oldState = event.oldState;
                           PlayerState newState = event.newState;
                           NSLog(@"State Chnaged Event:: oldState: %d | newState: %d", (int)oldState, (int)newState);
                       }];
}

// Handle Player Errors
- (void)registerErrorEvent {
    [self.player addObserver:self events:@[PlayerEvent.error] block:^(PKEvent * _Nonnull event) {
        NSError *error = event.error;
        if (error && error.code == PKErrorCode.AssetNotPlayable) {
            // handle error
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
