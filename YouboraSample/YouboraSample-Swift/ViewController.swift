//
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit

/*
 This sample will show you how to create a player with youbora plugin.
 The steps required:
 1. Create youbora plugin config.
 2. Load player with plugin config.
 3. Register events.
 4. Prepare Player.
 */

class ViewController: UIViewController {
    var player: Player?
    var playheadTimer: Timer?
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        // 1. Create plugin config
        let pluginConfig: PluginConfig = self.createPluginConfig()
        
        // 2. Load the player
        do {
            self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
            // 3. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            self.addYouboraObservations()
            
            // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            self.preparePlayer()
        } catch let e {
            // error loading the player
            print("error:", e.localizedDescription)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.view.frame = self.playerContainer.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func preparePlayer() {
        let contentURL = "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"
        
        // create media source and initialize a media entry with that source
        let entryId = "sintel"
        let source = MediaSource(entryId, contentUrl: URL(string: contentURL), drmData: nil, mediaFormat: .hls)
        // setup media entry
        let mediaEntry = MediaEntry(entryId, sources: [source], duration: -1)
        
        // create media config
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
        
        // prepare the player
        self.player!.prepare(mediaConfig)
        
        // setup the player's view
        self.playerContainer.addSubview(self.player!.view)
        self.player!.view.frame = self.playerContainer.bounds
    }
    
/************************/
// MARK: - Youbora
/***********************/
    func createPluginConfig() -> PluginConfig {
        let pluginConfigDict = [YouboraPlugin.pluginName: self.createYouboraPluginConfig()]
        
        return PluginConfig(config: pluginConfigDict)
    }
    
    func createYouboraPluginConfig() -> AnalyticsConfig {
        // account code is mandatory, make sure to put the correct one.
        let youboraPluginParams: [String: Any] = ["accountCode": "nicetest",
                                                   "httpSecure": true,
                                                   "parseHLS": true,
                                                   "media": [
                                                    "title": "Sintel",
                                                    "duration": 600
                                                    ],
                                                   "properties": [
                                                    "year": "2001",
                                                    "genre": "Fantasy",
                                                    "price": "free"
                                                    ],
                                                   "network": [
                                                    "ip": "1.2.3.4"
                                                    ],
                                                   "ads": [
                                                    "adsExpected": true,
                                                    "campaign": "Ad campaign name"
                                                    ],
                                                   "extraParams": [
                                                    "param1": "Extra param 1 value",
                                                    "param2": "Extra param 2 value"
                                                    ]
        ]
        
        return AnalyticsConfig(params: youboraPluginParams)
    }
    
    func addYouboraObservations() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [YouboraEvent.report]) { event in
            print("received youbora report event: \(String(describing: event.youboraMessage))")
        }
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
