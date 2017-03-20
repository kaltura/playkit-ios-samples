//
//  ViewController.m
//  ChangeMediaSample
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
    // create mediaEntry to setup player
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    NSString *entryId = @"sintel";
    MediaEntry *mediaEntry = [self createMediaEntryWithId:entryId andContentURL:contentURL];
    // setup our player instance
    [self setupPlayerWithMediaEntry:mediaEntry];
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.player.view.frame = self.playerContainer.bounds;
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)setupPlayerWithMediaEntry:(MediaEntry *)mediaEntry {
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    // load the player
    NSError *error = nil;
    self.player = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:nil error:&error];
    
    if (!error) {
        [self.player prepare:mediaConfig];
        [self.playerContainer addSubview:self.player.view];
        // need to set player view each setup because we create the player when changing media.
        self.player.view.frame = self.playerContainer.bounds;
    } else {
        // error loading the player
    }
}

- (MediaEntry *)createMediaEntryWithId:(NSString *)entryId andContentURL:(NSURL *)contentURL {
    // create media source and initialize a media entry with that source
    MediaSource* source = [[MediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<MediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    return [[MediaEntry alloc] init:entryId sources:sources duration:-1];
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
    // to change the media we remove player view from container, destroy the player and create a new instance.
    [self.player.view removeFromSuperview];
    [self.player destroy];
    self.player = nil;
    // create mediaEntry to setup player for change media, you can use differrent params here.
    // for the sake of this example we will use same content url and id.
    // in a real app you can select more properties to be changed not just the content url and id.
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    NSString *entryId = @"sintel";
    MediaEntry *mediaEntry = [self createMediaEntryWithId:entryId andContentURL:contentURL];
    // setup our player instance
    [self setupPlayerWithMediaEntry:mediaEntry];
}

@end
