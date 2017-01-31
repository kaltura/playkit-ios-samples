//
//  ViewController.m
//  ObjCSample
//
//  Created by Eliza Sapir on 12/12/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

#import "ViewController.h"
#import "PlayKit-Swift.h"

@interface ViewController ()<AVPictureInPictureControllerDelegate, PlayerDelegate>
@property (nonatomic, strong) id<Player> kPlayer;
@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPlayer];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupPlayer {
    PlayerConfig *config = [PlayerConfig new];
    NSDictionary *src = @{@"id":@"123123",@"url": @"https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8"};
    
    NSArray *srcs = @[src];
    NSDictionary *entry = @{@"id":@"Trailer",@"sources": srcs};
    
    [config setWithMediaEntry:[[MediaEntry alloc] initWithJson:entry]];
    config.allowPlayerEngineExpose = NO;
    
    [PlayKitManager.sharedInstance registerPlugin:IMAPlugin.self];
    
    AdsConfig *adsConfig = [AdsConfig new];
    adsConfig.adTagUrl = @"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/3274935/preroll&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator=[timestamp]";
    [config setPlugins:@{IMAPlugin.pluginName:adsConfig}];
    
    self.kPlayer = [PlayKitManager.sharedInstance loadPlayerWithConfig:config];
    [self.kPlayer prepare:config];
    
    self.kPlayer.view.frame = CGRectMake(0, 0, self.playerContainer.frame.size.width,self.playerContainer.frame.size.height);
    
    [self.kPlayer addObserver:self events:@[PlayerEvent.playing, PlayerEvent.durationChanged, PlayerEvent.stateChanged] block:^(PKEvent * _Nonnull event) {
        if ([event isKindOfClass:PlayerEvent.playing]) {
            NSLog(@"playing %@", event);
        } else if ([event isKindOfClass:PlayerEvent.durationChanged]) {
            NSLog(@"duration: %@", event.duration);
        } else if ([event isKindOfClass:PlayerEvent.stateChanged]) {
            NSLog(@"old state: %ld", (long)event.oldState);
            NSLog(@"new state: %ld", (long)event.newState);
        } else {
            NSLog(@"event: %@", event);
        }
    }];
    
    self.kPlayer.delegate = self;
    [self.playerContainer addSubview:self.kPlayer.view];
//    [self.kPlayer play];
}

- (BOOL)playerShouldPlayAd:(id<Player>)player {
    return YES;
}

- (IBAction)playTapped:(id)sender {
    if(!self.kPlayer.isPlaying) {
        [self.kPlayer play];
    }
}

- (IBAction)pauseTapped:(id)sender {
    if(self.kPlayer.isPlaying) {
        [self.kPlayer pause];
    }
}


@end
