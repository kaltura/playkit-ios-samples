//
//  ViewController.h
//  BasicSample
//
//  Created by Gal Orlanczyk on 15/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayKit-Swift.h"
#import "Video.h"

@interface VideoViewController : UIViewController

@property (strong, nonatomic) id<Player> player;
@property(nonatomic, strong) Video *video;
@end

