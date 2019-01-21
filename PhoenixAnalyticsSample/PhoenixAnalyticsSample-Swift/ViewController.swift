//
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import PlayKitProviders

// VOD
//fileprivate let SERVER_BASE_URL = "http://api-preprod.ott.kaltura.com/v4_5/api_v3"
//fileprivate let PARTNER_ID = 198
//fileprivate let ENTRY_ID = "259153"
//fileprivate let ASSET_TYPE = AssetType.media
//fileprivate let PLAYBACK_CONTEXT_TYPE = PlaybackContextType.playback

// Live
fileprivate let SERVER_BASE_URL = "https://api-preprod.ott.kaltura.com/v5_1_0/api_v3"
fileprivate let PARTNER_ID = 198
fileprivate let ENTRY_ID = "277170"
fileprivate let ASSET_TYPE = AssetType.media
fileprivate let PLAYBACK_CONTEXT_TYPE = PlaybackContextType.playback

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
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        // 1. Create plugin config
        let pluginConfig: PluginConfig = self.createPluginConfig()
        
        // 2. Load the player
        self.player =  PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
        // 3. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        self.addKalturaLiveStatsObservations()
        self.addPlayerEventObservations()
        
        // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        self.preparePlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove observers
        self.removeAnalyticsObservations()
        self.removePlayerEventObservations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func preparePlayer() {
        // Setup the player's view
        self.player?.view = self.playerContainer
        
        // Create a session provider
        let sessionProvider = SimpleSessionProvider(serverURL: SERVER_BASE_URL, partnerId: Int64(PARTNER_ID), ks: nil)
        
        // Create the media provider
        let phoenixMediaProvider = PhoenixMediaProvider()
        phoenixMediaProvider.set(assetId: ENTRY_ID)
        phoenixMediaProvider.set(type: ASSET_TYPE)
        phoenixMediaProvider.set(formats: ["Mobile_Devices_Main_SD"])
        phoenixMediaProvider.set(playbackContextType: PLAYBACK_CONTEXT_TYPE)
        phoenixMediaProvider.set(sessionProvider: sessionProvider)
        
        phoenixMediaProvider.loadMedia { (pkMediaEntry, error) in
            guard let mediaEntry = pkMediaEntry else { return }
            
            // Create media config
            let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
            
            // Prepare the player
            self.player?.prepare(mediaConfig)
            
            self.playheadSlider.isEnabled = mediaEntry.mediaType != .live
        }
    }
    
    func addPlayerEventObservations() {
        // Observe PlayheadUpdate to update UI
        self.player?.addObserver(self, events: [PlayerEvent.playheadUpdate], block: { (event) in
            guard let player = self.player else { return }
            switch event {
            case is PlayerEvent.PlayheadUpdate:
                if let playerEvent = event as? PlayerEvent, let currentTime = playerEvent.currentTime {
                    self.playheadSlider.value = Float(currentTime.doubleValue / player.duration)
                }
            default:
                break
            }
        })
    }
    
    func removePlayerEventObservations() {
        self.player?.removeObserver(self, events: [PlayerEvent.playheadUpdate])
    }
    
/************************/
// MARK: - Analytics
/***********************/
    func createPluginConfig() -> PluginConfig {
        let pluginConfigDict = [PhoenixAnalyticsPlugin.pluginName: self.createPhoenixAnalyticsPluginConfig()]
        
        return PluginConfig(config: pluginConfigDict)
    }
    
    func addKalturaLiveStatsObservations() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [OttEvent.report]) { event in
            print("received stats event (buffer time): \(String(describing: event.ottEventMessage))")
        }
        
        player.addObserver(self, events: [OttEvent.bookmarkError]) { event in
            print("Received bookmark error: \(String(describing: event.ottEventMessage))")
        }
    }
    
    func removeAnalyticsObservations() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.removeObserver(self, events: [OttEvent.report, OttEvent.bookmarkError])
    }
    
    func createPhoenixAnalyticsPluginConfig() -> PhoenixAnalyticsPluginConfig {
        return PhoenixAnalyticsPluginConfig(baseUrl: "https://rest-eus1.ott.kaltura.com/restful_v4_8/api_v3/",
                                            timerInterval: 30,
                                            ks: "",
                                            partnerId: 0)
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
    
    func createMediaEntry(id: String, contentURL: URL) -> PKMediaEntry {
        // Create media source and initialize a media entry with that source
        let source = PKMediaSource(id, contentUrl: contentURL, mimeType: nil, drmData: nil, mediaFormat: .hls)
        let sources: Array = [source]
        
        // Setup media entry
        return PKMediaEntry(id, sources: sources, duration: -1)
    }
    
    @IBAction func changeMediaTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        playheadSlider.value = 0
        
        // Resets The Player And Prepares for Change Media
        player.stop() // 1. Stop Player
        
        // Create mediaEntry for change media, you can use differrent params here.
        let contentURL = URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8")
        let entryId = "KalturaMedia"
        let mediaEntry = self.createMediaEntry(id: entryId, contentURL: contentURL!)
        
        // Create new Media Config
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry, startTime: 0.0)
        // Call Prepare
        player.prepare(mediaConfig) // 2. Call Prepare with new MediaConfig
        
        // After preparing if you wish to play make sure to wait `canPlay` event.
        player.addObserver(self, events: [PlayerEvent.canPlay]) { event in
            player.play()
        }
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
