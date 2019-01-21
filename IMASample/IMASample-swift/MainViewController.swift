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
        let dfpThumbnail = UIImage(named: "dfp.png")
        let androidThumbnail = UIImage(named: "android.png")
        let bunnyThumbnail = UIImage(named: "bunny.png")
        let bipThumbnail = UIImage(named: "bip.png")
        
        videos.append(Video(title: "Pre-roll", thumbnail: dfpThumbnail!, tag: kPrerollTag))
        videos.append(Video(title: "Skippable Pre-roll", thumbnail: androidThumbnail!, tag: kSkippableTag))
        videos.append(Video(title: "Post-roll", thumbnail: bunnyThumbnail!, tag: kPostrollTag))
        videos.append(Video(title: "AdRules", thumbnail: bipThumbnail!, tag: kAdRulesTag))
        videos.append(Video(title: "AdRules Pods", thumbnail: dfpThumbnail!, tag: kAdRulesPodsTag))
        videos.append(Video(title: "VMAP Pods", thumbnail: androidThumbnail!, tag: kVMAPPodsTag))
        videos.append(Video(title: "Wrapper", thumbnail: bunnyThumbnail!, tag: kWrapperTag))
        videos.append(Video(title: "AdSense", thumbnail: bipThumbnail!, tag: kAdSenseTag))
        videos.append(Video(title: "Custom", thumbnail: androidThumbnail!, tag: "custom"))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let video = videos[indexPath.row]
                
                if let videoVC = segue.destination as? VideoViewController {
                    videoVC.video = video
                    
                    let adsConfig = IMAConfig()
                    adsConfig.adTagUrl = video.tag
                    adsConfig.playerVersion = PlayKitManager.versionString
                    
                    var url: URL?
                    if let player = player {
                        url = URL.init(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8")
                        player.updatePluginConfig(pluginName: "IMAPlugin", config: adsConfig)
                    } else {
                        url = URL.init(string: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8")

                        let youboraConfig = AnalyticsConfig(params: ["accountCode": "kalturatest", YouboraPlugin.enableSmartAdsKey: true])
                        let pluginConfig = PluginConfig(config: [IMAPlugin.pluginName: adsConfig, YouboraPlugin.pluginName: youboraConfig])
                        
                        player = PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
                        player?.delegate = self
                        
                        player?.addObserver(self, event: PlayerEvent.error, block: { (event) in
                            print("error: " + (event.error?.localizedDescription ?? ""))
                        })
                    }

                    let source = PKMediaSource("Kaltura Media", contentUrl: url, mimeType: nil, drmData: nil, mediaFormat: PKMediaSource.MediaFormat.hls)
                    let mediaEntry = PKMediaEntry("Kaltura Media", sources: [source], duration: -1)
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

