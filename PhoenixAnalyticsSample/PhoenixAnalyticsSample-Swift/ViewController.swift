//
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import PlayKitOTT

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

let ottServerUrl = "http://api-preprod.ott.kaltura.com/v4_5/api_v3"
let ottPartnerId: Int64 = 198
let ottAssetId = "259153"
let ottFileId = "804398"

class ViewController: UIViewController {
    var player: Player?
    var playheadTimer: Timer?
    var provider: PhoenixMediaProvider?
    
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        PhoenixAnonymousSession.get(baseUrl: ottServerUrl, partnerId: ottPartnerId) { (ks, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let ks = ks {
                // 1. Create plugin config
                let pluginConfig: PluginConfig = self.createPluginConfig(ks: ks)
                
                // 2. Load the player
                do {
                    self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
                    // 3. Register events if have ones.
                    // Event registeration must be after loading the player successfully to make sure events are added,
                    // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
                    self.addAnalyticsObservations()
                    
                    // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
                    self.preparePlayer(ks: ks)
                } catch let e {
                    // error loading the player
                    print("error:", e.localizedDescription)
                }
            }
        }
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
    func preparePlayer(ks: String) {
        // setup the player's view
        self.player?.view = self.playerContainer
        
        provider = PhoenixMediaProvider()
        provider?
            .set(baseUrl: ottServerUrl)
            .set(ks: ks)
            .set(type: .media)
            .set(assetId: ottAssetId)
            .set(fileIds: [ottFileId])
            .set(playbackContextType: .playback)

        provider?.loadMedia() { (entry, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let entry = entry {
                // create media config
                let mediaConfig = MediaConfig(mediaEntry: entry)
                
                // prepare the player
                self.player?.prepare(mediaConfig)
            }
        }
    }
    
/************************/
// MARK: - Analytics
/***********************/
    func createPluginConfig(ks: String) -> PluginConfig {
        let pluginConfigDict = [PhoenixAnalyticsPlugin.pluginName: self.createPhoenixAnalyticsPluginConfig(ks: ks)]
        
        return PluginConfig(config: pluginConfigDict)
    }
    
    func addAnalyticsObservations() {
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
    
    func createPhoenixAnalyticsPluginConfig(ks: String) -> PhoenixAnalyticsPluginConfig {
        return PhoenixAnalyticsPluginConfig(baseUrl: ottServerUrl,
                                            timerInterval: 30,
                                            ks: ks,
                                            partnerId: Int(ottPartnerId))
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
