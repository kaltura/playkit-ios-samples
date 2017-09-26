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

class ViewController: UIViewController, PlayerDelegate {
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
            self.player?.delegate = self
            // 2. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            
//            self.player?.addObserver(self, events: [PlayerEvent.canPlay]) { event in
//                self.player?.play()
//            }
            
            // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            self.preparePlayer()
            
//            self.player?.play()
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
        
        let serverURL = "http://cdnapi.kaltura.com"
        let partnerId = 1424501
        
        let sessionProvider = SimpleOVPSessionProvider(serverURL:serverURL, partnerId: Int64(partnerId), ks: nil)
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        mediaProvider.entryId = "0_a54foq3g"
        mediaProvider.loadMedia { (mediaEntry, error) in
            if(!(error != nil)) {
                // create media config
                let mediaConfig = MediaConfig(mediaEntry: mediaEntry!)
                
                do {
                    // prepare the player
                    try self.player!.prepare(mediaConfig)
                } catch let e {
                    // error loading the player
                    print("error:", e.localizedDescription)
                }
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
    
    func shouldAddPlayerViewController(_ vc: UIViewController) {
        print("yei!")
        self.addChildViewController(vc)
        self.playerContainer.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        UIApplication.shared.keyWindow!.addSubview(self.vrBtn)
    }
    
    @IBOutlet weak var vrBtn: UIButton!
    @IBAction func setVRMode(_ sender: Any) {
        var vrController: PKVRController = self.player?.getController(type: PKVRController.self) as! PKVRController
        
        vrController.setVRModeEnabled(true)
    }
    
}
