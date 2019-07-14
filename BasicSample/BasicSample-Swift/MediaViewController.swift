//
//  MediaViewController.swift
//  BasicSample-Swift
//
//  Created by Nilit Danan on 7/13/19.
//  Copyright © 2019 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import PlayKitUI

class MediaViewController: UIViewController {
    
    var mediaEntry: PKMediaEntry?
    
    @IBOutlet weak var pkMediaPlayer: PKMediaPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pkMediaPlayer.mediaEntry = mediaEntry
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
