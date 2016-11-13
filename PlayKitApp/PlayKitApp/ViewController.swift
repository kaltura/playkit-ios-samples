//
//  ViewController.swift
//  PlayKitApp
//
//  Created by Eliza Sapir on 06/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import PlayKit

class ViewController: UIViewController {
    var player : Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //PlayKitManager.sharedInstance.registerPlugin(SamplePlugin.self)
        let config = PlayerConfig()
        let mock = MockMediaEntryProvider("test")
        mock.addSource("test", contentUrl: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        config.set(mediaEntry: mock.mediaEntry!)
        
        do {
            try self.player = PlayKitManager.sharedInstance.loadPlayer(config:config)
        } catch PlayKitError.multipleDecoratorsDetected {
            print("multipleDecoratorsDetected")
        } catch {
            print("error")
        }
        
        self.player.layer.backgroundColor = UIColor.red.cgColor
        self.player.layer.frame = playerContainer.bounds
        self.playerContainer.layer.addSublayer(player.layer)
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

