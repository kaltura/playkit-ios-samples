//
//  ViewController.swift
//  KMC-Player
//
//  Created by Nilit Danan on 3/8/18.
//  Copyright © 2018 Nilit Danan. All rights reserved.
//

import UIKit
import PlayKit

class MediaPlayerViewController: UIViewController {
    
    var player: Player?
    
    var mediaEntry: PKMediaEntry?
    var selectedAudio: String = ""
    var selectedSubtitle: String = ""
    
    @IBOutlet weak var playerView: PlayerView!
    
    @IBOutlet weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var topVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var bottomVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var settingsVisualEffectView: UIVisualEffectView!
    let topBottomVisualEffectViewHeight: Float = 50.0
    
    @IBOutlet weak var animatedPlayButton: UIAnimatedPlayButton!
    
    @IBOutlet weak var mediaProgressSlider: UISlider!
    var mediaProgressTimer: Timer?
    
    var audioTracks: [Track]?
    var textTracks: [Track]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(playerViewTapped))
        playerView.addGestureRecognizer(gesture)
        
        self.settingsVisualEffectView.alpha = 0.0
        
        setupPlayer()
        showPlayerControllers(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    // MARK: - Private Methods
    
    private func setupPlayer() {
        
        guard let mediaEntry = mediaEntry else {
            return
        }
        
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry, startTime: 0.0)
        mediaProgressSlider.value = 0.0
        
        do {
            player = try PlayKitManager.shared.loadPlayer(pluginConfig: nil)
            registerPlayerEvents()
            player!.prepare(mediaConfig)
            player?.view = playerView
            
            if selectedSubtitle.count > 0 {
                player?.settings.trackSelection.textSelectionMode = .selection
                player?.settings.trackSelection.textSelectionLanguage = selectedSubtitle
            }
            
            if selectedAudio.count > 0 {
                player?.settings.trackSelection.audioSelectionMode = .selection
                player?.settings.trackSelection.audioSelectionLanguage = selectedAudio
            }
        } catch let e {
            print("Error loading the player: \(e)")
        }
    }
    
    @objc private func mediaProgressTimerFired() {
        guard let player = player else {
            print("player is not set")
            return
        }
        mediaProgressSlider.value = Float(player.currentTime / player.duration)
    }
    
    private func showPlayerControllers(_ show: Bool) {
        let constantValue: Float = show ? topBottomVisualEffectViewHeight : 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.topVisualEffectViewHeightConstraint.constant = CGFloat(constantValue)
            self.bottomVisualEffectViewHeightConstraint.constant = CGFloat(constantValue)
            self.middleVisualEffectView.alpha = show ? 1.0 : 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func playerViewTapped() {
        let show = !(topVisualEffectViewHeightConstraint.constant == CGFloat(topBottomVisualEffectViewHeight))
        showPlayerControllers(show)
    }
    
    private func updateAnimatedPlayButton() {
        guard let player = player else {
            return
        }
        
        if player.rate > 0 || player.isPlaying {
            animatedPlayButton.transformToState(UIAnimatedPlayButtonState.Pause)
        } else {
            animatedPlayButton.transformToState(UIAnimatedPlayButtonState.Play)
        }
    }
    
    // MARK: - Events Registration
    
    func registerPlayerEvents() {
        registerPlaybackEvents()
        handleTracks()
    }
    
    func registerPlaybackEvents() {
        guard let player = player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [PlayerEvent.stopped, PlayerEvent.ended, PlayerEvent.play, PlayerEvent.pause]) { event in
            if type(of: event) == PlayerEvent.stopped {
                print("Stopped Event")
            } else if type(of: event) == PlayerEvent.ended {
                print("Ended Event")
            } else if type(of: event) == PlayerEvent.play {
                print("Play Event")
            } else if type(of: event) == PlayerEvent.pause {
                print("Pause Event")
            }
            
            self.updateAnimatedPlayButton()
        }
    }
    
    func handleTracks() {
        guard let player = player else {
            print("player is not set")
            return
        }
        
        player.addObserver(self, events: [PlayerEvent.tracksAvailable]) { [weak self] event in
            if type(of: event) == PlayerEvent.tracksAvailable {
                guard let tracks = event.tracks else {
                    print("No Tracks Available")
                    return
                }
                
                self?.audioTracks = tracks.audioTracks
                self?.textTracks = tracks.textTracks
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func trackTouched(_ sender: Any) {
        
        showPlayerControllers(false)
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            self.settingsVisualEffectView.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func closeSettingsTouched(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            self.settingsVisualEffectView.alpha = 0.0
        }, completion: {(succeded) in
            self.showPlayerControllers(true)
        })
    }
    
    @IBAction func speechTouched(_ sender: Any) {
        guard let tracks = audioTracks else {
            return
        }
        
        let alertController = UIAlertController(title: "Select Speech", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: UIAlertActionStyle.default, handler: { (alertAction) in
                self.player?.selectTrack(trackId: track.id)
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func subtitleTouched(_ sender: Any) {
        guard let tracks = textTracks else {
            return
        }
        
        let alertController = UIAlertController(title: "Select Subtitle", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: UIAlertActionStyle.default, handler: { (alertAction) in
                self.player?.selectTrack(trackId: track.id)
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func closeTouched(_ sender: Any) {
        player?.destroy()
        performSegue(withIdentifier: "unwindSegueToMediaCollection", sender: self)
    }
    
    @IBAction func mediaProgressSliderValueChanged(_ sender: UISlider) {
        guard let player = player else {
            return
        }
        
        let currentValue = Double(sender.value)
        let seekTo = currentValue * player.duration
        player.seek(to: seekTo)
    }
    
    @IBAction func animatedPlayButtonTouched(_ sender: Any) {
        guard let player = player else {
            print("player is not set")
            return
        }
        
        if player.rate > 0 || player.isPlaying {
            mediaProgressTimer?.invalidate()
            mediaProgressTimer = nil
            player.pause()
        } else {
            mediaProgressTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(mediaProgressTimerFired), userInfo: nil, repeats: true)
            
            player.play()
            showPlayerControllers(false)
        }
        
        updateAnimatedPlayButton()
    }
    
    @IBAction func speedRateTouched(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Speed Rate", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Normal", style: UIAlertActionStyle.default, handler: { (alertAction) in
            self.player?.rate = 1
            self.updateAnimatedPlayButton()
        }))
        alertController.addAction(UIAlertAction(title: "x2", style: UIAlertActionStyle.default, handler: { (alertAction) in
            self.player?.rate = 2
            self.updateAnimatedPlayButton()
        }))
        alertController.addAction(UIAlertAction(title: "x3", style: UIAlertActionStyle.default, handler: { (alertAction) in
            self.player?.rate = 3
            self.updateAnimatedPlayButton()
        }))
        present(alertController, animated: true, completion: nil)
    }
}
