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
@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@property (weak, nonatomic) IBOutlet UISlider *playheadSlider;
    
@end

@implementation ViewController
   
/*********************************/
#pragma mark - LifeCycle
/*********************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup our player instance
    [self setupPlayer];
    // register player events
    [self registerPlayerEvents:[self playerEvents]];
}
 
- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.player.view.frame = self.playerContainer.bounds;
}
    
/*********************************/
#pragma mark - Player Setup
/*********************************/
    
- (void)setupPlayer {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"sintel";
    MediaSource* source = [[MediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<MediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    MediaEntry *mediaEntry = [[MediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    // load the player
    NSError *error = nil;
    self.player = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:nil error:&error];
    
    if (!error) {
        [self.player prepare:mediaConfig];
        [self.playerContainer addSubview:self.player.view];
    } else {
        // error loading the player
    }
}

/*********************************/
#pragma mark - Events Registration
/*********************************/
- (NSArray *)playerEvents {
    return @[PlayerEvent.playing,
             PlayerEvent.durationChanged,
             PlayerEvent.stateChanged];
}

- (void)registerPlayerEvents:(NSArray *)events {
    // add observer to list of different events
    [self.player addObserver:self events:events block:^(PKEvent * _Nonnull event) {
        if ([event isKindOfClass:PlayerEvent.playing]) {
            NSLog(@"Playing Event");
        } else if ([event isKindOfClass:PlayerEvent.durationChanged]) {
            NSNumber *duration = event.duration;
            NSLog(@"Duration Changed Event: %@", duration);
        } else if ([event isKindOfClass:PlayerEvent.stateChanged]) {
            PlayerState oldState = event.oldState;
            PlayerState newState = event.newState;
            NSLog(@"State Chnaged Event:: oldState: %d | newState: %d", (int)oldState, (int)newState);
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
