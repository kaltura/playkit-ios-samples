//
//  MediaTableViewCell.swift
//  TablePlayerSample
//
//  Created by Nilit Danan on 11/13/19.
//  Copyright © 2018 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit
import PlayKitProviders

struct OVPMedia {
    var serverURL: String = "https://cdnapisec.kaltura.com"
    var partnerId: Int64
    var entryId: String
    var ks: String?
    var autoBuffer: Bool = false
    var autoPlay: Bool = false // Set true for the first media
}

protocol MediaTableViewCellDelegate {
    func startedPlayingMedia(_ cell: MediaTableViewCell)
    // You can add one for paused because it was stalled, and in the implementation, if it's the focused cell to call play.
}

class MediaTableViewCell: UITableViewCell {
    
    var delegate: MediaTableViewCellDelegate?
    var player: Player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
    var media: OVPMedia? {
        didSet {
            guard let media = self.media else {
                return
            }
            setupPlayer()
            
            let sessionProvider = SimpleSessionProvider(serverURL:media.serverURL, partnerId:media.partnerId, ks:media.ks)
            let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
            mediaProvider.entryId = media.entryId
            mediaProvider.loadMedia { [weak self] (mediaEntry, error) in
                guard let self = self else { return }
                
                if let startDate = self.loadMediaCalledDate {
                    let diff = Date().timeIntervalSince(startDate)
                    self.logTextView.text.append("\nMedia Entry received after \(diff) seconds")
                }
                if let mediaEntry = mediaEntry, error == nil {
                    // Create media config
                    let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
                    if let startDate = self.loadMediaCalledDate {
                        let diff = Date().timeIntervalSince(startDate)
                        self.logTextView.text.append("\nPrepare called after \(diff) seconds")
                    }
                    // Prepare the player
                    self.player.prepare(mediaConfig)
                    if self.media?.autoBuffer == true {
                        self.startBuffering()
                    }
                } else {
                    let alert = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            loadMediaCalledDate = Date()
        }
    }
    let errorEventsToObserve = [PlayerEvent.error, PlayerEvent.errorLog, PlayerEvent.playbackStalled]
    let eventsToObserve = [PlayerEvent.stateChanged, PlayerEvent.canPlay, PlayerEvent.playing, PlayerEvent.pause, PlayerEvent.ended]
    
    var loadMediaCalledDate: Date?
    
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet weak var logTextView: UITextView!
    
    override func prepareForReuse() {
        stopMedia()
        super.prepareForReuse()
    }
    
    @IBAction func playPauseButtonTouched(_ sender: Any) {
        if player.rate > 0 {
            pauseMedia()
        } else {
            playMedia()
        }
    }
    
    func setupPlayer() {
        self.player.settings.network.preferredForwardBufferDuration = 1.0
        self.player.settings.shouldPlayImmediately = true
        self.player.settings.network.automaticallyWaitsToMinimizeStalling = false
        self.player.settings.network.autoBuffer = false
        
        self.player.addObserver(self, events: errorEventsToObserve, block: { [weak self] (event) in
            print("error: " + (event.error?.localizedDescription ?? ""))
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                var logEvent = "\n"
                switch event {
                case is PlayerEvent.Error:
                    logEvent = "\nError:"
                case is PlayerEvent.ErrorLog:
                    logEvent = "\nErrorLog:"
                case is PlayerEvent.PlaybackStalled:
                    logEvent = "\nPlaybackStalled:"
                default:
                    break
                }
                
                logEvent.append(event.error?.localizedDescription ?? "")
                self.logTextView.text.append(logEvent)
            }
        })
        
        self.player.addObserver(self, events: eventsToObserve, block: { [weak self] (event) in
            guard let self = self else { return }
            PKLog.debug("Received event: \(event.description)")
            DispatchQueue.main.async {
                switch event {
                case is PlayerEvent.StateChanged:
                    switch event.newState {
                    case .idle:
                        // Reset the timer, Current Item was initialized
                        self.loadMediaCalledDate = Date()
                    default:
                        break
                    }
                case is PlayerEvent.CanPlay:
                    if let startDate = self.loadMediaCalledDate {
                        let diff = Date().timeIntervalSince(startDate)
                        self.logTextView.text.append("\nCan Play received after \(diff) seconds")
                    }
                    if self.media?.autoPlay == true {
                        self.playMedia()
                    }
                case is PlayerEvent.Playing:
                    self.playPauseButton.setImage(UIImage(named: "Pause"), for: UIControl.State.normal)
                    self.delegate?.startedPlayingMedia(self)
                case is PlayerEvent.Pause:
                    self.playPauseButton.setImage(UIImage(named: "Play"), for: UIControl.State.normal)
                case is PlayerEvent.Ended:
                    self.playPauseButton.setImage(nil, for: UIControl.State.normal)
                    // You can add a replay image and perform replay when clicked.
                default:
                    break
                }
            }
        })
        
        self.player.view = playerView
    }
    
    func playMedia() {
        player.play()
    }
    
    func pauseMedia() {
        player.pause()
    }
    
    func stopMedia() {
        player.removeObserver(self, events: errorEventsToObserve)
        player.removeObserver(self, events: eventsToObserve)
        player.stop()
        
        delegate = nil
        media = nil
        
        logTextView.text = ""
        loadMediaCalledDate = nil
    }
    
    func startBuffering() {
        player.startBuffering()
    }
}
