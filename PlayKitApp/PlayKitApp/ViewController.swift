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
    
    
    func mediaEntry() -> MediaEntry? {
        
        let mp4 : [String:Any] = [
            "id": "src1",
            "url": "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
            ]

        let hls : [String:Any] = [
            "id": "src2",
            "url": "https://cdnapisec.kaltura.com/p/243342/playManifest/entryId/1_sf5ovm7u/format/applehttp/protocol/https/a/a.m3u8",
        ]

        let entry : [String:Any] = [
            "id": "ent1",
            "sources": [hls],
        ]

        return MediaEntry(json: entry)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //PlayKitManager.sharedInstance.registerPlugin(SamplePlugin.self)
        let config = PlayerConfig()
        
        guard let mediaEntry = self.mediaEntry() else {
            return
        }

        config.set(mediaEntry: mediaEntry)
        
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

