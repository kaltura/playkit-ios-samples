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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the player
    self.player = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:nil];
    
    // Register events if needed.
    // Event registeration must be after loading the player successfully to make sure events are added, and before prepare to make sure no events are missed (when calling prepare player starts buffering and sends events)
    // Handle audio/ text tracks
    [self handleTracks];
    // Get current bitrate value
    [self handlePlaybackInfo];
    [self handlePlayheadUpdate];
    [self setupTextTrackStyling];
    
    [self setupPlayer];
    
    self.playheadSlider.continuous = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*********************************/
#pragma mark - Private Methods
/*********************************/

- (void)setupPlayer {
    // Setup the player's view
    self.player.view = self.playerContainer;
    [self.playerContainer sendSubviewToBack:self.player.view];
    
    // Uncomment the type of media needed
//    PKMediaEntry *mediaEntry = [self getMediaWithInternalSubtitles];
    PKMediaEntry *mediaEntry = [self getMediaWithExternalSubtitles];
    
    // Create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    // Set if we want the player to auto select the subtitles.
    self.player.settings.trackSelection.textSelectionMode = TrackSelectionModeAuto;
    self.player.settings.trackSelection.textSelectionLanguage = @"en";
    
    [self.player prepare:mediaConfig];
}

- (PKMediaEntry *)getMediaWithInternalSubtitles {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"];
    
    // Create media source and initialize a media entry with that source
    NSString *entryId = @"bipbop_16x9";
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // Setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
    return mediaEntry;
}

- (PKMediaEntry *)getMediaWithExternalSubtitles {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/1_9bwuo813/flavorIds/0_vfdi28n9,1_5j0bgx4v,1_x6tlvn4x,1_zj4vzg46/deliveryProfileId/19201/protocol/https/format/applehttp/a.m3u8"];
    
    // Create media source and initialize a media entry with that source
    NSString *entryId = @"1_9bwuo813";
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // Setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
    mediaEntry.externalSubtitles = @[[[PKExternalSubtitle alloc] initWithId:@"Deutsch-de"
                                                                       name:@"Deutsch"
                                                                  isDefault:NO
                                                                 autoSelect:NO
                                                                     forced:NO
                                                                   language:@"de"
                                                            characteristics:nil
                                                               vttURLString:@"http://brenopolanski.com/html5-video-webvtt-example/MIB2-subtitles-pt-BR.vtt"
                                                                   duration:57.0],
                                     [[PKExternalSubtitle alloc] initWithId:@"English-en"
                                                                       name:@"English"
                                                                  isDefault:YES
                                                                 autoSelect:YES
                                                                     forced:NO
                                                                   language:@"en"
                                                            characteristics:nil
                                                               vttURLString:@"http://externaltests.dev.kaltura.com/player/captions_files/eng.vtt"
                                                                   duration:57.0]];
    
    return mediaEntry;
}

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
- (void)handlePlaybackInfo {
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

- (void)handlePlayheadUpdate {
    __weak __typeof(self) weakSelf = self;
    
    [self.player addObserver:self events:@[PlayerEvent.playheadUpdate] block:^(PKEvent * _Nonnull event) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf playheadUpdate];
    }];
}

- (void)playheadUpdate {
    self.playheadSlider.value = self.player.currentTime / self.player.duration;
}

- (void)setupTextTrackStyling {
    [self.player.settings.textTrackStyling setTextColor:[UIColor redColor]];
    [self.player.settings.textTrackStyling setBackgroundColor:[UIColor whiteColor]];
    [self.player.settings.textTrackStyling setTextSizeWithPercentageOfVideoHeight:10];
    [self.player.settings.textTrackStyling setEdgeStyle:PKTextMarkupCharacterEdgeStyleDropShadow];
    [self.player.settings.textTrackStyling setEdgeColor:[UIColor yellowColor]];
    [self.player.settings.textTrackStyling setFontFamily:@"Helvetica"];
}

/*********************************/
#pragma mark - Picker View
/*********************************/

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

- (IBAction)audioTracksTapped:(id)sender {
    self.selectedTracks = self.audioTracks;
    [self.picker reloadAllComponents];
}

- (IBAction)textTracksTapped:(id)sender {
    self.selectedTracks = self.textTracks;
    [self.picker reloadAllComponents];
}

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

@end

