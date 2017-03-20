//
//  ViewController.m
//  OVPMediaProviderSample
//
//  Created by Gal Orlanczyk on 20/03/2017.
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
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.player.view.frame = self.playerContainer.bounds;
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)setupPlayer {
    NSString *serverURL = @"https://cdnapisec.kaltura.com";
    int64_t partnerId = 2215841;
    // in real app you will need to provide a ks if your app need it, if not keep empty for anonymous session.
    SimpleOVPSessionProvider *sessionProvider = [[SimpleOVPSessionProvider alloc] initWithServerURL:serverURL partnerId:partnerId ks:@""];
    OVPMediaProvider *mediaProvider = [[OVPMediaProvider alloc] init:sessionProvider];
    mediaProvider.entryId = @"1_w9zx2eti";
    
    [mediaProvider loadMediaWithCallback:^(MediaEntry * _Nullable mediaEntry, NSError * _Nullable error) {
        if (!error) {
            // create media config
            MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
            
            // load the player
            NSError *error = nil;
            self.player = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:nil error:&error];
            
            if (!error) {
                [self.player prepare:mediaConfig];
                [self.playerContainer addSubview:self.player.view];
                self.player.view.frame = self.playerContainer.bounds;
            } else {
                // error loading the player
            }
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
