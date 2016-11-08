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
        
        PlayKitManager.sharedInstance.registerPlugin(SamplePlugin.self)
        let config = PlayerConfig()
        self.player = PlayKitManager.sharedInstance.createPlayer(config:config)
        
        self.player.layer.backgroundColor = UIColor.red.cgColor
        self.player.layer.frame = playerContainer.bounds
        self.playerContainer.layer.addSublayer(player.layer)
        self.player.load(config)
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

