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

private class Logger {
    private static var previousEventDate: Date?
    
    static func log(eventName: String) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        let strDate = formatter.string(from: date)
        
        let intervalSincePastEvent = previousEventDate.map { date.timeIntervalSince($0) }
        previousEventDate = date
        
        print("CUSTOM LOG: \(eventName) | date: \(strDate) | time since previous event: \(intervalSincePastEvent ?? 0)")
    }
}

class ViewController: UIViewController, PlayerDelegate {
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
        do {
            Logger.log(eventName: "start creating player")
            self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
            Logger.log(eventName: "finish creating player")
            
            self.player?.delegate = self
            // 3. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            self.addObservers()
            self.addKalturaLiveStatsObservations()
            
            // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            self.preparePlayer()
        } catch let e {
            // Error loading the player
            print("error:", e.localizedDescription)
        }
    }
    
    deinit {
        player?.removeObserver(self, events: PlayerEvent.allEventTypes)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove observers
        self.removeAnalyticsObservations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func addObservers() {
//        player?.addObserver(self, event: PlayerEvent.canPlay, block: { (event) in
//            Logger.log(eventName: "finish preparing player")
//        })
        
        player?.addObserver(self, events: PlayerEvent.allEventTypes, block: { (event) in
            switch event {
            case is PlayerEvent.CanPlay:
                Logger.log(eventName: "CanPlay")
            case is PlayerEvent.DurationChanged:
                Logger.log(eventName: "DurationChanged")
            case is PlayerEvent.Ended:
                Logger.log(eventName: "Ended")
            case is PlayerEvent.LoadedMetadata:
                Logger.log(eventName: "LoadedMetadata")
            case is PlayerEvent.Play:
                Logger.log(eventName: "Play")
            case is PlayerEvent.Pause:
                Logger.log(eventName: "Pause")
            case is PlayerEvent.Playing:
                Logger.log(eventName: "Playing")
            case is PlayerEvent.Seeking:
                Logger.log(eventName: "Seeking")
            case is PlayerEvent.Seeked:
                Logger.log(eventName: "Seeked")
            case is PlayerEvent.StateChanged:
                Logger.log(eventName: "StateChanged")
            case is PlayerEvent.PlaybackInfo:
                Logger.log(eventName: "PlaybackInfo")
            case is PlayerEvent.TracksAvailable:
                Logger.log(eventName: "TracksAvailable")
            case is PlayerEvent.TextTrackChanged:
                Logger.log(eventName: "TextTrackChanged")
            case is PlayerEvent.AudioTrackChanged:
                Logger.log(eventName: "AudioTrackChanged")
            case is PlayerEvent.VideoTrackChanged:
                Logger.log(eventName: "VideoTrackChanged")
            case is PlayerEvent.Error:
                Logger.log(eventName: "Error")
            default:
                Logger.log(eventName: "Not PlayerEvent...")
            }
        })
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func preparePlayer() {
        // Setup the player's view
        self.player?.view = self.playerContainer
        
        Logger.log(eventName: "start media provider")
        // Create a session provider
        let sessionProvider = SimpleSessionProvider(serverURL: "http://api-preprod.ott.kaltura.com/v4_5/api_v3/",
                                 partnerId: 198,
                                 ks: nil)
//        let sessionProvider = SimpleSessionProvider(serverURL: "https://rest-us.ott.kaltura.com/v4_8_2/api_v3",
//                                                    partnerId: 481,
//                                                    ks: "djJ8NDgxfKKE4KrHeV-ymp6oarXfSqQ0hejOT9WHCIMHmFLxK_-p5M67PHyEnqB36Ficric05dxJQPZ4y_S8Xz0ZgSmP46-n78qqS67n4xEDvcGUAyRu7temBdtZSV5cxhpFnYpjlUvmtxqnH5DWugYJVRa6HTdtAI-6TjyZWx8NWYW67A5TOw99_4-WnPMo9aCZGBJteQ==")
        
        // Create the media provider
        let phoenixMediaProvider = PhoenixMediaProvider()
        phoenixMediaProvider.set(assetId: "259153")
//        phoenixMediaProvider.set(assetId: "1095417")
        phoenixMediaProvider.set(type: AssetType.media)
        phoenixMediaProvider.set(formats: ["Mobile_Devices_Main_SD"])
//        phoenixMediaProvider.set(fileIds: ["2861439"])
        phoenixMediaProvider.set(playbackContextType: PlaybackContextType.playback)
        phoenixMediaProvider.set(sessionProvider: sessionProvider)
        
        phoenixMediaProvider.loadMedia { (pkMediaEntry, error) in
            Logger.log(eventName: "media provider ready")
            guard let mediaEntry = pkMediaEntry else { return }
            
            // Create media config
            let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
            
            Logger.log(eventName: "start preparing player")
            // Prepare the player
            self.player?.prepare(mediaConfig)
        }
    }
    
/************************/
// MARK: - Analytics
/***********************/
    func createPluginConfig() -> PluginConfig {
        let pluginConfigDict = [PhoenixAnalyticsPlugin.pluginName: self.createPhoenixAnalyticsPluginConfig(),
                                IMAPlugin.pluginName: self.createIMAPluginConfig()]
        
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
    
    func createPhoenixAnalyticsPluginConfig() -> PhoenixAnalyticsPluginConfig {
        return PhoenixAnalyticsPluginConfig(baseUrl: "https://rest-eus1.ott.kaltura.com/restful_v4_8/api_v3/",
                                            timerInterval: 30,
                                            ks: "",
                                            partnerId: 0)
    }
    
    func createIMAPluginConfig() -> IMAConfig {
        
        let imaConfig = IMAConfig()
        // Pre
//        imaConfig.adTagUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
        
        // Post
//        imaConfig.adTagUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&correlator="
        
        // Pre, mid*3, post
        imaConfig.adTagUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="
        
        // Pre, mid*5 every 10 min, post
        imaConfig.adTagUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostlongpod&cmsid=496&vid=short_tencue&correlator="
        
        return imaConfig
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
    
    @IBAction func stopTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        self.playheadTimer?.invalidate()
        self.playheadTimer = nil
        player.stop()
    }
    
    func createMediaEntry(id: String, contentURL: URL) -> PKMediaEntry {
        // create media source and initialize a media entry with that source
        let source = PKMediaSource(id, contentUrl: contentURL, mimeType: nil, drmData: nil, mediaFormat: .hls)
        let sources: Array = [source]
        
        // setup media entry
        return PKMediaEntry(id, sources: sources, duration: -1)
    }
    
    @IBAction func changeMediaTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        // Resets The Player And Prepares for Change Media
        player.stop() // 1. Stop Player
        
        // create mediaEntry for change media, you can use differrent params here.
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
    
    // MARK: - PlayerDelegate
    
    func playerShouldPlayAd(_ player: Player) -> Bool {
        return true
    }
}
