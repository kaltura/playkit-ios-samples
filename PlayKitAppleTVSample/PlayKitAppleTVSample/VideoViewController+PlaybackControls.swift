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
    
    func showPlaybackControlsView() {
        // initialize views //
        let playbackControlsView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        playbackControlsView.alpha = 0
        let progressView = UIProgressView()
        
        let durationLabel = UILabel()
        durationLabel.text = self.getTimeRepresentation(time: self.duration ?? 0)
        self.durationLabel = durationLabel
        
        let currentTimeLabel = UILabel()
        currentTimeLabel.text = self.getTimeRepresentation(time: self.player.currentTime)
        self.currentTimeLabel = currentTimeLabel
        
        let controlsView = UIStackView()
        controlsView.distribution = .fillEqually
        controlsView.alignment = .center
        controlsView.axis = .horizontal
        
        // add subviews //
        playbackControlsView.contentView.addSubview(progressView)
        playbackControlsView.contentView.addSubview(controlsView)
        playbackControlsView.contentView.addSubview(currentTimeLabel)
        playbackControlsView.contentView.addSubview(durationLabel)
        playbackControlsView.contentView.addSubview(currentTimeLabel)
        self.player.view?.addSubview(playbackControlsView)
        self.playbackControlsView = playbackControlsView
        self.progressView = progressView
        
        // add constraints //
        playbackControlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = playbackControlsView.topAnchor.constraint(equalTo: self.player.view!.bottomAnchor)
        topConstraint.isActive = true
        playbackControlsView.leftAnchor.constraint(equalTo: self.player.view!.leftAnchor).isActive = true
        playbackControlsView.rightAnchor.constraint(equalTo: self.player.view!.rightAnchor).isActive = true
        playbackControlsView.heightAnchor.constraint(equalTo: self.player.view!.heightAnchor, multiplier: 0.2).isActive = true
        
        let sideSpacing: CGFloat = 44
        let padding: CGFloat = 20
        controlsView.topAnchor.constraint(equalTo: playbackControlsView.topAnchor).isActive = true
        controlsView.leftAnchor.constraint(equalTo: playbackControlsView.leftAnchor, constant: sideSpacing).isActive = true
        controlsView.rightAnchor.constraint(equalTo: playbackControlsView.rightAnchor, constant: -sideSpacing).isActive = true
        
        progressView.bottomAnchor.constraint(equalTo: playbackControlsView.bottomAnchor, constant: -(padding * 2)).isActive = true
        progressView.topAnchor.constraint(equalTo: controlsView.bottomAnchor, constant: padding).isActive = true
        
        durationLabel.rightAnchor.constraint(equalTo: playbackControlsView.rightAnchor, constant: -sideSpacing).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: progressView.rightAnchor, constant: padding).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        
        currentTimeLabel.leftAnchor.constraint(equalTo: playbackControlsView.leftAnchor, constant: sideSpacing).isActive = true
        currentTimeLabel.rightAnchor.constraint(equalTo: progressView.leftAnchor, constant: -padding).isActive = true
        currentTimeLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        
        // add control buttons
        let seekBackwardButton = UIButton(type: .system)
        seekBackwardButton.setTitle("Seek -\(Int(self.seekAmount))", for: .normal)
        seekBackwardButton.addTarget(self, action: #selector(seekBackward), for: .primaryActionTriggered)
        controlsView.addArrangedSubview(seekBackwardButton)
        
        let playPauseButton = UIButton(type: .system)
        if self.player.rate == 0 {
            playPauseButton.setTitle("Play", for: .normal)
        } else if self.player.rate == 1 {
            playPauseButton.setTitle("Pause", for: .normal)
        }
        playPauseButton.addTarget(self, action: #selector(playPause) , for: .primaryActionTriggered)
        controlsView.addArrangedSubview(playPauseButton)
        self.playPauseButton = playPauseButton
        
        let seekForwardButton = UIButton(type: .system)
        seekForwardButton.setTitle("Seek +\(Int(self.seekAmount))", for: .normal)
        seekForwardButton.addTarget(self, action: #selector(seekForward), for: .primaryActionTriggered)
        controlsView.addArrangedSubview(seekForwardButton)
        
        let changeMediaButton = UIButton(type: .system)
        changeMediaButton.setTitle("Change Media", for: .normal)
        changeMediaButton.addTarget(self, action: #selector(changeMedia), for: .primaryActionTriggered)
        controlsView.addArrangedSubview(changeMediaButton)
        
        let settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .primaryActionTriggered)
        controlsView.addArrangedSubview(settingsButton)
        
        controlsView.spacing = CGFloat(200 / controlsView.arrangedSubviews.count)
        
        // update focused views
        self.focusedViews = [playPauseButton]
        
        // update the initial progress
        self.updateProgress(animated: false)
        
        // update bottom constraint for nice animation
        let bottomConstraint = playbackControlsView.bottomAnchor.constraint(equalTo: self.player.view!.bottomAnchor)
        topConstraint.isActive = false
        bottomConstraint.isActive = true
        self.playbackControlsViewBottomConstraint = bottomConstraint
        // animate showing the playback controls
        UIView.animate(withDuration: self.animationDuration, animations: {
            playbackControlsView.alpha = 1
            self.player.view?.setNeedsLayout()
        }) { (finished) in
            self.player.view?.setNeedsFocusUpdate()
            self.player.view?.updateFocusIfNeeded()
        }
    }
    
    func removePlaybackControlsView() {
        guard let playbackControlsView = self.playbackControlsView, let _ = self.playPauseButton else { return }
        if let bottomConstraint = self.playbackControlsViewBottomConstraint {
            bottomConstraint.constant = playbackControlsView.frame.height
            UIView.animate(withDuration: self.animationDuration, animations: {
                self.player?.view?.layoutIfNeeded()
                self.playbackControlsView?.alpha = 0
            }) { (finished) in
                self.focusedViews = []
                playbackControlsView.removeFromSuperview()
                self.playbackControlsView = nil
            }
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
        self.stopProgressTimer()
        self.durationLabel?.text = self.getTimeRepresentation(time: -1)
        self.currentTimeLabel?.text = self.getTimeRepresentation(time: 0)
        self.progressView?.setProgress(0, animated: true)
        self.selectedCaptionTrack = nil
        self.selectedAudioTrack = nil
        self.tracks = nil
        self.playerSettings.createMediaConfig { [weak self] (mediaConfig) in
            guard let mc = mediaConfig else { return }
            self?.player.prepare(mc)
            if self?.playerSettings.autoplay == true && self?.player.rate == 0 { // if was paused and autoplay true then play
                self?.playPause()
            } else if self?.playerSettings.autoplay == false && self?.player.rate == 1 { // if was playing and autoplay false then pause
                self?.playPause()
            } else {
                self?.startProgressTimer()
            }
        }
    }
    
    @objc fileprivate func playbackControlsTapped(sender: UITapGestureRecognizer) {
        if self.playbackControlsView != nil {
            self.removePlaybackControlsView()
        }
    }
}
