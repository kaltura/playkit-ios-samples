//
//  ViewController.m
//  KalturaAnalyticsSample
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

/*********************************/
// Plugin registration should be done in App Delegate!!!
// Don't forget to add it in your project.
// Look at `AppDelegate` to see the registration.
/*********************************/

@implementation ViewController

/*********************************/
#pragma mark - LifeCycle
/*********************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup our player instance
    [self setupPlayer];
    // because we are using live source set silder to be disabled
    self.playheadSlider.enabled = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.player.view.frame = self.playerContainer.bounds;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // remove observers
    [self removeAnalyticsObservations];
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (void)setupPlayer {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://nasatv-lh.akamaihd.net/i/NASA_101@319270/master.m3u8"];
    
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
    self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:[self createPluginConfig] error:&error];
    
    if (!error) {
        // add observers, **makes sure to call this **after** player creation otherwise no observation will be added**
        [self addAnalyticsObservations];
        
        [self.player prepare:mediaConfig];
        [self.playerContainer addSubview:self.player.view];
    } else {
        // error loading the player
    }
}

/*********************************/
#pragma mark - Analytics
/*********************************/

// creates plugin config by adding params under the plugin name.
// in real app just add the plugins you need.
- (PluginConfig *)createPluginConfig {
    NSMutableDictionary *pluginConfigDict = [[NSMutableDictionary alloc] init];
    
    pluginConfigDict[PhoenixAnalyticsPlugin.pluginName] = [self createPhoenixPluginConfig];
    pluginConfigDict[TVPAPIAnalyticsPlugin.pluginName] = [self createTVPAPIPluginConfig];
    pluginConfigDict[KalturaStatsPlugin.pluginName] = [self createKalturaStatsPluginConfig];
    pluginConfigDict[KalturaLiveStatsPlugin.pluginName] = [self createKalturaLiveStatsPluginConfig];
    
    return [[PluginConfig alloc] initWithConfig:pluginConfigDict];
}

// adds analytics observers
// in real app just add the observers you need.
- (void)addAnalyticsObservations {
    [self.player addObserver:self events:@[OttEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received ott event: %@", event.ottEventMessage);
    }];
    
    [self.player addObserver:self events:@[KalturaStatsEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received kaltura stats event: %@", event.kalturaStatsMessage);
    }];
    
    [self.player addObserver:self events:@[KalturaLiveStatsEvent.report] block:^(PKEvent * _Nonnull event) {
        NSLog(@"received kaltura live stats event(buffer time): %@", event.kalturaLiveStatsBufferTime);
    }];
}

// remove analytcis observers
- (void)removeAnalyticsObservations {
    [self.player removeObserver:self events:@[OttEvent.report, KalturaStatsEvent.report, KalturaLiveStatsEvent.report]];
}

- (AnalyticsConfig *)createPhoenixPluginConfig {
    NSDictionary *phoenixPluginParams = @{
                                          @"fileId": @"",
                                          @"baseUrl": @"",
                                          @"ks": @"",
                                          @"partnerId": @0,
                                          @"timerInterval": @30
                                          };
    return [[AnalyticsConfig alloc] initWithParams:phoenixPluginParams];
}

- (AnalyticsConfig *)createTVPAPIPluginConfig {
    NSDictionary *tvpapiPluginParams = @{
                                         @"fileId": @"",
                                         @"baseUrl": @"",
                                         @"timerInterval": @30,
                                         @"initObj":
                                             @{
                                                 @"Token": @"",
                                                 @"SiteGuid": @"",
                                                 @"ApiUser": @"",
                                                 @"DomainID": @"",
                                                 @"UDID": @"",
                                                 @"ApiPass": @"",
                                                 @"Locale": @{
                                                         @"LocaleUserState": @"",
                                                         @"LocaleCountry": @"",
                                                         @"LocaleDevice": @"",
                                                         @"LocaleLanguage": @""
                                                         },
                                                 @"Platform": @""
                                                 }
                                         };
    return [[AnalyticsConfig alloc] initWithParams:tvpapiPluginParams];
}

- (AnalyticsConfig *)createKalturaStatsPluginConfig {
    NSDictionary *kalturaStatsPluginParams = @{
                                               @"sessionId": @"",
                                               @"uiconfId": @0,
                                               @"baseUrl": @"",
                                               @"partnerId": @0,
                                               @"timerInterval": @30
                                               };
    
    return [[AnalyticsConfig alloc] initWithParams:kalturaStatsPluginParams];
}

- (AnalyticsConfig *)createKalturaLiveStatsPluginConfig {
    NSDictionary *kalturaLiveStatsPluginParams = @{
                                                   @"sessionId": @"",
                                                   @"uiconfId": @0,
                                                   @"baseUrl": @"",
                                                   @"partnerId": @0,
                                                   @"timerInterval": @30
                                                   };
    return [[AnalyticsConfig alloc] initWithParams:kalturaLiveStatsPluginParams];
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
