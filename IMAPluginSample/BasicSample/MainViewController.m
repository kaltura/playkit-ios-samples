#import "MainViewController.h"

#import "Constants.h"
#import "Video.h"
#import "VideoViewController.h"
#import "VideoTableViewCell.h"
@import PlayKit;
@import PlayKit_IMA;


/*
 This sample will show you how to create a player with IMA plugin.
 The steps required:
 1. Conform to Protocol `PlayerDelegate`.
 2. Create IMA plugin config.
 3. Load player with plugin config.
 4. Register events.
 5. Prepare Player.
 */

@interface MainViewController () <UIAlertViewDelegate, PlayerDelegate> // 1

/// Storage point for videos.
@property(nonatomic, copy) NSArray<Video *> *videos;

/// AdsLoader for IMA SDK.
@property(nonatomic, strong) IMAAdsLoader *adsLoader;

/// Language for ad UI.
@property(nonatomic, strong) NSString *language;

@property (strong, nonatomic) id<Player> player;

@end

@implementation MainViewController

/*********************************/
#pragma mark - LifeCycle
/*********************************/

// Set up the app.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.language = @"en";
    [self initVideos];
    
    // For Picture-in-Picture.
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (MediaEntry *)createMediaEntryWithId:(NSString *)entryId andContentURL:(NSURL *)contentURL {
    // create media source and initialize a media entry with that source
    MediaSource* source = [[MediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<MediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    return [[MediaEntry alloc] init:entryId sources:sources duration:-1];
}

// Populate the video array.
- (void)initVideos {
    UIImage *dfpThumbnail = [UIImage imageNamed:@"dfp.png"];
    UIImage *androidThumbnail = [UIImage imageNamed:@"android.png"];
    UIImage *bunnyThumbnail = [UIImage imageNamed:@"bunny.png"];
    UIImage *bipThumbnail = [UIImage imageNamed:@"bip.png"];
    self.videos = @[
                    [[Video alloc] initWithTitle:@"Pre-roll"
                                       thumbnail:dfpThumbnail
                                           video:kDFPContentPath
                                             tag:kPrerollTag],
                    [[Video alloc] initWithTitle:@"Skippable Pre-roll"
                                       thumbnail:androidThumbnail
                                           video:kAndroidContentPath
                                             tag:kSkippableTag],
                    [[Video alloc] initWithTitle:@"Post-roll"
                                       thumbnail:bunnyThumbnail
                                           video:kBigBuckBunnyContentPath
                                             tag:kPostrollTag],
                    [[Video alloc] initWithTitle:@"AdRules"
                                       thumbnail:bipThumbnail
                                           video:kBipBopContentPath
                                             tag:kAdRulesTag],
                    [[Video alloc] initWithTitle:@"AdRules Pods"
                                       thumbnail:dfpThumbnail
                                           video:kDFPContentPath
                                             tag:kAdRulesPodsTag],
                    [[Video alloc] initWithTitle:@"VMAP Pods"
                                       thumbnail:androidThumbnail
                                           video:kAndroidContentPath
                                             tag:kVMAPPodsTag],
                    [[Video alloc] initWithTitle:@"Wrapper"
                                       thumbnail:bunnyThumbnail
                                           video:kBigBuckBunnyContentPath
                                             tag:kWrapperTag],
                    [[Video alloc] initWithTitle:@"AdSense"
                                       thumbnail:bipThumbnail
                                           video:kBipBopContentPath
                                             tag:kAdSenseTag],
                    [[Video alloc] initWithTitle:@"Custom"
                                       thumbnail:androidThumbnail
                                           video:kAndroidContentPath
                                             tag:@"custom"]
                    ];
}

// Initialize AdsLoader.
- (void)setUpAdsLoader {
    if (self.adsLoader) {
        self.adsLoader = nil;
    }
    IMASettings *settings = [[IMASettings alloc] init];
    settings.language = self.language;
    settings.enableBackgroundPlayback = YES;
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:settings];
}

// When an item is selected, set the video item on the VideoViewController.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showVideo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Video *video = self.videos[indexPath.row];
        
        VideoViewController *destVC = (VideoViewController *)[segue destinationViewController];
        destVC.video = video;
        
        if (_player) {
            NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8"];
            NSString *entryId = @"Kaltura Media";
            MediaEntry *mediaEntry = [self createMediaEntryWithId:entryId andContentURL:contentURL];
            
            MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
            IMAConfig *adsConfig = [IMAConfig new];
            adsConfig.adTagUrl = video.tag;
            [self.player updatePluginConfigWithPluginName:@"IMAPlugin" config:adsConfig];
            destVC.mediaConfig = mediaConfig;
            destVC.player = self.player;
            
            return;
        }
        
        PluginConfig *pluginConfig = [self createPluginConfig:video]; // 2
        
        // 1. Load the player
        NSError *error = nil;
        self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:pluginConfig error:&error];
        self.player.delegate = self;
        // make sure player loaded
        if (!error) {
            // 2. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            
            // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            //[self preparePlayer];
            destVC.player = self.player;
            destVC.mediaConfig = [self firstMediaConfig];
            [self.player addObserver:self events:@[PlayerEvent.error] block:^(PKEvent * _Nonnull event) {
                event.error;
            }];
        } else {
            NSLog(@"%@", error.description);
            // error loading the player
        }
    }
}

/*********************************/
#pragma mark - Player Setup
/*********************************/

- (PluginConfig *)createPluginConfig:(Video *)video {
    NSMutableDictionary *pluginConfigDict = [NSMutableDictionary new];
    
    
    IMAConfig *imaConfig = [IMAConfig new];
    imaConfig.adTagUrl = video.tag;
    
    pluginConfigDict[IMAPlugin.pluginName] = imaConfig;
    
    NSDictionary *youboraPluginParams = @{
                                          @"accountCode": @"kalturatest",
                                          [YouboraPlugin enableSmartAdsKey]: @true // enables youbora smart ads
                                          };
    AnalyticsConfig *youboraConfig = [[AnalyticsConfig alloc] initWithParams:youboraPluginParams];
    pluginConfigDict[YouboraPlugin.pluginName] = youboraConfig;
    
    return [[PluginConfig alloc] initWithConfig:pluginConfigDict];
}

- (MediaConfig *)firstMediaConfig {
    NSURL *contentURL = [[NSURL alloc] initWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
    // create media source and initialize a media entry with that source
    NSString *entryId = @"sintel";
    MediaSource* source = [[MediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<MediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    MediaEntry *mediaEntry = [[MediaEntry alloc] init:entryId sources:sources duration:-1];
    
    // create media config
    MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
    
    
    
    // prepare the player
    //[self.player prepare:mediaConfig];
    return mediaConfig;
}

// Only allow one selection.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Returns number of items to be presented in the table.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

// Sets the display info for each table row.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Video *selectedVideo = self.videos[indexPath.row];
    [cell populateWithVideo:selectedVideo];
    return cell;
}

// Standard override.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)playerShouldPlayAd:(id<Player>)player {
    return YES;
}

@end
