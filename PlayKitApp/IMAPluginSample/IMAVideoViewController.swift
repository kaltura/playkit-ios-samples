//
//  IMAVideoViewController.swift
//  PlayKitApp
//
//  Created by Vadim Kononov on 08/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import PlayKit

class IMAVideoViewController: UIViewController, AVPictureInPictureControllerDelegate, PlayerDataSource/*, PlayerDelegate*/ {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playheadButton: UIButton!
    @IBOutlet weak var playheadTimeText: UITextField!
    @IBOutlet weak var durationTimeText: UITextField!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var pictureInPictureButton: UIButton!
    @IBOutlet weak var companionView: UIView!
    
    var pipEnabled: Bool = kAllowAVPlayerExpose
    var video: Video!
    var playerController: Player!
    var pictureInPictureController: AVPictureInPictureController?
    
    enum PlayButtonType: Int {
        case playButton = 0
        case pauseButton = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.text = video.title as String
        
        setUpContentPlayer()
        setupPiP()
        
        if kAutoStartPlayback {
            self.playContent()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.playerController.pause()
        // Don't reset if we're presenting a modal view (e.g. in-app clickthrough).
        if ((navigationController!.viewControllers as NSArray).index(of: self) == NSNotFound) {
            //self.playerController.destroy()
            self.playerController = nil
        }
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !kAutoStartPlayback {
            let btn = UIButton(frame: CGRect(x: videoView.frame.size.width / 2 - 30, y: videoView.frame.size.height / 2 - 30, width: 60, height: 60))
            btn.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
            btn.layer.borderColor = UIColor.blue.cgColor
            btn.layer.borderWidth = 2
            btn.addTarget(self, action: #selector(IMAVideoViewController.onPlayPressed), for: UIControlEvents.touchUpInside)
            videoView.addSubview(btn)
            
            playheadButton.isEnabled = false
        }
    }
    
    // MARK: Set-up methods
    
    func setUpContentPlayer() {
        let config = PlayerConfig()
        
        if kUseIMA {
            /*let adsPluginData: PluginData!
            if video.tag != "" {
                adsPluginData = PluginData(plugin: PluginType.Ads, data: video.tag as AnyObject?)
            } else {
                adsPluginData = PluginData(plugin: PluginType.Ads, data: video.tagsTimes as AnyObject?)
            }
            
            config.plugins = [adsPluginData]*/
            PlayKitManager.sharedInstance.registerPlugin(AdsPlugin.self)
        }
        
        config.autoPlay = kAutoStartPlayback
        
        self.playerController = PlayKitManager.sharedInstance.createPlayer(config: config)
        self.playerController.dataSource = self
  //      self.playerController.delegate = self
        
        self.playerController.layer.frame = videoView.layer.bounds
        videoView.layer.addSublayer(self.playerController.layer)
        if self.playerController.load(config) {
            
        }
        
        /*self.playerController.subscribe(to: PlayerEventType.playhead_state_changed, using: { (eventData: AnyObject?) -> Void in
            self.updatePlayhead(with: (eventData as! KalturaPlayerEventData).currentTime, duration: (eventData as! KalturaPlayerEventData).duration)
        })*/
    }
    
    func setupPiP() {
        /*pictureInPictureController = self.playerController.createPiPController(with: self)
        if (!AVPictureInPictureController.isPictureInPictureSupported() && pictureInPictureButton != nil) {
            pictureInPictureButton.isHidden = true;
        }*/
    }
    
    func onPlayPressed(_ sender: UIButton) {
        sender.isHidden = true
        self.playContent()
    }
    
    func playContent() {
        playheadButton.isEnabled = true
        
        self.playerController.play()
        setPlayButtonType(PlayButtonType.pauseButton)
    }
    
    //MARK - outlet actions
    
    @IBAction func onPlayPauseClicked(_ sender: AnyObject) {
        if (playheadButton.tag == PlayButtonType.playButton.rawValue) {
            //self.playerController.resume()
            setPlayButtonType(PlayButtonType.pauseButton)
        } else {
            self.playerController.pause()
            setPlayButtonType(PlayButtonType.playButton)
        }
    }
    
    @IBAction func playheadValueChanged(_ sender: AnyObject) {
        if (!sender.isKind(of: UISlider.self)) {
            return
        }
        let slider = sender as! UISlider
        //playerController.seek(to: CMTimeMake(Int64(slider.value), 1))
    }
    
    @IBAction func onPipButtonClicked(_ sender: AnyObject) {
        if (pictureInPictureController!.isPictureInPictureActive) {
            pictureInPictureController!.stopPictureInPicture();
        } else if pipEnabled {
            pictureInPictureController!.startPictureInPicture();
        }
    }
    
    //MARK - private methods
    
    fileprivate func setPlayButtonType(_ buttonType: PlayButtonType) {
        playheadButton.tag = buttonType.rawValue
        playheadButton.setImage(UIImage(named: buttonType == PlayButtonType.pauseButton ? "pause.png" : "play.png"), for: UIControlState())
    }
    
    fileprivate func updatePlayhead(with time: CMTime, duration: CMTime) {
        if (!time.isValid) {
            return
        }
        let currentTime = CMTimeGetSeconds(time)
        if (currentTime.isNaN) {
            return
        }
        
        if (!duration.isValid) {
            return
        }
        let durationValue = CMTimeGetSeconds(duration)
        if (durationValue.isNaN) {
            return
        }
        progressBar.maximumValue = Float(durationValue)
        progressBar.value = Float(currentTime)
        
        playheadTimeText.text = NSString(format: "%d:%02d", Int(currentTime / 60), Int(currentTime.truncatingRemainder(dividingBy: 60))) as String
        durationTimeText.text = NSString(format: "%d:%02d", Int(durationValue / 60), Int(durationValue.truncatingRemainder(dividingBy: 60))) as String
    }
    
    //MARK: Player DataSource and Delegate methods
    
    func playerVideoView(_ player: Player) -> UIView {
        return videoView
    }
    
    func playerCanPlayAd(_ player: Player) -> Bool {
        return pictureInPictureController == nil || !pictureInPictureController!.isPictureInPictureActive
    }
    
    func player(_ player: Player, adDidProgressToTime mediaTime: TimeInterval, totalTime: TimeInterval) {
        let time = CMTimeMakeWithSeconds(mediaTime, 1000)
        let duration = CMTimeMakeWithSeconds(totalTime, 1000)
        self.updatePlayhead(with: time, duration: duration)
    }
    
    func playerAdDidRequestContentPause(_ player: Player) {
        pipEnabled = kAllowAVPlayerExpose ? true : false
        progressBar.isEnabled = false
    }
    
    func playerAdDidRequestContentResume(_ player: Player) {
        pipEnabled = true
        progressBar.isEnabled = true
    }
}
