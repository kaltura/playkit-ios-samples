//
//  VideosViewController.m
//  PhoenixAnalyticsSample
//
//  Created by Nilit Danan on 7/17/19.
//  Copyright © 2019 Kaltura. All rights reserved.
//

#import "VideosViewController.h"
#import "VideoData.h"
#import "ViewController.h"

@interface VideosViewController ()

@property (strong, nonatomic) NSArray <VideoData*> *videos;

@end

@implementation VideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createVideos];
}

- (void)createVideos {
    VideoData *v1 = [[VideoData alloc] initWithPartnerID:3009
                                                 serverURL:@"https://rest-us.ott.kaltura.com/v4_5/api_v3/"
                                                      ks:nil
                                                 assetId:@"548576"
                                                 networkProtocol:@"http"
                                                 formats:@[@"Mobile_Main"] ];
    
    self.videos = @[v1];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showVideoView"])
    {
        // Get reference to the destination view controller
        ViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        long index = 0;
        if (self.tableView.indexPathForSelectedRow != nil) {
            index = self.tableView.indexPathForSelectedRow.row;
        }
        VideoData *video = [self.videos objectAtIndex:index];
        [vc setVideoData:video];
    }
}

//MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    VideoData *video = self.videos[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%ld\t%@\n%@", (long)video.partnerID, video.assetId, video.serverURL];
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self performSegueWithIdentifier:@"showVideoView" sender:[tableView cellForRowAtIndexPath:indexPath]];
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}

@end

