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
    var video: VideoData?
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
        removeAnalyticsObservations()
        removePlayerEventObservations()
        player?.destroy()
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
        
        guard let video = video else {
            print("No video Data")
            return
        }
        
        // Create a session provider
        let sessionProvider = SimpleSessionProvider(serverURL: video.serverURL, partnerId: Int64(video.partnerID), ks: video.ks)
        
        // Create the media provider
        let phoenixMediaProvider = PhoenixMediaProvider()
        phoenixMediaProvider.set(assetId: video.assetId)
        phoenixMediaProvider.set(type: video.assetType)
        phoenixMediaProvider.set(refType: video.assetRefType)
        phoenixMediaProvider.set(playbackContextType: video.assetPlaybackContextType)
        phoenixMediaProvider.set(formats: video.formats)
        phoenixMediaProvider.set(fileIds: video.fileIds)
        phoenixMediaProvider.set(referrer: video.referrer)
        phoenixMediaProvider.set(sessionProvider: sessionProvider)
        
        if let networkProtocol = video.networkProtocol {
            phoenixMediaProvider.set(networkProtocol: networkProtocol)
        }
        
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
        
        player.addObserver(self, events: [OttEvent.concurrency]) { event in
            print("OttEvent.concurrency: \(String(describing: event.ottEventMessage))")
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
        
        player.removeObserver(self, events: [OttEvent.report, OttEvent.bookmarkError, OttEvent.concurrency])
    }
    
    func createPhoenixAnalyticsPluginConfig() -> PhoenixAnalyticsPluginConfig {
        // Must have a KS, otherwise the Analytics won't work.
        return PhoenixAnalyticsPluginConfig(baseUrl: "https://rest-eus1.ott.kaltura.com/restful_v4_8/api_v3/",
                                            timerInterval: 30,
                                            ks: "djJ8MTk4fCBNp58cv0U0E-JjH9TUGjGZsPtJ_uhtM1oEDfA4CHKRuw0G4UvWYvEfE5PcvN-dVFiFl0EssY9_F1477u-TtWahVnn44D0iJ0dEim8Hh2l87AUddFzEHvNuSK6D6tEAhcls1Ukx2cecwjE3bGh10-o=",
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
