//
//  ViewController.swift
//  AppAnalyticsSample
//
//  Created by Noam Tamim on 01/04/2018.
//

import UIKit
import PlayKit


class PlayerAnalyticsCollector {
    let engine: Any
    
    init(_ engine: Any) {
        self.engine = engine
    }
    
    func register(player: Player?) {
        guard let player = player else { return }
        
        player.addObserver(self, events: [PlayerEvent.canPlay, PlayerEvent.stopped, PlayerEvent.ended, PlayerEvent.play, PlayerEvent.pause, PlayerEvent.playing, PlayerEvent.seeking, PlayerEvent.seeked]) { (event) in
            print("Basic Event:", event)
        }
        
        player.addObserver(self, event: PlayerEvent.sourceSelected) { (event) in
            print("Source selected: ", event.mediaSource!)
        }
        
        player.addObserver(self, events: [PlayerEvent.tracksAvailable, PlayerEvent.videoTrackChanged, PlayerEvent.audioTrackChanged, PlayerEvent.textTrackChanged]) { (event) in
            if type(of: event) == PlayerEvent.tracksAvailable {
                print("Tracks:", event.tracks)
            }
        }
        
        player.addPeriodicObserver(interval: 1, observeOn: DispatchQueue.main) { (time) in
            print("Playback time:", time)
        }
        
        player.addObserver(self, event: PlayerEvent.stateChanged) { (event) in
            print("State changed from", event.oldState.rawValue, "to", event.newState.rawValue)
        }
        
        player.addObserver(self, events: [PlayerEvent.durationChanged, PlayerEvent.timedMetadata]) { (event) in
            if let duration = event.duration {
                print("Duration:", duration)
            }
        }
        
        player.addObserver(self, events: AdEvent.allEventTypes) { (event) in
            // <#code#>
        }
    }
}

class ViewController: UIViewController {
    
    var player: Player?
    @IBOutlet var playerContainer: UIView!
    var playerView: PlayerView!
    
    let collector = PlayerAnalyticsCollector(NSObject())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        PKLog.enabled = false
        
        setupPlayer()
        
        collector.register(player: self.player)
        
        loadMedia()
    }
    
    func setupPlayer() {
        guard let player = try? PlayKitManager.shared.loadPlayer(pluginConfig: nil) else { return }
        
        self.playerView = PlayerView.init(frame: playerContainer.bounds)
        playerContainer.addSubview(playerView)
        player.view = self.playerView
        
        self.player = player
    }
    
    func loadMedia() {
        let player = self.player
        OVPMediaProvider.init(SimpleOVPSessionProvider(serverURL: "https://cdnapisec.kaltura.com", partnerId: 2215841, ks: nil))
            .set(entryId: "1_cl4ic86v")
            .loadMedia { (entry, error) in
                
                if let entry = entry {
                    player?.prepare(MediaConfig.config(mediaEntry: entry))
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playTapped() {
        player?.play()
    }

    @IBAction func pauseTapped() {
        player?.pause()
    }
    
}

