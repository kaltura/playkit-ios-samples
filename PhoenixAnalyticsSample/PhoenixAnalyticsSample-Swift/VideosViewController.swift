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
        
//        videos.append(VideoData(partnerID: 3009,
//                                serverURL: "https://rest-us.ott.kaltura.com/v4_5/api_v3/",
//                                ks: nil,
//                                assetId: "548576",
//                                epgId: "gilad",
//                                assetType: .media,
//                                assetRefType: .unset,
//                                assetPlaybackContextType: .playback,
//                                formats: ["Mobile_Main"],
//                                fileIds: nil,
//                                networkProtocol: "http",
//                                referrer: nil))
        
        videos.append(VideoData(partnerID: 3200,
                                serverURL: "https://api.frp1.ott.kaltura.com/api_v3",
                                ks:"djJ8MzIwMHyKjzl58GlR0B_q2Vcr4-QYBs0X8dk9sDJrt-OqP5nDR9hn4tEpD8n69AFEZ38IbbXumSkoDXBEaz7SPQ6FZxcpTytthNY6hwzHZhJUiE0NGS4Rl2y_AQb6Kx22bJBJ-DGOPUhA20NhLDaxU07fReFfxaayH4i9CF1DKLyNpPFNejiNqTlp1sJsWGSJwW1feaNaUeoiQ3cYF8usNS-DmafAQu25Vm7QRdrkZj3esKF1V-xKFV83SyRTG2-pGyLeJHR6j3IEKPAAs0X1LVlvnO91mh5EtFIZsjQFF-61osxJfVKhnEoSty_FC9RRq8KNnkw=",
                                assetId: "109791863",
                                epgId: nil,
                                assetType: .epg,
                                assetRefType: .epgInternal,
                                assetPlaybackContextType: .catchup,
                                formats: ["Mobile_Main"],
                                fileIds: nil,
                                networkProtocol: "https",
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
