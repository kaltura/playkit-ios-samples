//
//  ViewController.m
//  BasicSample
//
//  Created by Gal Orlanczyk on 15/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import "ViewController.h"
#import "PlayKit-Swift.h"

@interface ViewController () {
    NSString *playerCommand;
}

@property (strong, nonatomic) id<Player> player;
@property (strong, nonatomic) NSTimer *playheadTimer;
@property (weak, nonatomic) IBOutlet PlayerView *playerContainer;
@property (weak, nonatomic) IBOutlet UISlider *playheadSlider;
@property (strong, nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (strong, nonatomic) SFSpeechRecognitionTask *recognitionTask;
@property (strong, nonatomic) AVAudioEngine *audioEngine;

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
    
    // setup Speech Recognizer
    [self setupSpeechRecognizer];
    
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
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    // load the player
    NSError *error = nil;
    self.player = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:nil error:&error];
    
    if (!error) {
        self.player.view = self.playerContainer;
        [self.player prepare:mediaConfig];
    } else {
        // error loading the player
    }
}

/*********************************/
#pragma mark - Speech Recognition
/*********************************/

- (void)setupSpeechRecognizer {
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]]; //1
    
    self.speechRecognizer.delegate = self;  //3
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus authStatus) { //4
        BOOL isButtonEnabled = NO;
        
        switch (authStatus) { //5
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                isButtonEnabled = YES;
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                isButtonEnabled = NO;
                NSLog(@"User denied access to speech recognition");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                isButtonEnabled = NO;
                NSLog(@"Speech recognition restricted on this device");
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                isButtonEnabled = NO;
                NSLog(@"Speech recognition not yet authorized");
                break;
        }
        
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            // Background work
//            dispatch_async(dispatch_get_main_queue(), ^(void) {
                // Main thread work (UI usually)
                self.microphoneButton.enabled = isButtonEnabled;
//            });
//        });
    }];
    
    self.audioEngine = [AVAudioEngine new];
}

- (void)startRecording {
    // don't forget to use weak self to prevent retain cycles when needed
    __weak __typeof(self) weakSelf = self;
    if (_recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = AVAudioSession.sharedInstance;
    
    @try {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
        [audioSession setActive:YES error:nil];
    } @catch (NSException *exception) {
        NSLog(@"audioSession properties weren't set because of an error.");
    }
    
    
    self.recognitionRequest = [SFSpeechAudioBufferRecognitionRequest new];
        
    if (!self.audioEngine.inputNode) {
        assert(@"Audio engine has no input node");
    }
    
    if (!self.recognitionRequest) {
        assert(@"Unable to create an SFSpeechAudioBufferRecognitionRequest object");
    }
        
    self.recognitionRequest.shouldReportPartialResults = YES;
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        BOOL isFinal = NO;
        
        if (result) {
            playerCommand = result.bestTranscription.formattedString;
            isFinal = result.isFinal;
        }
        
        if (error || isFinal) {
            [weakSelf.audioEngine stop];
            [weakSelf.audioEngine.inputNode removeTapOnBus:0];
            
            weakSelf.recognitionRequest = nil;
            weakSelf.recognitionTask = nil;
            
            weakSelf.microphoneButton.enabled = YES;
        }
    }];
    
    AVAudioFormat *recordingFormat = [self.audioEngine.inputNode outputFormatForBus:0];
    [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [weakSelf.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
        
    [self.audioEngine prepare];
    
    @try {
        [self.audioEngine startAndReturnError:nil];
    } @catch (NSException *exception) {
        NSLog(@"audioEngine couldn't start because of an error.");
    }
}

- (void)speechRecognizer:(SFSpeechRecognizer*)sr availabilityDidChange:(BOOL)available {
    if (available) {
        self.microphoneButton.enabled = YES;
    } else {
        self.microphoneButton.enabled = NO;
    }
}

- (IBAction)microphoneTapped:(id)sender {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
        self.microphoneButton.enabled = NO;
        [self.microphoneButton setTitle:@"Start Recording" forState:UIControlStateNormal];
        if ([playerCommand containsString:@"Play"]) {
            [self.player play];
        } else if ([playerCommand containsString:@"Pause"]) {
            [self.player pause];
        }
    } else {
        [self startRecording];
        [self.microphoneButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
    }
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
