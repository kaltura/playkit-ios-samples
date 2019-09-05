//
//  ViewController.swift
//  TracksSample-swift
//
//  Created by Vadik on 07/11/2017.
//  Copyright © 2017 kaltura. All rights reserved.
//

import UIKit
import PlayKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var picker: UIPickerView!
    
    var player: Player?
    var audioTracks: [Track] = []
    var textTracks: [Track] = []
    var selectedTracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 1. Load the player
        player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        // 2. Register events if needed.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        handleTracks()
        handlePlaybackInfo()
        handlePlayheadUpdate()
        
        // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        preparePlayer()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TextStylingSegue":
            guard let navigationVC = segue.destination as? UINavigationController else { return }
            guard let textStylingVC = navigationVC.topViewController as? TextStylingViewController else { return }
            textStylingVC.player = player
        default:
            return
        }
    }

    func preparePlayer() {
        // Setup the player's view
        player?.view = self.playerContainer
        playerContainer.sendSubviewToBack(self.player!.view!)
       
        // Uncomment the type of media needed
//        let mediaEntry = getMediaWithInternalSubtitles()
        let mediaEntry = getMediaWithExternalSubtitles()
        
        // Create media config
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
        
        // Set if we want the player to auto select the subtitles.
        player?.settings.trackSelection.textSelectionMode = .auto
        player?.settings.trackSelection.textSelectionLanguage = "en"
        
        // Prepare the player
        player?.prepare(mediaConfig)
    }
    
    func getMediaWithInternalSubtitles() -> PKMediaEntry {
        let contentURL = "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
        
        // Create media source and initialize a media entry with that source
        let entryId = "bipbop_16x9"
        let source = PKMediaSource(entryId, contentUrl: URL(string: contentURL), drmData: nil, mediaFormat: .hls)
        
        // Setup media entry
        let mediaEntry = PKMediaEntry(entryId, sources: [source], duration: -1)
        
        return mediaEntry
    }
    
    func getMediaWithExternalSubtitles() -> PKMediaEntry {
        let contentURL = "https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/1_9bwuo813/flavorIds/0_vfdi28n9,1_5j0bgx4v,1_x6tlvn4x,1_zj4vzg46/deliveryProfileId/19201/protocol/https/format/applehttp/a.m3u8"
        
        // Create media source and initialize a media entry with that source
        let entryId = "1_9bwuo813"
        let source = PKMediaSource(entryId, contentUrl: URL(string: contentURL), drmData: nil, mediaFormat: .hls)
        
        // Setup media entry
        let mediaEntry = PKMediaEntry(entryId, sources: [source], duration: -1)
        mediaEntry.externalSubtitles = [PKExternalSubtitle(id: "Deutsch-de",
                                                           name: "Deutsch",
                                                           language: "de",
                                                           vttURLString: "http://brenopolanski.com/html5-video-webvtt-example/MIB2-subtitles-pt-BR.vtt",
                                                           duration: 57.0),
                                        PKExternalSubtitle(id: "English-en",
                                                           name: "English",
                                                           language: "en",
                                                           vttURLString: "http://externaltests.dev.kaltura.com/player/captions_files/eng.vtt",
                                                           duration: 57.0)]
        
        return mediaEntry
    }
    
    func handleTracks() {
        player?.addObserver(self, events: [PlayerEvent.tracksAvailable, PlayerEvent.textTrackChanged, PlayerEvent.audioTrackChanged], block: { [weak self] (event: PKEvent) in
            if type(of: event) == PlayerEvent.tracksAvailable {
                guard let this = self else { return }
                
                if let tracks = event.tracks?.audioTracks {
                    this.audioTracks = tracks
                    this.selectedTracks = this.audioTracks
                }
                
                if let tracks = event.tracks?.textTracks {
                    this.textTracks = tracks
                }
                
                this.picker.reloadAllComponents()
            } else if type(of: event) == PlayerEvent.textTrackChanged {
                print("selected text track: \(event.selectedTrack?.title ?? "")")
            } else if type(of: event) == PlayerEvent.audioTrackChanged {
                print("selected audio track: \(event.selectedTrack?.title ?? "")")
            }
        })
    }
    
    func handlePlaybackInfo() {
        player?.addObserver(self, event: PlayerEvent.playbackInfo) { event in
            if type(of: event) == PlayerEvent.playbackInfo {
                if let _ = event.playbackInfo {
                    print("\(event.playbackInfo!)")
                }
            }
        }
    }
    
    func handlePlayheadUpdate() {
        player?.addObserver(self, event: PlayerEvent.playheadUpdate, block: { [weak self] (event) in
            guard let self = self else { return }
            self.playheadUpdate()
        })
    }
    
    func selectTrack(_ track: Track) {
        player?.selectTrack(trackId: track.id)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedTracks.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedTracks[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !selectedTracks.isEmpty {
            selectTrack(selectedTracks[row])
        }
    }
    
    @objc func playheadUpdate() {
        if let _ = player {
            playheadSlider.value = Float(player!.currentTime / player!.duration)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func didSeek(_ sender: UISlider) {
        print("playhead value: \(sender.value)")
        if let _ = player {
            player!.currentTime = player!.duration * TimeInterval(sender.value)
        }
    }
    
    @IBAction func didTapPause(_ sender: UIButton) {
        if player?.isPlaying == true {
            player?.pause()
        }
    }
    
    @IBAction func didTapPlay(_ sender: UIButton) {
        if player?.isPlaying == false {
            player?.play()
        }
    }
    
    @IBAction func didTapAudio(_ sender: UIButton) {
        selectedTracks = audioTracks
        picker.reloadAllComponents()
    }
    
    @IBAction func didTapText(_ sender: UIButton) {
        selectedTracks = textTracks
        picker.reloadAllComponents()
    }
}
