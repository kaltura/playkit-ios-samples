//
//  ViewController.h
//  BasicSample
//
//  Created by Gal Orlanczyk on 15/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

