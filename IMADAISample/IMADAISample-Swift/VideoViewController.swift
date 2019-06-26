//
//  VideoViewController.swift
//  IMADAISample-swift
//
//  Created by Nilit Danan on 2/24/2019.
//  Copyright © 2019 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit
import PlayKitYoubora
import PlayKit_IMA
import PlayKitProviders

class VideoViewController: UIViewController, PlayerDelegate {

    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var player: Player! // Created in viewDidLoad
    var mediaConfig: MediaConfig?
    var timer: Timer?
    var videoData: VideoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imaDAIConfig = IMADAIConfig()
        if let videoData = videoData {
            imaDAIConfig.assetTitle = videoData.assetTitle
            imaDAIConfig.assetKey = videoData.assetKey
            imaDAIConfig.contentSourceId = videoData.contentSourceId
            imaDAIConfig.videoId = videoData.videoId
            imaDAIConfig.streamType = videoData.streamType
            imaDAIConfig.alwaysStartWithPreroll = videoData.alwaysStartWithPreroll
        }

        imaDAIConfig.playerVersion = PlayKitManager.versionString
        
        let youboraConfig = AnalyticsConfig(params: ["accountCode": "kalturatest", YouboraPlugin.enableSmartAdsKey: true])
        let pluginConfig = PluginConfig(config: [IMADAIPlugin.pluginName: imaDAIConfig, YouboraPlugin.pluginName: youboraConfig])
        
        player = PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
        
        player.addObserver(self, events: [PlayerEvent.error, PlayerEvent.canPlay, PlayerEvent.playheadUpdate], block: { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case is PlayerEvent.Error:
                print("error: " + (event.error?.localizedDescription ?? ""))
            case is PlayerEvent.CanPlay:
                strongSelf.activityIndicator.stopAnimating()
            case is PlayerEvent.PlayheadUpdate:
                strongSelf.playheadUpdate()
            default:
                break
            }
            
        })
        
        player.view = playerContainer
        loadMedia()
    }

    override func viewWillDisappear(_ animated: Bool) {
        player.removeObserver(self, events: [PlayerEvent.error, PlayerEvent.canPlay])
        player.stop()
        super.viewWillDisappear(animated)
    }
    
    func loadMedia() {
        guard let videoData = videoData else { return }
        
        let sessionProvider = SimpleSessionProvider(serverURL: videoData.baseURL, partnerId: Int64(videoData.partnerID), ks: videoData.ks)
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        mediaProvider.entryId = videoData.entryID
        mediaProvider.loadMedia { (mediaEntry, error) in
            if let me = mediaEntry, error == nil {
                // create media config
                let mediaConfig = MediaConfig(mediaEntry: me, startTime: TimeInterval(videoData.startPosition))
                
                // prepare the player
                self.player.prepare(mediaConfig)
                
                self.playheadSlider.isEnabled = (me.mediaType != .live)
            } else {
                print("error: " + (error?.localizedDescription ?? ""))
                let alertController = UIAlertController(title: "An error has occurred",
                                                        message: "The media could not be loaded",
                                                        preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "try again", style: UIAlertAction.Style.cancel, handler: { (action) in
                    self.loadMedia()
                }))
                
                self.show(alertController, sender: self)
            }
        }
    }
    
    @objc func playheadUpdate() {
        playheadSlider.value = Float(player.currentTime / player.duration)
    }
    
    @IBAction func didSeek(_ sender: UISlider) {
        print("playhead value: \(sender.value)")
        
        let seekTime = player.duration * TimeInterval(sender.value)
        player.seek(to: seekTime)
    }
    
    @IBAction func didTapPlay(_ sender: UIButton) {
        if player.isPlaying == false {
            player.play()
        }
    }
    
    @IBAction func didTapPause(_ sender: UIButton) {
        if player.isPlaying == true {
            player.pause()
        }
    }
}
