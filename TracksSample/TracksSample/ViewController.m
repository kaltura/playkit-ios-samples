//
//  ViewController.m
//  BasicSample
//
//  Created by Gal Orlanczyk on 15/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"

@import PlayKit;

@interface ViewController ()

@property (strong, nonatomic) id<Player> player;
@property (strong, nonatomic) NSTimer *playheadTimer;
@property (weak, nonatomic) IBOutlet PlayerView *playerContainer;
@property (weak, nonatomic) IBOutlet UISlider *playheadSlider;

@property (weak, nonatomic) NSArray *audioTracks;
@property (weak, nonatomic) NSArray *textTracks;
@property (weak, nonatomic) NSArray *selectedTracks;

@end

@implementation ViewController

/*********************************/
#pragma mark - LifeCycle
/*********************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playheadSlider.continuous = NO;
    // setup our player instance
    [self setupPlayer];
    
    // handle audio/ text tracks
    [self handleTracks];
    // get current bitrate value
    [self currentBitrateHandler];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)setupPlayer {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"bipbop_16x9";
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    // load the player
    self.player = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:nil];
    
    [self.player prepare:mediaConfig];
    self.player.view = self.playerContainer;
    [self.playerContainer sendSubviewToBack:self.player.view];
}

/*********************************/
#pragma mark - Tracks
/*********************************/

// Handle Available Tracks and Present Them
- (void)handleTracks {
    // don't forget to use weak self to prevent retain cycles when needed
    __weak __typeof(self) weakSelf = self;
    
    // add observer to tracksAvailable event
    [self.player addObserver:self events:@[PlayerEvent.tracksAvailable, PlayerEvent.textTrackChanged, PlayerEvent.audioTrackChanged] block:^(PKEvent * _Nonnull event) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if ([event isKindOfClass:PlayerEvent.tracksAvailable]) {
            
            // Extract Audio Tracks
            if (event.tracks.audioTracks) {
                strongSelf.audioTracks = event.tracks.audioTracks;
                
                // Set Defualt array for Picker View
                strongSelf.selectedTracks = strongSelf.audioTracks;
            }
            // Extract Text Tracks
            if (event.tracks.textTracks) {
                strongSelf.textTracks = event.tracks.textTracks;
            }
        } else if ([event isKindOfClass:PlayerEvent.textTrackChanged]) {
            NSLog(@"selected text track:: %@", event.selectedTrack.title);
        } else if ([event isKindOfClass:PlayerEvent.audioTrackChanged]) {
            NSLog(@"selected audio track:: %@", event.selectedTrack.title);
        }
    }];
    
    [self printCurrentTrack];
}


// Get Current Audio/ Text Track
- (void)printCurrentTrack {
    NSLog(@"currentAudioTrack:: %@", self.player.currentAudioTrack);
    NSLog(@"currentTextTrack:: %@", self.player.currentTextTrack);
}

// Get Current Bitrate
- (void)currentBitrateHandler {
    [self.player addObserver:self events:@[PlayerEvent.playbackInfo] block:^(PKEvent * _Nonnull event) {
        if ([event isKindOfClass:PlayerEvent.playbackInfo]) {
            // Get Current Bitrate Value
            if (event.playbackInfo) {
                NSLog(@"%@", event.playbackInfo);
            }
        }
    }];
}

// Select Track
- (void)selectTrack:(Track *)track {
    [self.player selectTrackWithTrackId:track.id];
}

/*********************************/
// Tracks - Picker View
/*********************************/
- (IBAction)audioTracksTapped:(id)sender {
    self.selectedTracks = self.audioTracks;
    [self.picker reloadAllComponents];
}

- (IBAction)textTracksTapped:(id)sender {
    self.selectedTracks = self.textTracks;
    [self.picker reloadAllComponents];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.selectedTracks.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return ((Track *)self.selectedTracks[row]).title;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self selectTrack:((Track *)self.selectedTracks[row])];
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

