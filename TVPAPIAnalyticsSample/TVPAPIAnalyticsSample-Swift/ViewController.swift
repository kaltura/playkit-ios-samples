//
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit

/*********************************/
// Plugin registration should be done in App Delegate!!!
// Don't forget to add it in your project.
// Look at `AppDelegate` to see the registration.
/*********************************/

/*
 This sample will show you how to create a player with kaltura live stats plugin.
 The steps required:
 1. Create plugin config.
 2. Load player with plugin config.
 3. Register player events.
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
            self.addKalturaLiveStatsObservations()
            
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // remove observers
        self.removeAnalyticsObservations()
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
// MARK: - Analytics
/***********************/
    func createPluginConfig() -> PluginConfig {
        let pluginConfigDict = [PhoenixAnalyticsPlugin.pluginName: self.createKalturaStatsPluginConfig()]
        
        return PluginConfig(config: pluginConfigDict)
    }
    
    func addKalturaLiveStatsObservations() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [OttEvent.report]) { event in
            print("received stats event(buffer time): \(String(describing: event.ottEventMessage))")
        }
    }
    
    func removeAnalyticsObservations() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.removeObserver(self, events: [OttEvent.report])
    }
    
    func createKalturaStatsPluginConfig() -> AnalyticsConfig {
        let tvpapiPluginParams: [String : Any] = ["fileId": "",
                                                    "baseUrl": "",
                                                     "timerInterval": 30,
                                                     "initObj":
                                                        [
                                                            "Token": "",
                                                            "SiteGuid": "",
                                                            "ApiUser": "",
                                                            "DomainID": "",
                                                            "UDID": "",
                                                            "ApiPass": "",
                                                            "Locale": [
                                                                "LocaleUserState": "",
                                                                "LocaleCountry": "",
                                                                "LocaleDevice": "",
                                                                "LocaleLanguage": ""
                                                            ],
                                                            "Platform": ""
                                                        ]
        ]
        
        return AnalyticsConfig(params: tvpapiPluginParams)
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
