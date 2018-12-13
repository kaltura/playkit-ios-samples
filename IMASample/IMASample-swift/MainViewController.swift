//
//  ViewController.swift
//  IMASample-swift
//
//  Created by Vadik on 07/11/2017.
//  Copyright © 2017 kaltura. All rights reserved.
//

import UIKit
import AVKit
import PlayKit
import PlayKit_IMA
import PlayKitYoubora

class MainViewController: UIViewController, PlayerDelegate, UITableViewDelegate, UITableViewDataSource {

    var videos: [Video] = []
    var player: Player?
    let adsConfig = IMAConfig()
    var pluginConfig: PluginConfig?
    
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
        
        let youboraConfig = AnalyticsConfig(params: ["accountCode": "kalturatest"])
//        let youboraConfig = self.createYouboraPluginConfig()
        pluginConfig = PluginConfig(config: [IMAPlugin.pluginName: adsConfig, YouboraPlugin.pluginName: youboraConfig])
    }
    
    func initVideos() {
        let dfpThumbnail = UIImage(named: "dfp.png")
        let androidThumbnail = UIImage(named: "android.png")
        let bunnyThumbnail = UIImage(named: "bunny.png")
        let bipThumbnail = UIImage(named: "bip.png")
        
        let video1URLString = "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"
        let video2URLString = "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8"
        
        videos.append(Video(title: "Pre-roll - Live",
                            thumbnail: dfpThumbnail!,
                            tag: kPrerollTag,
                            urlString: "https://qa-apache-php7.dev.kaltura.com/p/1091/sp/1091/playManifest/entryId/0_fdb6sbgm/deliveryProfileId/1033/protocol/https/format/applehttp/a.m3u8",
                            type: .live))
        videos.append(Video(title: "Pre-roll", thumbnail: dfpThumbnail!, tag: kPrerollTag, urlString: video1URLString))
        videos.append(Video(title: "Skippable Pre-roll", thumbnail: androidThumbnail!, tag: kSkippableTag, urlString: video1URLString))
        videos.append(Video(title: "Post-roll", thumbnail: bunnyThumbnail!, tag: kPostrollTag, urlString: video1URLString))
        videos.append(Video(title: "AdRules", thumbnail: bipThumbnail!, tag: kAdRulesTag, urlString: video1URLString))
        videos.append(Video(title: "AdRules Pods", thumbnail: dfpThumbnail!, tag: kAdRulesPodsTag, urlString: video1URLString))
        videos.append(Video(title: "VMAP Pods", thumbnail: androidThumbnail!, tag: kVMAPPodsTag, urlString: video2URLString))
        videos.append(Video(title: "Wrapper", thumbnail: bunnyThumbnail!, tag: kWrapperTag, urlString: video2URLString))
        videos.append(Video(title: "AdSense", thumbnail: bipThumbnail!, tag: kAdSenseTag, urlString: video2URLString))
        videos.append(Video(title: "Custom", thumbnail: androidThumbnail!, tag: "custom", urlString: video2URLString))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let video = videos[indexPath.row]
                
                if let videoVC = segue.destination as? VideoViewController {
                    videoVC.video = video
                    
                    adsConfig.adTagUrl = video.tag
                    adsConfig.playerVersion = PlayKitManager.versionString
                    
                    var url: URL?
                    if let player = player {
                        url = URL(string: video.urlString)
                        player.updatePluginConfig(pluginName: "IMAPlugin", config: adsConfig)
                    } else {
                        url = URL(string: video.urlString)
                        
                        do {
                            player = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
                        } catch let e {
                            print("error:", e.localizedDescription)
                        }

                        player?.delegate = self
                        
                        player?.addObserver(self, event: PlayerEvent.error, block: { (event) in
                            print("error: " + (event.error?.localizedDescription ?? ""))
                        })
                    }

                    let source = PKMediaSource("Kaltura Media", contentUrl: url, mimeType: nil, drmData: nil, mediaFormat: PKMediaSource.MediaFormat.hls)
                    let mediaEntry = PKMediaEntry("Kaltura Media", sources: [source], duration: -1)
                    mediaEntry.mediaType = video.type
                    let mediaConfig = MediaConfig(mediaEntry: mediaEntry, startTime: 0)
                    
                    videoVC.player = player
                    videoVC.mediaConfig = mediaConfig
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoTableViewCell
        cell.populate(with: videos[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - PlayerDelegate
    
    func playerShouldPlayAd(_ player: Player) -> Bool {
        return true
    }
}
