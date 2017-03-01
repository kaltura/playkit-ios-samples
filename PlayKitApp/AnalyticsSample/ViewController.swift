//
//  ViewController.swift
//  AnalyticsSample
//
//  Created by Oded Klein on 27/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import AVFoundation
import SwiftyJSON

class ViewController: UIViewController {

    var playerController: Player!

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var durationTimeText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        PlayKitManager.shared.registerPlugin(YouboraPlugin.self)

        setupVideo()
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let controller = self.playerController {
            controller.view.frame = CGRect(origin: CGPoint.zero, size: playerView.frame.size)
        }
    }

    func setupVideo() {
        
        var source = [String : Any]()
        source["id"] = "123123" //"http://media.w3.org/2010/05/sintel/trailer.mp4"
        source["url"] = "http://media.w3.org/2010/05/sintel/trailer.mp4"
        
        var sources = [JSON]()
        sources.append(JSON(source))
        
        var entry = [String : Any]()
        entry["id"] = "Trailer"
        entry["sources"] = sources
        
        let mediaConfig = MediaConfig(mediaEntry: MediaEntry(json: JSON(entry)))
        
        var plugins = [String : AnyObject]()
        
        let analyticsConfig = AnalyticsConfig(params: [:])
        
        plugins[YouboraPlugin.pluginName] = analyticsConfig
        let pluginConfig = PluginConfig(config: plugins)

        do {
            self.playerController = try PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig)
            self.playerController.prepare(mediaConfig)
            playerView.addSubview(self.playerController.view)
            
            self.playerController.addObserver(self, events: [PlayerEvent.canPlay.self, PlayerEvent.play.self], block: {(info) in
                PKLog.debug("Duration: \(self.playerController.duration)")
            })
        } catch let e {
            print("failed with error: \(e)")
        }
        
    }
    
    @IBAction func playClicked(_ sender: AnyObject) {
        self.playerController.play()
    }
    
    @IBAction func pauseClicked(_ sender: AnyObject) {
        self.playerController.pause()
    }
    
    @IBAction func playheadValueChanged(_ sender: AnyObject) {
        if (!sender.isKind(of: UISlider.self)) {
            return
        }
        let slider = sender as! UISlider
        playerController.seek(to: CMTimeMake(Int64(slider.value), 1))
    }

    
}

