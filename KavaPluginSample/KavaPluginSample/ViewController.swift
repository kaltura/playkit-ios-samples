//
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import PlayKitKava
import PlayKitOVP

/*
 This sample will show you how to create a player with basic functionality.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Register player events.
 3. Prepare Player.
 */

let ovpBaseUrl = "http://cdnapisec.kaltura.com"
let ovpPartnerId: Int64 = 1424501
let ovpEntryId = "1_djnefl4e"

class ViewController: UIViewController {
    var player: Player?
    var playheadTimer: Timer?
    var provider: OVPMediaProvider?
    
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        OVPWidgetSession.get(baseUrl: ovpBaseUrl, partnerId: ovpPartnerId) { (ks, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let ks = ks {
                // 1. Load the player
                do {
                    let kavaConfig = KavaPluginConfig.init(partnerId: Int(ovpPartnerId) , ks: ks, playbackContext: nil, referrer: nil, customVar1: nil, customVar2: nil, customVar3: nil)
                    kavaConfig.playbackType = KavaPluginConfig.PlaybackType.vod
                    let pluginConfig = PluginConfig(config: [KavaPlugin.pluginName: kavaConfig])
                    self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
                    // 2. Register events if have ones.
                    // Event registeration must be after loading the player successfully to make sure events are added,
                    // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
                    
                    // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
                    self.preparePlayer(ks: ks)
                } catch let e {
                    // error loading the player
                    print("error:", e.localizedDescription)
                }
            }
        }
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
        
        provider = OVPMediaProvider()
        provider?
            .set(baseUrl: ovpBaseUrl)
            .set(partnerId: ovpPartnerId)
            .set(ks: ks)
            .set(entryId: ovpEntryId)
        provider?.loadMedia { (mediaEntry, error) in
            if let me = mediaEntry, error == nil {
                // create media config
                let mediaConfig = MediaConfig(mediaEntry: me, startTime: 0.0)
                
                // prepare the player
                self.player!.prepare(mediaConfig)
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
