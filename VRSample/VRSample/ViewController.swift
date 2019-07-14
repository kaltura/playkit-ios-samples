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

/*
 This sample will show you how to create a player with basic functionality.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Set delegate.
 3. Prepare Player.
 4. impliment delegate method: shouldAddPlayerViewController.
 5. Get PKVRController.
 6. Use PKVRController API.
 */

struct MediaData {
    let serverURL: String
    let partnerId: Int
    let entryId: String
}
    
class ViewController: UIViewController {
    
    var mediaData: MediaData?
    
    var player: Player?
    var playheadTimer: Timer?
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        // 1. Load the player
        self.player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)

        // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        self.preparePlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        player?.addObserver(self, event: PlayerEvent.error, block: { (event) in
            print("error: " + (event.error?.localizedDescription ?? ""))
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player?.stop()
        player = nil
        playheadTimer = nil

        player?.removeObserver(self, event: PlayerEvent.error)
        super.viewWillDisappear(animated)
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func preparePlayer() {
        // setup the player's view
        self.player?.view = self.playerContainer
        
        guard let serverURL = mediaData?.serverURL,
            let partnerId = mediaData?.partnerId,
            let entryID = mediaData?.entryId
            else { return }
        
        let sessionProvider = SimpleSessionProvider(serverURL: serverURL, partnerId: Int64(partnerId), ks: nil)
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        
        mediaProvider.entryId = entryID
        
        mediaProvider.loadMedia { [weak self] (pkMediaEntry, error) in
            guard let mediaEntry = pkMediaEntry else { return }
            
            // create media config
            let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
            self?.player?.prepare(mediaConfig)
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
            self.playheadTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] (timer) in
                self?.playheadSlider.value = Float(player.currentTime / player.duration)
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
    
    @IBOutlet weak var vrBtn: UIButton!

/************************/
// MARK: - VR
/***********************/

    @IBAction func setVRMode(_ sender: Any) {
        // 5. Get PKVRController
        let vrController = self.player?.getController(ofType: PKVRController.self)
        // 6. Use PKVRController API
        vrController?.setVRModeEnabled(true)
    }
}
