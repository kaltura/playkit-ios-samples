//
//  ViewController.swift
//  PlayKitAppleTVSample
//
//  Created by Gal Orlanczyk on 03/05/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import KalturaNetKit
import PlayKit
import PlayKitYoubora
import PlayKitKava
import PlayKit_IMA

class VideoViewController: UIViewController, UIGestureRecognizerDelegate {

    let animationDuration: TimeInterval = 0.5
    let seekAmount: TimeInterval = 15
    let settingsSegueIdentifier = "showSettings"
    let changeMediaSegueIdentifier = "showChangeMedia"
    
    var player: Player! // Created in the viewDidLoad
    var focusedViews = [UIView]()
    var playerSettings = PlayerSettings()
    var shouldShowControlsOnViewWillAppear = false
    
    // Tracks
    var tracks: PKTracks?
    var selectedAudioTrack: Track?
    var selectedCaptionTrack: Track?
    var tracksControlsView: UIView?
    var captionsSegmentedControl: UISegmentedControl?
    var audioTracksSegmentedControl: UISegmentedControl?
    
    // Playback controls
    @IBOutlet weak var playbackControlsView: UIVisualEffectView!
    @IBOutlet weak var seekBackButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var seekForwardButton: UIButton!
    @IBOutlet weak var changeMediaButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var playbackControlsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var medias: [Media] = Medias.create()

    /************************************************************/
    // MARK: - Life Cycle
    /************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Config options
        let youboraOptions: [String: Any] = [
            "accountCode": "kalturatest" // mandatory
            // YouboraPlugin.enableSmartAdsKey: true - use this if you want to enable smart ads
        ]
        
        // Create analytics config with the created params
        let youboraConfig = AnalyticsConfig(params: youboraOptions)
        
        let kavaConfig = KavaPluginConfig(partnerId: 1091,
                                          entryId: nil,
                                          ks: nil,
                                          playbackContext: nil,
                                          referrer: nil,
                                          applicationVersion: "1.0",
                                          playlistId: "abc",
                                          customVar1: nil,
                                          customVar2: nil,
                                          customVar3: nil)
        kavaConfig.playbackType = KavaPluginConfig.PlaybackType.vod
        
        // IMA Config
        let imaConfig = IMAConfig()
        imaConfig.playerVersion = PlayKitManager.versionString
        
        // Create config dictionary
        let config = [YouboraPlugin.pluginName: youboraConfig, KavaPlugin.pluginName: kavaConfig, IMAPlugin.pluginName: imaConfig]
        
        // Create plugin config object
        let pluginConfig = PluginConfig(config: config)
        
        self.player = PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
        player.view = (self.view as! PlayerView)
        player.view?.backgroundColor = UIColor.black
        
        registerPlayerEvents()
        addGestures()
        setupPlaybackControlsView()
        
        // Select first media to load
        medias.first?.mediaConfig(startTime: playerSettings.startTime, completionHandler: { (mediaConfig) in
            guard let mc = mediaConfig else { return }
            self.player.prepare(mc)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.shouldShowControlsOnViewWillAppear {
            self.shouldShowControlsOnViewWillAppear = false
            self.showPlaybackControlsView()
        }
    }
    
    deinit {
        unregisterPlayerEvents()
    }
    
    /************************************************************/
    // MARK: - Overrides
    /************************************************************/
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if focusedViews.count > 0 {
            return focusedViews
        } else if let playerView = player?.view {
            return [playerView]
        } else {
            return super.preferredFocusEnvironments
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == UIPress.PressType.menu {
            // DO NOT REMOVE THE FOCUSED VIEWS HERE!
            // Menu also takes the app to the background.
            // If there is an ad playing it will be stuck on paused.
            super.pressesBegan(presses, with: event)
        } else if presses.first?.type == UIPress.PressType.playPause {
            self.playPause()
        } else {
            super.pressesBegan(presses, with: event)
        }
    }
    
