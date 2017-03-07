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
    [self startBasicOVPPlayer];
//    [self startPlayerWithGivenSource];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startPlayerWithMediaConfig:(MediaConfig*)mediaConfig pluginConfig:(PluginConfig*)pluginConfig {
    NSError* error;
    self.kPlayer = [PlayKitManager.sharedInstance loadPlayerWithPluginConfig:pluginConfig error:&error];
    
    // prepare the player with media entry to start the plugin and buffering the media.
    [self.kPlayer prepare:mediaConfig];
    
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
    
    [self.kPlayer addObserver:self events:@[PlayerEvent.error] block:^(PKEvent * _Nonnull event) {
        NSError *error = event.error;
        if (error && error.domain == PKErrorDomain.Player && error.code == 7000) {
            // handle error
        }
    }];
    
    self.kPlayer.delegate = self;
    [self.playerContainer addSubview:self.kPlayer.view];
}

-(void)startBasicOVPPlayer {
    SimpleOVPSessionProvider* sessionProvider = [[SimpleOVPSessionProvider alloc] initWithServerURL:@"https://cdnapisec.kaltura.com" partnerId:2215841 ks:nil];
    OVPMediaProvider* mediaProvider = [[OVPMediaProvider alloc] init:sessionProvider];
    mediaProvider.entryId = @"1_vl96wf1o";
    [mediaProvider loadMediaWithCallback:^(MediaEntry * _Nullable mediaEntry, NSError * _Nullable error) {
        [self startPlayerWithMediaConfig:[[MediaConfig alloc] initWithMediaEntry:mediaEntry startTime:0] pluginConfig:nil];
    }];
}

- (void)startPlayerWithGivenSource {
    
    NSDictionary *src = @{@"id":@"123123",@"url": @"https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8"};
    
    NSArray *srcs = @[src];
    NSDictionary *entry = @{@"id":@"Trailer",@"sources": srcs};
    MediaConfig *mediaConfig = [MediaConfig configWithMediaEntry:[[MediaEntry alloc] initWithJson:entry]];
    
    // register the plugin
    [PlayKitManager.sharedInstance registerPlugin:IMAPlugin.self];
    
    // ads config for the ima plugin
    AdsConfig *adsConfig = [AdsConfig new];
    adsConfig.adTagUrl = @"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpreonly&cmsid=496&vid=short_onecue&correlator=";
    
    // create plugin config with the adsConfig and load the player with it.
    PluginConfig *pluginConfig = [[PluginConfig alloc] initWithConfig:@{IMAPlugin.pluginName:adsConfig}];
    
    [self startPlayerWithMediaConfig:mediaConfig pluginConfig:pluginConfig];

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
