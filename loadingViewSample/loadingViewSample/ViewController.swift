//
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import PlayKit_IMA

/*
 This sample will show you how to create a player with basic functionality including ads and manage loading view.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Register player events.
 3. Prepare Player.
 */

class ViewController: UIViewController, PlayerDelegate {
    var player: Player?
    var playheadTimer: Timer?
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false
        
        // 1. Load the player
        do {
            var plugins = [String : AnyObject]()
            let adsConfig = IMAConfig()
            adsConfig.set(adTagUrl: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator=")
            plugins[IMAPlugin.pluginName] = adsConfig
            let pluginConfig = PluginConfig(config: plugins)
            
            self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
            // 2. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            self.handleLoadingViewAppearance()
            self.player?.delegate = self
            // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            self.preparePlayer()
        } catch let e {
            // error loading the player
            print("error:", e.localizedDescription)
        }
    }
    
    func playerShouldPlayAd(_ player: Player) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/************************************************************/
// MARK: - Handle Loading View Appearance By Relevant Events
/************************************************************/
    func handleLoadingViewAppearance() {
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = self.playerContainer.center
        
        // Player Events
        self.player?.addObserver(self, event: PlayerEvent.play, block: { event in
            self.activityIndicator.startAnimating()
        })
        
        self.player?.addObserver(self, event: PlayerEvent.playing, block: { event in
            self.activityIndicator.stopAnimating()
        })
        
        self.player?.addObserver(self, event: PlayerEvent.stateChanged, block: { event in
            switch event.newState {
                case PlayerState.ready, PlayerState.error: self.activityIndicator.stopAnimating()
                case PlayerState.buffering: self.activityIndicator.startAnimating()
                default: break
            }
        })
        
        // IMA  Events
        player?.addObserver(self, events: [AdEvent.adLoaded, AdEvent.adStartedBuffering], block: { event in
            self.activityIndicator.startAnimating()
        })
        
        player?.addObserver(self, events: [AdEvent.adBreakReady, AdEvent.error], block: { event in
            self.activityIndicator.stopAnimating()
        })
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func preparePlayer() {
        let contentURL = "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"
        
        // create media source and initialize a media entry with that source
        let entryId = "sintel"
        let source = PKMediaSource(entryId, contentUrl: URL(string: contentURL), drmData: nil, mediaFormat: .hls)
        // setup media entry
        let mediaEntry = PKMediaEntry(entryId, sources: [source], duration: -1)
        
        // create media config
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
        
        // prepare the player
        self.player!.prepare(mediaConfig)
        
        // setup the player's view
        self.player?.view = self.playerContainer
        self.playerContainer.bringSubview(toFront: self.activityIndicator)
    }
    
/************************/
// MARK: - Actions
/***********************/
    
    @IBAction func playTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        if !(player.isPlaying) {
            self.playheadTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
                self.playheadSlider.value = Float(player.currentTime / player.duration)
            })
            
            player.play()
        }
    }
    
    @IBAction func pauseTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        self.playheadTimer?.invalidate()
        self.playheadTimer = nil
        player.pause()
    }
    
    @IBAction func playheadValueChanged(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        let slider = sender as! UISlider
        
        print("playhead value:", slider.value)
        player.currentTime = player.duration * Double(slider.value)
    }
}
