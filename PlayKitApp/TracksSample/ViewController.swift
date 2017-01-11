//
//  ViewController.swift
//  TracksSample
//
//  Created by Eliza Sapir on 04/12/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import AVFoundation

class ViewController: UIViewController {
    
    var playerController: Player!
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var durationTimeText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVideo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let controller = self.playerController {
            controller.view.frame = CGRect(origin: CGPoint.zero, size: playerView.frame.size)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupVideo() {
        
        let config = PlayerConfig()
        
        var source = [String : Any]()
        source["id"] = "123123" //"http://media.w3.org/2010/05/sintel/trailer.mp4"
        source["url"] = "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
       // source["url"] = "http://cdnapi.kaltura.com/p/243342/sp/24334200/playManifest/entryId/0_uka1msg4/flavorIds/1_vqhfu6uy,1_80sohj7p/format/applehttp/protocol/http/a.m3u8"
        var sources = [JSON]()
        sources.append(JSON(source))
        
        var entry = [String : Any]()
        entry["id"] = "Trailer"
        entry["sources"] = sources
        
        config.set(mediaEntry: MediaEntry(json: JSON(entry)))//.set(allowPlayerEngineExpose: kAllowAVPlayerExpose)
        
        self.playerController = PlayKitManager.sharedInstance.loadPlayer(config: config)
        playerView.addSubview(self.playerController.view)
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

