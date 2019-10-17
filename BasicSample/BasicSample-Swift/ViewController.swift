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
    var player: Player! // Created in viewDidLoad
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        // 1. Load the player
        player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        // 2. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        player.addObserver(self, event: PlayerEvent.playheadUpdate, block: { (event) in
            if let playerEvent = event as? PlayerEvent, let currentTime = playerEvent.currentTime {
                self.playheadSlider.value = Float(self.player.currentTime / self.player.duration)
                print(currentTime)
            }
        })
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
    
    @IBAction func replayTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.replay()
    }
}
