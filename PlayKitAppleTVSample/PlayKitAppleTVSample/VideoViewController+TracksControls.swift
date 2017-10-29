//
//  VideoViewController+TracksControls.swift
//  PlayKitAppleTVSample
//
//  Created by Gal Orlanczyk on 24/05/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit

extension VideoViewController {
    
    func showTracksControlsView(tracks: PKTracks) {
        // initialize views //
        let tracksControlsView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        tracksControlsView.alpha = 0
        self.tracksControlsView = tracksControlsView
        
        let centeredView = UIView()
        
        let captionsButton = UIButton(type: .system)
        captionsButton.setTitle("Set Captions", for: .normal)
        captionsButton.addTarget(self, action: #selector(setCaptions(sender:)), for: .primaryActionTriggered)
        if tracks.textTracks == nil {
            captionsButton.isEnabled = false
        }
        
        let audioTracksButton = UIButton(type: .system)
        audioTracksButton.setTitle("Set Audio Tracks", for: .normal)
        audioTracksButton.addTarget(self, action: #selector(setAudioTracks(sender:)), for: .primaryActionTriggered)
        if tracks.audioTracks == nil {
            audioTracksButton.isEnabled = false
        }
        
        // add subviews //
        centeredView.addSubview(captionsButton)
        centeredView.addSubview(audioTracksButton)
        tracksControlsView.contentView.addSubview(centeredView)
        self.player.view?.addSubview(tracksControlsView)
        
        // add constraints //
        centeredView.translatesAutoresizingMaskIntoConstraints = false
        tracksControlsView.translatesAutoresizingMaskIntoConstraints = false
        captionsButton.translatesAutoresizingMaskIntoConstraints = false
        audioTracksButton.translatesAutoresizingMaskIntoConstraints = false
        
        tracksControlsView.leftAnchor.constraint(equalTo: self.player.view!.leftAnchor).isActive = true
        tracksControlsView.rightAnchor.constraint(equalTo: self.player.view!.rightAnchor).isActive = true
        tracksControlsView.topAnchor.constraint(equalTo: self.player.view!.topAnchor).isActive = true
        tracksControlsView.heightAnchor.constraint(equalTo: self.player.view!.heightAnchor, multiplier: 0.15).isActive = true
        
        centeredView.centerYAnchor.constraint(equalTo: tracksControlsView.centerYAnchor).isActive = true
        centeredView.centerXAnchor.constraint(equalTo: tracksControlsView.centerXAnchor).isActive = true
        centeredView.heightAnchor.constraint(equalTo: tracksControlsView.heightAnchor, multiplier: 0.7).isActive = true
        centeredView.widthAnchor.constraint(equalTo: tracksControlsView.widthAnchor, multiplier: 0.45).isActive = true
        
        captionsButton.centerYAnchor.constraint(equalTo: centeredView.centerYAnchor).isActive = true
        captionsButton.leftAnchor.constraint(equalTo: centeredView.leftAnchor).isActive = true
        
        audioTracksButton.centerYAnchor.constraint(equalTo: centeredView.centerYAnchor).isActive = true
        audioTracksButton.rightAnchor.constraint(equalTo: centeredView.rightAnchor).isActive = true
        audioTracksButton.widthAnchor.constraint(equalTo: captionsButton.widthAnchor).isActive = true
        
        // update focused views
        self.focusedViews = [captionsButton, audioTracksButton]
        
        // animate showing tracks controls
        UIView.animate(withDuration: self.animationDuration, animations: { 
            tracksControlsView.alpha = 1
        }) { (finished) in
            tracksControlsView.setNeedsFocusUpdate()
            tracksControlsView.updateFocusIfNeeded()
        }
    }
    
    func removeTracksControlsView() {
        // select audio and captions tracks
        if let index = captionsSegmentedControl?.selectedSegmentIndex, index >= 0, let captionTrack = self.tracks?.textTracks?[index] {
            // first check if previous != current (no need to select if there was no change)
            if selectedCaptionTrack != captionTrack {
                self.player.selectTrack(trackId: captionTrack.id)
            }
            self.selectedCaptionTrack = captionTrack
        }
        if let index = audioTracksSegmentedControl?.selectedSegmentIndex, index >= 0, let audioTrack = self.tracks?.audioTracks?[index] {
            // first check if previous != current (no need to select if there was no change)
            if selectedAudioTrack != audioTrack {
                self.player.selectTrack(trackId: audioTrack.id)
            }
            self.selectedAudioTrack = audioTrack
        }
        
        guard let tracksControlsView = self.tracksControlsView else { return }
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.player?.view?.layoutIfNeeded()
            self.tracksControlsView?.alpha = 0
        }) { (finished) in
            self.focusedViews = []
            tracksControlsView.removeFromSuperview()
            self.tracksControlsView = nil
        }
    }
    
    /************************************************************/
    // MARK: - Actions
    /************************************************************/
    
    @objc fileprivate func setCaptions(sender: UIButton) {
        guard let captions = self.tracks?.textTracks else { return }
        present(self.createAlertController(title: "Select The Desired Caption", tracks: captions), animated: true, completion: nil)
    }
    
    @objc fileprivate func setAudioTracks(sender: UIButton) {
        guard let audioTracks = self.tracks?.audioTracks else { return }
        present(self.createAlertController(title: "Select The Desired Audio Track", tracks: audioTracks), animated: true, completion: nil)
    }
    
    func createAlertController(title: String, tracks: [Track]) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        // Create and add the actions.
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: .default) { (action) in
                if let selectedTrackIndex = tracks.index(where: { $0.title == action.title }) {
                    let selectedTrack = tracks[selectedTrackIndex]
                    self.player.selectTrack(trackId: selectedTrack.id)
                }
            })
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alertController
    }
}
