//
//  SettingsViewController.swift
//  PlayKitAppleTVSample
//
//  Created by Gal Orlanczyk on 24/05/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var textFieldStartTime: UITextField!
    @IBOutlet weak var segmentedControlAutoplay: UISegmentedControl!
    
    var playerSettings: PlayerSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentedControlAutoplay.selectedSegmentIndex = playerSettings.autoplay ? 1 : 0
        self.textFieldStartTime.text = "\(Int(playerSettings.startTime))"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.playerSettings.autoplay = self.segmentedControlAutoplay.selectedSegmentIndex == 1
        if let text = self.textFieldStartTime.text, let startTime = TimeInterval(text) {
            self.playerSettings.startTime = startTime
        }
    }
}
