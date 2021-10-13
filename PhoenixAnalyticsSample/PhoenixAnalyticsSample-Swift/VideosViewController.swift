//
//  VideosViewController.swift
//  PhoenixAnalyticsSample-Swift
//
//  Created by Nilit Danan on 7/17/19.
//  Copyright © 2019 Kaltura. All rights reserved.
//

import UIKit
import AVKit

class VideosViewController: UITableViewController {
    var videos: [VideoData] = []
    let cellIdentifier = "UITableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        createVideos()        
    }
    
    
    func createVideos() {
        // VOD
        
        videos.append(VideoData(partnerID: 3009,
                                serverURL: "https://rest-us.ott.kaltura.com/v4_5/api_v3/",
                                ks: nil,
                                assetId: "548576",
                                assetType: .media,
                                assetRefType: .unset,
                                assetPlaybackContextType: .playback,
                                formats: ["Mobile_Main"],
                                fileIds: nil,
                                streamerType: "applehttp",
                                urlType: "playmanifest",
                                networkProtocol: "http",
                                referrer: nil))
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideoView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let video = videos[indexPath.row]
                if let videoVC = segue.destination as? ViewController {
                    videoVC.video = video
                }
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        
        let video = videos[indexPath.row]
        let title = "\(video.partnerID)\t\(video.assetId)\n\(video.serverURL)"
        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showVideoView", sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
