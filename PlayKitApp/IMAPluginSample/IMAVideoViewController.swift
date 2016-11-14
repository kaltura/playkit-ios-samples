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

class IMAVideoViewController: UIViewController, AVPictureInPictureControllerDelegate, PlayerDataSource, PlayerDelegate {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playheadButton: UIButton!
    @IBOutlet weak var playheadTimeText: UITextField!
    @IBOutlet weak var durationTimeText: UITextField!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var pictureInPictureButton: UIButton!
    @IBOutlet weak var companionView: UIView!
    
    var pipEnabled: Bool = true
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
        
        pipEnabled = configAllowsPiP()
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
            self.playerController.destroy()
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
        
        let mock = MockMediaEntryProvider(video.title)
        mock.addSource(video.title, contentUrl: video.video)
        
        config.set(mediaEntry: mock.mediaEntry!).set(allowPlayerEngineExpose: kAllowAVPlayerExpose)
        
        if kUseIMA {
            var plugins = [String : AnyObject?]()
            if video.tag != "" {
                plugins[AdsPlugin.pluginName] = video.tag as AnyObject?
            } else {
                plugins[AdsPlugin.pluginName] = video.tagsTimes as AnyObject?
                pipEnabled = true
            }
            
            config.plugins = plugins
        }
        
        do {
            try self.playerController = PlayKitManager.sharedInstance.loadPlayer(config: config)
        } catch PlayKitError.multipleDecoratorsDetected {
            print("multipleDecoratorsDetected")
        } catch {
            print("error")
        }
        
        self.playerController.dataSource = self
        self.playerController.delegate = self
        
        self.playerController.view.frame = CGRect(origin: CGPoint.zero, size: videoView.frame.size)
        videoView.addSubview(self.playerController.view)
        
        
        /*self.playerController.subscribe(to: PlayerEventType.playhead_state_changed, using: { (eventData: AnyObject?) -> Void in
            self.updatePlayhead(with: (eventData as! KalturaPlayerEventData).currentTime, duration: (eventData as! KalturaPlayerEventData).duration)
        })*/
    }
    
    func setupPiP() {
        pictureInPictureController = self.playerController.createPiPController(with: self)
        if (!AVPictureInPictureController.isPictureInPictureSupported() && pictureInPictureButton != nil) {
            pictureInPictureButton.isHidden = true;
        }
    }
    
    func configAllowsPiP() -> Bool {
        return kAllowAVPlayerExpose || !kUseIMA
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
            self.playerController.resume()
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
        playerController.seek(to: CMTimeMake(Int64(slider.value), 1))
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
        
    func playerCanPlayAd(_ player: Player) -> Bool {
        return kAllowAVPlayerExpose || pictureInPictureController == nil || !pictureInPictureController!.isPictureInPictureActive
    }
    
    public func playerCompanionView(_ player: Player) -> UIView? {
        return nil
    }
    
    public func playerAdWebOpenerPresentingController(_ player: Player) -> UIViewController? {
        return nil
    }
    
    func player(_ player: Player, didReceive event: PlayerEventType, with eventData: Any?) {
        if event == PlayerEventType.ad_did_progress_to_time {
            if let data = eventData as? [String : TimeInterval] {
                let time = CMTimeMakeWithSeconds(data["mediaTime"]!, 1000)
                let duration = CMTimeMakeWithSeconds(data["totalTime"]!, 1000)
                self.updatePlayhead(with: time, duration: duration)
            }
        } else if event == PlayerEventType.ad_did_pause {
            pipEnabled = configAllowsPiP() ? true : false
            progressBar.isEnabled = false
        } else if event == PlayerEventType.ad_did_resume {
            pipEnabled = true
            progressBar.isEnabled = true
        }
    }
    
    func player(_ player: Player, failedWith error: String) {
    }
}
