//
//  VideoViewController+Controls.swift
//  PlayKitAppleTVSample
//
//  Created by Gal Orlanczyk on 23/05/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit

extension VideoViewController {
    
    /************************************************************/
    // MARK: - Playback Controls Handling
    /************************************************************/
    func setupPlaybackControlsView() {
        
        playbackControlsViewBottomConstraint.constant = -playbackControlsView.frame.height
        
        seekBackButton.setTitle("Seek -\(Int(self.seekAmount))", for: .normal)
        
        if self.player.isPlaying {
            playPauseButton.setTitle("Pause", for: .normal)
        } else if self.playPauseButton.tag == 1 {
            playPauseButton.setTitle("Replay", for: .normal)
        } else {
            playPauseButton.setTitle("Play", for: .normal)
        }
        
        seekForwardButton.setTitle("Seek +\(Int(self.seekAmount))", for: .normal)
        changeMediaButton.setTitle("Change Media", for: .normal)
        settingsButton.setTitle("Settings", for: .normal)

        durationLabel.text = self.getTimeRepresentation(time: player.duration)
        progressView.progress = 0
        currentTimeLabel.text = self.getTimeRepresentation(time: player.currentTime)
        
        seekBackButton.addTarget(self, action: #selector(seekBackward), for: .primaryActionTriggered)
        playPauseButton.addTarget(self, action: #selector(playPause) , for: .primaryActionTriggered)
        seekForwardButton.addTarget(self, action: #selector(seekForward), for: .primaryActionTriggered)
        changeMediaButton.addTarget(self, action: #selector(changeMedia), for: .primaryActionTriggered)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .primaryActionTriggered)
    }
    
    func isPlaybackControlsViewShown() -> Bool {
        return playbackControlsViewBottomConstraint.constant == 0
    }
    
    func showPlaybackControlsView() {
        guard let playerView = player.view else { return }

        // Update focused views
        self.focusedViews = [playPauseButton]
        
        // Animate showing the playback controls
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.playbackControlsView.alpha = 1
            self.playbackControlsViewBottomConstraint.constant = 0
            playerView.setNeedsLayout()
        }) { (finished) in
            playerView.setNeedsFocusUpdate()
            playerView.updateFocusIfNeeded()
        }
    }
    
    func hidePlaybackControlsView() {
        guard let playerView = player.view else { return }

        // Animate closing the playback controls
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.playbackControlsView.alpha = 0
            self.playbackControlsViewBottomConstraint.constant = -self.playbackControlsView.frame.height
            playerView.setNeedsLayout()
        }) { (finished) in
            self.focusedViews = []
            playerView.setNeedsFocusUpdate()
            playerView.updateFocusIfNeeded()
        }
    }
    
    /************************************************************/
    // MARK: - Actions
    /************************************************************/
    
    @objc fileprivate func seekForward() {
        self.player.currentTime += self.seekAmount
    }
    
    @objc fileprivate func seekBackward() {
        self.player.currentTime -= self.seekAmount
    }
    
    @objc fileprivate func openSettings() {
        self.performSegue(withIdentifier: self.settingsSegueIdentifier, sender: nil)
    }
    
    @objc fileprivate func changeMedia() {
        self.durationLabel.text = self.getTimeRepresentation(time: -1)
        self.currentTimeLabel.text = self.getTimeRepresentation(time: 0)
        self.progressView.setProgress(0, animated: true)
        self.selectedCaptionTrack = nil
        self.selectedAudioTrack = nil
        self.tracks = nil
        self.performSegue(withIdentifier: self.changeMediaSegueIdentifier, sender: nil)
    }
}
