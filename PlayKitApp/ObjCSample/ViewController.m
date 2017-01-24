//
//  ViewController.m
//  ObjCSample
//
//  Created by Eliza Sapir on 12/12/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

#import "ViewController.h"
#import "PlayKit-Swift.h"

@interface ViewController ()
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
    
    
    self.kPlayer = [PlayKitManager.sharedInstance loadPlayerWithConfig:config];
    self.kPlayer.view.frame = CGRectMake(0, 0, self.playerContainer.frame.size.width,self.playerContainer.frame.size.height);
    
    [self.kPlayer addObserver:self events:@[PlayerEvent_playing.self, PlayerEvent_pause.self, PlayerEvent_durationChanged.self, PlayerEvent_stateChanged.self] block:^(PKEvent * _Nonnull event) {
        if ([event isKindOfClass:PlayerEvent_playing.class]) {
            NSLog(@"playing %@", event);
        } else if ([event isKindOfClass:PlayerEvent_pause.class]) {
            NSLog(@"paused %@", event);
        } else if ([event isKindOfClass:PlayerEvent_durationChanged.class]) {
            NSLog(@"duration: %f", ((PlayerEvent_durationChanged*)event).duration);
        } else if ([event isKindOfClass:PlayerEvent_stateChanged.class]) {
            NSLog(@"---------> newState: %ld", (long)((PlayerEvent_stateChanged*)event).newState);
            NSLog(@"---------> oldState: %ld", (long)((PlayerEvent_stateChanged*)event).oldState);
        } else {
            NSLog(@"event: %@", event);
        }
    }];
    

    [self.playerContainer addSubview:self.kPlayer.view];
    [self.kPlayer play];
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
