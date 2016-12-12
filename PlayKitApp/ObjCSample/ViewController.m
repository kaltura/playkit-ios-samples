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
    NSDictionary *src = @{@"id":@"123123",@"url": @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"};
    
    NSArray *srcs = @[src];
    NSDictionary *entry = @{@"id":@"Trailer",@"sources": srcs};
    
    [config setWithMediaEntry:[[MediaEntry alloc] initWithJson:entry]];
    
    
    self.kPlayer = [PlayKitManager.sharedInstance loadPlayerWithConfig:config];
    self.kPlayer.view.frame = CGRectMake(0, 0, self.playerContainer.frame.size.width,self.playerContainer.frame.size.height);
    
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
