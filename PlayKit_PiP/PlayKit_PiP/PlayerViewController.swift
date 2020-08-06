//
//  PlayerViewController.swift
//  PlayKit_PiP
//
//  Created by Sergii Chausov on 03.08.2020.
//  Copyright © 2020 Kaltura. All rights reserved.
//
//
//
//
//
//
//
// Useful links:
// https://developer.apple.com/documentation/avkit/adopting_picture_in_picture_in_a_custom_player
// https://developer.apple.com/library/archive/samplecode/AVFoundationPiPPlayer/Introduction/Intro.html
//

import UIKit
import AVKit
import PlayKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var pipButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var playbackControlsToolbar: UIToolbar!
    
    @IBOutlet weak var playerView: PlayerView!
    
    var player: Player? = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
    var playheadTimer: Timer?
    
    var pictureInPictureController: AVPictureInPictureController?
    var pipPossibleObservation: NSKeyValueObservation?
    
    deinit {
        pipPossibleObservation = nil
        playheadTimer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.isContinuous = false
        
        if #available(iOS 13.0, *) {
            let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
            let stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage
            pipButton.setImage(startImage, for: .normal)
            pipButton.setImage(stopImage, for: .selected)
        } else {
            // For iOS older then 13.0 use custom PiP Button images.
            let startImage = UIImage(named: "pip_button")
            let stopImage = UIImage(named: "pip_button")
            pipButton.setImage(startImage, for: .normal)
            pipButton.setImage(stopImage, for: .selected)
        }
        
        self.preparePlayer()
        self.setupPictureInPicture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //
        // Depends on your App business logic you may need keep playing PiP video after you dismiss PlayerViewController.
        // In this case you have to make some sort of manager to keep AVPictureInPictureController or/and PlayerViewController or/and Player instances.
        //
        
        player?.stop()
        player?.destroy()

        playheadTimer?.invalidate()
    }
    
    func preparePlayer() {
        
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8"),
            let player = self.player
            else { return }
        
        playerView.contentMode = .scaleAspectFit
        player.view = playerView
        
        let source = PKMediaSource("Source_ID", contentUrl: url)
        let entry = PKMediaEntry("Entry_ID", sources: [source])
        
        player.prepare(MediaConfig(mediaEntry: entry, startTime: 0.0))
                
        player.addObserver(self, events: [PlayerEvent.canPlay, PlayerEvent.pause, PlayerEvent.pause.playing]) { [weak self] (event) in
            guard let strongSelf = self else { return }

            switch event {
            case is PlayerEvent.CanPlay: strongSelf.play()
            case is PlayerEvent.Playing: strongSelf.playButton.setTitle("⏸", for: .normal)
            case is PlayerEvent.Pause: strongSelf.playButton.setTitle("▶️", for: .normal)
            default:
                break
            }
        }
        
    }
    
    func setupPictureInPicture() {
        
        guard let playerLayer = self.playerView.layer as? AVPlayerLayer else { return }
        
        // Ensure PiP is supported by current device.
        if AVPictureInPictureController.isPictureInPictureSupported() {
            // Create a new controller, passing the reference to the AVPlayerLayer.
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)
            pictureInPictureController?.delegate = self
            
            pipPossibleObservation = pictureInPictureController?.observe(\AVPictureInPictureController.isPictureInPicturePossible,
                                                                         options: [.initial, .new]) { [weak self] _, change in
                                                                            // Update the PiP button's enabled state.
                                                                            guard let strongSelf = self else { return }

                                                                            strongSelf.pipButton.isEnabled = change.newValue ?? false
            }
        } else {
            // PiP isn't supported by the current device. Disable the PiP button.
            pipButton.isEnabled = false
        }
    }
    
    func play() {
        guard let player = self.player else { return }
        
        if !player.isPlaying {
            self.playheadTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playheadUpdate), userInfo: nil, repeats: true)
            player.play()
        }
    }
    
    func pause() {
        guard let player = self.player else { return }
        
        if player.isPlaying {
            self.playheadTimer?.invalidate()
            self.playheadTimer = nil
            
            player.pause()
        }
    }
    
    @objc func playheadUpdate() {
        guard let player = self.player else { return }
        self.slider.value = Float(player.currentTime / player.duration)
    }
    
    // UI Actions
    
    @IBAction func togglePictureInPictureMode(_ sender: Any) {
        if let pipcontroller = self.pictureInPictureController,
            pipcontroller.isPictureInPictureActive {
            self.pictureInPictureController?.stopPictureInPicture()
        } else {
            self.pictureInPictureController?.startPictureInPicture()
        }
    }
    
    @IBAction func togglePlayPause(_ sender: Any) {
        guard let player = self.player else { return }
        
        if player.isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    
    @IBAction func seekAction(_ slider: UISlider) {
        guard let player = self.player else { return }
        self.player?.currentTime = TimeInterval(player.duration * Double(slider.value))
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PlayerViewController: AVPictureInPictureControllerDelegate {
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        // Restore user interface
        completionHandler(true)
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // hide playback controls
        // show placeholder artwork
        self.playbackControlsToolbar.isHidden = true
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // hide placeholder artwork
        // show playback controls
        self.playbackControlsToolbar.isHidden = false
    }
    
}
