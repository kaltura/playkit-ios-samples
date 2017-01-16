//
//  ViewController.swift
//  SamplePlugin
//
//  Created by Eliza Sapir on 16/01/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayKitManager.sharedInstance.registerPlugin(SamplePlugin.self)
        
        // Create PlayerConfig
        let config = PlayerConfig()
        
        //sample
        var source = [String : Any]()
        source["id"] = "123123" //"http://media.w3.org/2010/05/sintel/trailer.mp4"
        source["url"] = "http://media.w3.org/2010/05/sintel/trailer.mp4"
        
        var sources = [JSON]()
        sources.append(JSON(source))
        
        var entry = [String : Any]()
        entry["id"] = "Trailer"
        entry["sources"] = sources
        
        config.set(mediaEntry: MediaEntry(json: JSON(entry)))//.set(allowPlayerEngineExpose: kAllowAVPlayerExpose)
        //
        
        var plugins = [String : AnyObject?]()
        
        let samplePluginConfig = SamplePluginConfig()
        samplePluginConfig.data = "sample"
        
        plugins[SamplePlugin.pluginName] = samplePluginConfig
        config.plugins = plugins
        
        _ = PlayKitManager.sharedInstance.loadPlayer(config: config)

    }
}

