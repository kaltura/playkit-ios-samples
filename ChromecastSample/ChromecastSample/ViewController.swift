//
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import GoogleCast

/*
 This sample will show you how to create a player with basic functionality.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Register player events.
 3. Prepare Player.
 */

class ViewController: UIViewController, GoogleCastManagerDelegate {
    var player: Player?
    var playheadTimer: Timer?
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        //
        GoogleCastManager.sharedInstance.delegate = self
        
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
        
        if (GoogleCastManager.sharedInstance.isConnected()){
            var preferredStyle: UIAlertController.Style = .actionSheet
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                preferredStyle = .alert
            }
            
            let alert = UIAlertController(title:"Play Item", message:"Select an action", preferredStyle: preferredStyle)
            
            alert.addAction(UIAlertAction(title: "Play Now", style: .default) { action in
                print("Play Now")
                self.cast(appending:false)
            })
            // TODO:: Add Queue Support
//            alert.addAction(UIAlertAction(title: "Add to Queue", style: .default) { action in
//                print("Add to Queue")
//                self.cast(appending:true)
//            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("Cancelled")
            })
            
            if let topController = UIApplication.topViewController() {
                topController.present(alert, animated: true)
            }
        } else if !(player.isPlaying) {
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
    
    
/************************/
// MARK: - Casting
/***********************/
    func cast(appending:Bool) {
        self.player?.pause()
        GoogleCastManager.sharedInstance.cast(appending: appending)
    }
    
    func decast() {
        self.player?.resume()
    }
    
    //MARK: protocol GoogleCastManagerDelegat
    func castManagerDidStartSession(sender: GoogleCastManager) {
        print("castManagerDidStartSession")
    }
    
    func castManagerDidEndSession(sender: GoogleCastManager) {
        print("castManagerDidEndSession")
        self.decast()
    }
    
    func castManagerDidStartMediaSession(sender: GoogleCastManager) {
        print("castManagerDidStartMediaSession")
    }
    
    internal func castManagerDidResumeSession(sender: GoogleCastManager) {
        print("castManagerDidResumeSession")
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
