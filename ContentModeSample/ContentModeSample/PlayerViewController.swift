//
//  ViewController.swift
//  ContentModeSample
//
//  Created by Sergey Chausov on 12.10.2022.
//

import UIKit
import AVKit
import PlayKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerView: PlayerView!
    
    @IBOutlet weak var contentModeControl: UISegmentedControl!
    @IBOutlet weak var videoSourceControl: UISegmentedControl!
    
    var player: Player? = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
    
    let contentModeItems: [String: UIView.ContentMode] = ["sAspFill": .scaleAspectFill,
                                                          "sToFill": .scaleToFill,
                                                          "sAspFit": .scaleAspectFit]
    
    let videoSources: [String: String] =
    ["4x3": "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8",
     "16x9": "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoSourceControl.removeAllSegments()
        contentModeControl.removeAllSegments()
        
        videoSources.keys.enumerated().forEach({
            self.videoSourceControl.insertSegment(withTitle: $1, at: $0, animated: false)
        })
        
        contentModeItems.keys.enumerated().forEach({
            self.contentModeControl.insertSegment(withTitle: $1, at: $0, animated: false)
        })
                
        self.preparePlayer()
    }
    
    func preparePlayer() {
        
        guard let player = self.player else { return }
        
        let events = [PlayerEvent.canPlay, PlayerEvent.pause, PlayerEvent.playing, PlayerEvent.playheadUpdate]
        
        player.addObserver(self, events: events) { [weak self] (event) in
            
            switch event {
            case is PlayerEvent.CanPlay: player.play()
            default:
                break
            }
        }
    }
}

// UI Actions handeling
extension PlayerViewController {
    
    @IBAction func videoSourceChanged(_ sender: UISegmentedControl) {
        
        guard let url = URL(string: videoSources[sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""] ?? ""),
            let player = self.player
            else { return }
        
        player.view = playerView
        
        let source = PKMediaSource("Source_ID", contentUrl: url)
        let entry = PKMediaEntry("Entry_ID", sources: [source])
        
        player.prepare(MediaConfig(mediaEntry: entry, startTime: 0.0))
    }
    
    @IBAction func contentModeChanged(_ sender: UISegmentedControl) {
        
        playerView.contentMode = contentModeItems[sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""] ?? .top
    }
    
}
