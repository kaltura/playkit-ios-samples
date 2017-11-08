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
        do {
            self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: nil)
            // 2. Register events
            // Register Player Events
            // >Note: Make sure to register befor `prepare` is called
            //        Otherwise you will miss events
            self.registerPlayerEvents()
            
            // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            self.preparePlayer()
        } catch let e {
            // error loading the player
            print("error:", e.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func preparePlayer() {
        // setup the player's view
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
    
/******************************/
// MARK: - Events Registration
/*****************************/
    
    func registerPlayerEvents() {
        self.registerPlayEvent()
    }
    
    // Handle basic event (Play, Pause, CanPlay ..)
    func registerPlayEvent() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [PlayerEvent.playing]) { event in
            if type(of: event) == PlayerEvent.playing {
                // handle playing event
                print("Playing Event")
            }
        }
    }
    
    // Handle Duration Changes
    func registerDurationChangedEvent() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [PlayerEvent.durationChanged]) { event in
            if type(of: event) == PlayerEvent.durationChanged {
                if let duration = event.duration {
                    print("Duration Changed Event: ", duration.doubleValue)
                }
            }
        }
    }
    
    // Handle State Changes
    func registerPlayerEventStateChangedEvent() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [PlayerEvent.stateChanged]) { event in
            if type(of: event) == PlayerEvent.stateChanged {
                let newState = event.newState
                let oldState = event.oldState
                
                print("State Chnaged Event:: oldState: ", oldState, "newState:", newState)
            }
        }
    }
    
    // Handle Player Errors
    func registerErrorEvent() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [PlayerEvent.error]) { event in
            if let error = event.error, error.code == PKErrorCode.assetNotPlayable {
                // handle error
            }
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
