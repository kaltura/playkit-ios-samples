//
//  AppDelegate.swift
//  PlayKit_PiP
//
//  Created by Sergii Chausov on 03.08.2020.
//  Copyright © 2020 Kaltura. All rights reserved.
//

import UIKit
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let audioSession = AVAudioSession.sharedInstance()
        do {
           try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        return true
    }
    
}

