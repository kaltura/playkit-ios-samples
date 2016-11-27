//
//  ViewController.swift
//  AnalyticsSample
//
//  Created by Oded Klein on 27/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import SwiftyJSON

class ViewController: UIViewController {

    var playerController: Player!

    @IBOutlet weak var playerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupVideo()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupVideo() {
        
        let config = PlayerConfig()
        
        var source = [String : Any]()
        source["id"] = "123123" //"http://media.w3.org/2010/05/sintel/trailer.mp4"
        source["url"] = "http://media.w3.org/2010/05/sintel/trailer.mp4"
        
        var sources = [JSON]()
        sources.append(JSON(source))
        
        var entry = [String : Any]()
        entry["id"] = "Trailer"
        entry["sources"] = sources
        
        config.set(mediaEntry: MediaEntry(json: JSON(entry)))//.set(allowPlayerEngineExpose: kAllowAVPlayerExpose)
        
        var plugins = [String : AnyObject?]()
        
        let analyticsConfig = AnalyticsConfig()
        
        
        plugins[YouboraPlugin.pluginName] = analyticsConfig
        config.plugins = plugins

        
        self.playerController = PlayKitManager.sharedInstance.loadPlayer(config: config)
        playerView.addSubview(self.playerController.view)

        
    }
    
    @IBAction func playClicked(_ sender: AnyObject) {
        self.playerController.play()
    }
    
    
    
    
    
}

