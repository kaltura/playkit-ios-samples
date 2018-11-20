//
//  MediaTableViewCell.swift
//  IMATablePlayerSample
//
//  Created by Nilit Danan on 7/11/18.
//  Copyright © 2018 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit
import PlayKit_IMA

struct Media {
    var id: String
    var url: String
    var adTagURL: String
}

class MediaTableViewCell: UITableViewCell, PlayerDelegate {
    
    var player: Player?
    var pluginConfig: PluginConfig?
    
    var media: Media?
    
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var playPauseButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        player?.stop()
        player?.destroy()
        player = nil
        pluginConfig = nil
        media = nil
    }
    
    @IBAction func playPauseButtonTouched(_ sender: Any) {
        
        setupPlayer()
        
        guard let player = self.player else {
            print("player is not set")
            return
        }
    
        if player.rate > 0 {
            pauseMedia()
        } else {
            playMedia()
        }
    }
    
    func setupPlayer() {
        if player == nil {
            do {
                self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
            } catch {
                print("error:", error.localizedDescription)
            }
            self.player?.delegate = self
            
            self.player?.addObserver(self, events: [PlayerEvent.error, PluginEvent.error, PlayerEvent.errorLog], block: { (event) in
                print("error: " + (event.error?.localizedDescription ?? ""))
            })
            
            guard let url = self.media?.url, let contentURL = URL(string: url) else {
                return
            }
            
            let source = PKMediaSource("Kaltura Media", contentUrl: contentURL, mimeType: nil, drmData: nil, mediaFormat: PKMediaSource.MediaFormat.hls)
            let mediaEntry = PKMediaEntry("Kaltura Media", sources: [source], duration: -1)
            let mediaConfig = MediaConfig(mediaEntry: mediaEntry, startTime: 0)
            
            self.player?.view = playerView
            self.player?.prepare(mediaConfig)
        }
    }
    
    func playMedia() {
        setupPlayer()
        
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.play()
    }
    
    func pauseMedia() {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.pause()
    }
    
    func playerShouldPlayAd(_ player: Player) -> Bool {
        return true
    }
}
