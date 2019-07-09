#import "MainViewController.h"

#import "Constants.h"
#import "Video.h"
#import "VideoViewController.h"
#import "VideoTableViewCell.h"
@import PlayKit;
@import PlayKit_IMA;
@import PlayKitYoubora;


/*
 This sample will show you how to create a player with IMA plugin.
 The steps required:
 1. Create IMA plugin config.
 2. Load player with plugin config.
 3. Register events.
 4. Prepare Player.
 */

@interface MainViewController () <UIAlertViewDelegate> // 1

/// Storage point for videos.
@property(nonatomic, copy) NSArray<Video *> *videos;
@property (strong, nonatomic) id<Player> player;

@end

@implementation MainViewController

/*********************************/
#pragma mark - LifeCycle
/*********************************/

// Set up the app.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVideos];
    
    // For Picture-in-Picture.
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (PKMediaEntry *)createMediaEntryWithId:(NSString *)entryId andContentURL:(NSURL *)contentURL {
    // create media source and initialize a media entry with that source
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    return [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
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
                                             tag:kPrerollTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"Skippable Pre-roll"
                                       thumbnail:androidThumbnail
                                           video:kAndroidContentPath
                                             tag:kSkippableTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"Post-roll"
                                       thumbnail:bunnyThumbnail
                                           video:kBigBuckBunnyContentPath
                                             tag:kPostrollTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"AdRules"
                                       thumbnail:bipThumbnail
                                           video:kBipBopContentPath
                                             tag:kAdRulesTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"AdRules Pods"
                                       thumbnail:dfpThumbnail
                                           video:kDFPContentPath
                                             tag:kAdRulesPodsTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"VMAP Pods"
                                       thumbnail:androidThumbnail
                                           video:kAndroidContentPath
                                             tag:kVMAPPodsTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"Wrapper"
                                       thumbnail:bunnyThumbnail
                                           video:kBigBuckBunnyContentPath
                                             tag:kWrapperTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"AdSense"
                                       thumbnail:bipThumbnail
                                           video:kBipBopContentPath
                                             tag:kAdSenseTag
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"Custom"
                                       thumbnail:androidThumbnail
                                           video:kAndroidContentPath
                                             tag:@"custom"
                                     adsResponse:nil],
                    [[Video alloc] initWithTitle:@"Pre-roll adsResponse"
                                       thumbnail:dfpThumbnail
                                           video:kDFPContentPath
                                             tag:nil
                                     adsResponse:kPrerollAdsResponse]
                    ];
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
            PKMediaEntry *mediaEntry = [self createMediaEntryWithId:entryId andContentURL:contentURL];
            
            MediaConfig *mediaConfig = [[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0.0];
            IMAConfig *adsConfig = [IMAConfig new];
            adsConfig.adTagUrl = video.tag;
            adsConfig.adsResponse = video.adsResponse;
            adsConfig.playerVersion = PlayKitManager.versionString;
            [self.player updatePluginConfigWithPluginName:@"IMAPlugin" config:adsConfig];
            destVC.mediaConfig = mediaConfig;
            destVC.player = self.player;
            
            return;
        }
        
        PluginConfig *pluginConfig = [self createPluginConfig:video]; // 2
        
        // 1. Load the player
        self.player = [[PlayKitManager sharedInstance] loadPlayerWithPluginConfig:pluginConfig];
        
        // 2. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        [self.player addObserver:self events:@[PlayerEvent.error] block:^(PKEvent * _Nonnull event) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"An error has occurred" message:event.error.description preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        }];
        
        // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        //[self preparePlayer];
        destVC.player = self.player;
        destVC.mediaConfig = [self firstMediaConfig];
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
    PKMediaSource* source = [[PKMediaSource alloc] init:entryId contentUrl:contentURL mimeType:nil drmData:nil mediaFormat:MediaFormatHls];
    NSArray<PKMediaSource*>* sources = [[NSArray alloc] initWithObjects:source, nil];
    // setup media entry
    PKMediaEntry *mediaEntry = [[PKMediaEntry alloc] init:entryId sources:sources duration:-1];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// Standard override.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
