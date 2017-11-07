//
//  VideoViewController.swift
//  IMASample-swift
//
//  Created by Vadik on 07/11/2017.
//  Copyright © 2017 kaltura. All rights reserved.
//

import UIKit
import PlayKit

class VideoViewController: UIViewController {

    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    var player: Player?
    var video: Video?
    var mediaConfig: MediaConfig?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        player?.view = playerContainer
        if let _ = mediaConfig {
            player?.prepare(mediaConfig!)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.stop()
    }
    
    @objc func playheadUpdate() {
        if let _ = player {
            playheadSlider.value = Float(player!.currentTime / player!.duration)
        }
    }
    
    @IBAction func didSeek(_ sender: UISlider) {
        print("playhead value: \(sender.value)")
        if let _ = player {
            player!.currentTime = player!.duration * TimeInterval(sender.value)
        }
    }
    
    @IBAction func didTapPlay(_ sender: UIButton) {
        if player?.isPlaying == false {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playheadUpdate), userInfo: nil, repeats: true)
            player?.play()
        }
    }
    
    @IBAction func didTapPause(_ sender: UIButton) {
        if player?.isPlaying == true {
            timer?.invalidate()
            timer = nil
            player?.pause()
        }
    }
}