    /************************************************************/
    // MARK: - Actions
    /************************************************************/
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleSwipeUp(gesture: UISwipeGestureRecognizer) {
        if isTracksControlsViewShown() {
            self.removeTracksControlsView()
        } else if !isPlaybackControlsViewShown() {
            self.showPlaybackControlsView()
        }
    }
    
    @objc func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
        if isPlaybackControlsViewShown() {
            self.hidePlaybackControlsView()
        } else if let tracks = self.tracks, !isTracksControlsViewShown() {
            self.showTracksControlsView(tracks: tracks)
        }
    }
    
    /************************************************************/
    // MARK: - Navigation
    /************************************************************/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        player.pause()
        if segue.identifier == self.settingsSegueIdentifier {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.playerSettings = self.playerSettings
            self.shouldShowControlsOnViewWillAppear = true
            self.hidePlaybackControlsView()
        } else if segue.identifier == self.changeMediaSegueIdentifier {
            let destinationVC = segue.destination as! ChangeMediaTableViewController
            destinationVC.player = player
            destinationVC.medias = medias
            destinationVC.playerSettings = playerSettings
            self.shouldShowControlsOnViewWillAppear = true
            self.hidePlaybackControlsView()
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    /************************************************************/
    // MARK: - Internal
    /************************************************************/
    
    func registerPlayerEvents() {
        player.addObserver(self, events: [PlayerEvent.durationChanged, PlayerEvent.tracksAvailable, PlayerEvent.playing, PlayerEvent.pause, PlayerEvent.playheadUpdate, PlayerEvent.ended, PlayerEvent.stopped]) { (event) in
            switch event {
            case is PlayerEvent.DurationChanged:
                self.durationLabel.text = self.getTimeRepresentation(time: event.duration?.doubleValue ?? self.player.duration)
            case is PlayerEvent.TracksAvailable:
                self.tracks = event.tracks
            case is PlayerEvent.Playing:
                self.playPauseButton.setTitle("Pause", for: .normal)
                self.playPauseButton.tag = 0
            case is PlayerEvent.Pause:
                self.playPauseButton.setTitle("Play", for: .normal)
            case is PlayerEvent.PlayheadUpdate:
                let currentTime = event.currentTime?.doubleValue ?? self.player.currentTime
                self.currentTimeLabel.text = self.getTimeRepresentation(time: currentTime)
                if currentTime > 0 {
                    self.progressView.setProgress(Float(currentTime/self.player.duration), animated: true)
                }
            case is PlayerEvent.Ended:
                self.playPauseButton.setTitle("Replay", for: .normal)
                self.playPauseButton.tag = 1
            case is PlayerEvent.Stopped:
                // Reset view
                self.playPauseButton.setTitle("Play", for: .normal)
                self.playPauseButton.tag = 0
                self.currentTimeLabel.text = self.getTimeRepresentation(time: 0)
                self.progressView.progress = 0
                self.durationLabel.text = self.getTimeRepresentation(time: 0)
            default:
                break
            }
        }
    }
    
    func unregisterPlayerEvents() {
        player.removeObserver(self, events: [PlayerEvent.durationChanged, PlayerEvent.tracksAvailable, PlayerEvent.playing, PlayerEvent.pause, PlayerEvent.playheadUpdate, PlayerEvent.ended, PlayerEvent.stopped])
    }
    
    func addGestures() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(gesture:)))
        swipeUpGesture.direction = .up
        player.view?.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(gesture:)))
        swipeDownGesture.direction = .down
        player.view?.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func playPause() {
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            if playPauseButton.tag == 1 {
                player.replay()
            } else {
                player.play()
            }
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    func getTimeRepresentation(time: TimeInterval) -> String {
        if time < 0 {
            return "--:--"
        } else if time > 3600 {
            let hours = Int(time / 3600)
            let minutes = Int(time.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(time.truncatingRemainder(dividingBy: 60))
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            let minutes = Int(time / 60)
            let seconds = Int(time.truncatingRemainder(dividingBy: 60))
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

