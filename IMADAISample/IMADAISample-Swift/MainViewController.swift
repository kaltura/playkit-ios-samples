//
//  MainViewController.swift
//  IMADAISample-Swift
//
//  Created by Nilit Danan on 2/24/19.
//  Copyright © 2019 Kaltura Inc. All rights reserved.
//

import UIKit
import AVKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var videos: [VideoData] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initVideos()
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {
            
        }
    }
    
    func initVideos() {
        
        videos.append(VideoData(title: "ovp_dai_hls",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "VOD - Tears of Steel",
                                assetKey: nil,
                                contentSourceId: "19463",
                                videoId: "tears-of-steel",
                                autoPlay: false,
                                startPosition: 0,
                                streamType: .vod))
        
        videos.append(VideoData(title: "ovp_dai_hls_autoPlay",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "VOD - Tears of Steel",
                                assetKey: nil,
                                contentSourceId: "19463",
                                videoId: "tears-of-steel",
                                autoPlay: true,
                                startPosition: 0,
                                streamType: .vod))
        
        videos.append(VideoData(title: "ovp_dai_hls2_autoPlay",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "VOD - Google I/O",
                                assetKey: nil,
                                contentSourceId: "19463",
                                videoId: "googleio-highlights",
                                autoPlay: true,
                                startPosition: 0,
                                streamType: .vod))
        
        videos.append(VideoData(title: "ovp_dai_hls_start_position_without_skip_preroll",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "VOD - Google I/O",
                                assetKey: nil,
                                contentSourceId: "19463",
                                videoId: "googleio-highlights",
                                autoPlay: true,
                                startPosition: 30,
                                streamType: .vod))
        
        videos.append(VideoData(title: "ovp_dai_hls_start_position_with_skip_preroll",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "VOD - Tears of Steel",
                                assetKey: nil,
                                contentSourceId: "19463",
                                videoId: "tears-of-steel",
                                autoPlay: true,
                                startPosition: 30,
                                streamType: .vod))
        
        videos.append(VideoData(title: "ovp_dai_live",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "Live Video - Big Buck Bunny",
                                assetKey: "sN_IYUG8STe1ZzhIIE_ksA",
                                contentSourceId: nil,
                                videoId: nil,
                                autoPlay: true,
                                startPosition: 0,
                                streamType: .live))
        
        videos.append(VideoData(title: "ovp_dai_error",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "BBB-widevine",
                                assetKey: nil,
                                contentSourceId: "9992474148",
                                videoId: "the-tears-of-steel",
                                autoPlay: true,
                                startPosition: 0,
                                streamType: .vod))
        
        videos.append(VideoData(title: "ovp_dai_error_start_position",
                                entryID: "1_djnefl4e",
                                baseURL: "https://cdnapisec.kaltura.com/",
                                ks: nil,
                                partnerID: 1424501,
                                assetTitle: "BBB-widevine",
                                assetKey: nil,
                                contentSourceId: "9992474148",
                                videoId: "the-tears-of-steel",
                                autoPlay: true,
                                startPosition: 20,
                                streamType: .vod))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let videoData = videos[indexPath.row]
                
                if let videoVC = segue.destination as? VideoViewController {
                    videoVC.videoData = videoData
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = videos[indexPath.row].title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

