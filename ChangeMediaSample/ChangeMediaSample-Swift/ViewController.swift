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
 This sample will show you how to create a player with basic functionality.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Register player events.
 3. Prepare Player.
 */

class ViewController: UIViewController {
    var player: Player?
    var playheadTimer: Timer?
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        // 1. Load the player
        self.player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        // 2. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        
        // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        self.preparePlayer()
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
        // setup the view
        self.player?.view = self.playerContainer
        
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
    }
   
    // creates default media config for this sample, in real app media config will need to be different for each media entry.
    func getDefaultMediaConfig() -> MediaConfig {
        let contentURL = URL(string: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8")
        let entryId = "sintel"
        let mediaEntry = self.createMediaEntry(id: entryId, contentURL: contentURL!)
        
        // create media config
        return MediaConfig(mediaEntry: mediaEntry, startTime: 0.0)
    }
    
    func createMediaEntry(id: String, contentURL: URL) -> PKMediaEntry {
        // create media source and initialize a media entry with that source
        let source = PKMediaSource(id, contentUrl: contentURL, mimeType: nil, drmData: nil, mediaFormat: .hls)
        let sources: Array = [source]
        
        // setup media entry
        return PKMediaEntry(id, sources: sources, duration: -1)
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
    
    @IBAction func changeMediaTouched(_ sender: Any) {
        
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        // create mediaEntry for change media, you can use differrent params here.
        let contentURL = URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8")
        let entryId = "KalturaMedia"
        let mediaEntry = self.createMediaEntry(id: entryId, contentURL: contentURL!)
        // Resets The Player And Prepares for Change Media
        player.stop() // 1. Stop Player
        // Create new Media Config
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry, startTime: 0.0)
        // Call Prepare
        player.prepare(mediaConfig) // 2. Call Prepare with new MediaConfig
        
        // After preparing if you wish to play make sure to wait `canPlay` event.
        player.addObserver(self, events: [PlayerEvent.canPlay]) { event in
            player.play()
        }
    }
    
    // ** Not Recommended **
    // Change Media by Remove & Recreation
    func changeMediaByRecreation() {
        // to change the media we remove player view from container, destroy the player and create a new instance.
        self.player?.view?.removeFromSuperview()
        self.player?.destroy()
        self.player = nil
        
        // here you have to recreate the player
    }
}
