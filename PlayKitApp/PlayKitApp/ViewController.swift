//
//  ViewController.swift
//  PlayKitApp
//
//  Created by Eliza Sapir on 06/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import SwiftyJSON

class ViewController: UIViewController {
    var player : Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //PlayKitManager.sharedInstance.registerPlugin(SamplePlugin.self)
        let config = PlayerConfig()
        
        var source = [String : Any]()
        source["id"] = "test"
        source["url"] = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        
        var sources = [JSON]()
        sources.append(JSON(source))
        
        var entry = [String : Any]()
        entry["id"] = "test"
        entry["sources"] = sources
        
        config.set(mediaEntry: MediaEntry(json: JSON(entry)))
        
        self.player = PlayKitManager.sharedInstance.loadPlayer(config:config)
        self.player.view.frame = playerContainer.bounds
        self.playerContainer.addSubview(player.view)
    }

    @IBOutlet weak var playerContainer: UIView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
      //  self.player.play()
    }
    @IBAction func playClicked(_ sender: AnyObject) {
        self.player.play()
    }
}

