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
//        let mediaEntry = getDRMMediaWithExternalSubtitles()
        
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
        // If we set external subtitles, they will be ignored.
        
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
                                                           duration: 570.0),
                                        PKExternalSubtitle(id: "English-en",
                                                           name: "English",
                                                           language: "en",
                                                           vttURLString: "http://externaltests.dev.kaltura.com/player/captions_files/eng.vtt",
                                                           duration: 570.0)]
        
        return mediaEntry
    }
    
    func getDRMMediaWithExternalSubtitles() -> PKMediaEntry {
        let contentURL = "https://cdnapisec.kaltura.com/p/2222401/sp/2222401/playManifest/entryId/1_i18rihuv/flavorIds/1_nwoofqvr,1_3z75wwxi,1_exjt5le8,1_uvb3fyqs/deliveryProfileId/8642/protocol/https/format/applehttp/a.m3u8"
        
        // Create media source and initialize a media entry with that source
        let entryId = "0_pl5lbfo0"
        let drmParams = FairPlayDRMParams(licenseUri: "https://udrmv3.kaltura.com/fps/license?custom_data=eyJjYV9zeXN0ZW0iOiJPVlAiLCJ1c2VyX3Rva2VuIjoiZGpKOE1qSXlNalF3TVh3amRkODBoRzFnNEVFU1ZLdG9KVmF6VlJRWFEwZ05faDRLRGxvOVc5NklEOUw1c0hLdGkwZ1J3UXM5dW5zbTlLTmNOT1o2QWtDR0hFRTdlMmZuNHFOdGlPYjM1M2k4QTZaQWlnbktxS0hsNHc9PSIsImFjY291bnRfaWQiOiIyMjIyNDAxIiwiY29udGVudF9pZCI6IjFfaTE4cmlodXYiLCJmaWxlcyI6IjFfbndvb2ZxdnIsMV8zejc1d3d4aSwxX2V4anQ1bGU4LDFfdXZiM2Z5cXMifQ%3D%3D&signature=KbGUO7ucxk7xDIdIWS4IKtAdSZU%3D",
                                          base64EncodedCertificate: "MIIFETCCA/mgAwIBAgIISWLo8KcYfPMwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMjAxMTY0NTQ0WhcNMTgwMjAxMTY0NTQ0WjCBijELMAkGA1UEBhMCVVMxKDAmBgNVBAoMH1ZJQUNPTSAxOCBNRURJQSBQUklWQVRFIExJTUlURUQxEzARBgNVBAsMClE5QU5HR0w4TTYxPDA6BgNVBAMMM0ZhaXJQbGF5IFN0cmVhbWluZzogVklBQ09NIDE4IE1FRElBIFBSSVZBVEUgTElNSVRFRDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA2YmfdPWM86+te7Bbt4Ic6FexXwMeL+8AmExIj8jAaNxhKbfVFnUnuXzHOajGC7XDbXxsFbPqnErqjw0BqUoZhs+WVMy+0X4AGqHk7uRpZ4RLYganel+fqitL9rz9w3p41x8JfLV+lAej+BEN7zNeqQ2IsC4BxkViu1gA6K22uGsCAwEAAaOCAgcwggIDMB0GA1UdDgQWBBQK+Gmarl2PO3jtLP6A6TZeihOL3DAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFGPkR1TLhXFZRiyDrMxEMWRnAyy+MIHiBgNVHSAEgdowgdcwgdQGCSqGSIb3Y2QFATCBxjCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA1BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vY3JsLmFwcGxlLmNvbS9rZXlzZXJ2aWNlcy5jcmwwDgYDVR0PAQH/BAQDAgUgMEgGCyqGSIb3Y2QGDQEDAQH/BDYBZ2diOGN5bXpsb21vdXFqb3p0aHg5aXB6dDJ0bThrcGdqOGNwZGlsbGVhMWI1aG9saWlyaW8wPQYLKoZIhvdjZAYNAQQBAf8EKwF5aHZlYXgzaDB2Nno5dXBqcjRsNWVyNm9hMXBtam9zYXF6ZXdnZXFkaTUwDQYJKoZIhvcNAQEFBQADggEBAIaTVzuOpZhHHUMGd47XeIo08E+Wb5jgE2HPsd8P/aHwVcR+9627QkuAnebftasV/h3FElahzBXRbK52qIZ/UU9nRLCqqKwX33eS2TiaAzOoMAL9cTUmEa2SMSzzAehb7lYPC73Y4VQFttbNidHZHawGp/844ipBS7Iumas8kT8G6ZmIBIevWiggd+D5gLdqXpOFI2XsoAipuxW6NKnnlKnuX6aNReqzKO0DmQPDHO2d7pbd3wAz5zJmxDLpRQfn7iJKupoYGqBs2r45OFyM14HUWaC0+VSh2PaZKwnSS8XXo4zcT/MfEcmP0tL9NaDfsvIWnScMxHUUTNNsZIp3QXA=")
        
        let source = PKMediaSource(entryId, contentUrl: URL(string: contentURL), drmData: [drmParams], mediaFormat: .hls)
        
        // Setup media entry
        let mediaEntry = PKMediaEntry(entryId, sources: [source], duration: -1)
        mediaEntry.externalSubtitles = [PKExternalSubtitle(id: "Deutsch-de",
                                                           name: "Deutsch",
                                                           language: "de",
                                                           vttURLString: "http://brenopolanski.com/html5-video-webvtt-example/MIB2-subtitles-pt-BR.vtt",
                                                           duration: 888.11),
                                        PKExternalSubtitle(id: "English-en",
                                                           name: "English",
                                                           language: "en",
                                                           vttURLString: "http://externaltests.dev.kaltura.com/player/captions_files/eng.vtt",
                                                           duration: 888.11)]
        
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
