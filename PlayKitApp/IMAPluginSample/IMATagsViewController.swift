//
//  IMATagsViewController.swift
//  PlayKitApp
//
//  Created by Vadim Kononov on 08/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import AVFoundation
import PlayKit

var kAutoStartPlayback = true
var kUseIMA = true
var kAllowAVPlayerExpose = false

class IMATagsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Storage point for videos.
    var videos: NSArray!
    var language: NSString!
    var settings: [[String : Bool]]!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Set up the app.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = "en"
        initVideos()
        
        PlayKitManager.sharedInstance.registerPlugin(IMAPlugin.self)

        // For PiP.
        do {
            try AVAudioSession.sharedInstance().setActive(true);
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback);
        } catch {
            NSLog("Error setting background playback - PiP will not work.")
        }
    }
    
    // Populate the video array.
    func initVideos() {
        let dfpThumbnail = UIImage(named: "bunny.png")
        let bipThumbnail = UIImage(named: "bip.png")
        
        var tagsTimes = [TimeInterval : String]()
        tagsTimes[10] = kSkippableTag
        tagsTimes[20] = kSkippableTag
        tagsTimes[30] = kSkippableTag
        
        videos = [
            Video(
                title: "Pre-roll + mp4",
                thumbnail: dfpThumbnail,
                video: kDFPContentPath,
                tag: kPrerollTag,
                tagsTimes: nil),
            Video(
                title: "Pre-roll + m3u8",
                thumbnail: bipThumbnail,
                video: kBipBopContentPath,
                tag: kPrerollTag,
                tagsTimes: nil),
            Video(
                title: "Pre,Mid&Post-roll + mp4",
                thumbnail: dfpThumbnail,
                video: kDFPContentPath,
                tag: kAdRulesTag,
                tagsTimes: nil),
            Video(
                title: "Pre,Mid&Post-roll + m3u8",
                thumbnail: bipThumbnail,
                video: kBipBopContentPath,
                tag: kAdRulesTag,
                tagsTimes: nil),
            Video(
                title: "Post-roll + mp4",
                thumbnail: dfpThumbnail,
                video: kDFPContentPath,
                tag: kPostrollTag,
                tagsTimes: nil),
            Video(
                title: "Post-roll + m3u8",
                thumbnail: bipThumbnail,
                video: kBipBopContentPath,
                tag: kPostrollTag,
                tagsTimes: nil),
            Video(
                title: "Cue-points + mp4",
                thumbnail: dfpThumbnail,
                video: kDFPContentPath,
                tag: "",
                tagsTimes: tagsTimes),
            Video(
                title: "Cue-points + m3u8",
                thumbnail: bipThumbnail,
                video: kBipBopContentPath,
                tag: "",
                tagsTimes: tagsTimes)
        ]
        
        settings = [["auto start playback": kAutoStartPlayback], ["use ima": kUseIMA], ["allow av player expose": kAllowAVPlayerExpose]]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showVideo") {
            let indexPath: IndexPath! = tableView.indexPathForSelectedRow
            if (indexPath != nil) {
                let video = videos[indexPath.row] as! Video
                let headedTo = segue.destination as! IMAVideoViewController
                headedTo.video = video
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if (tableView.indexPathForSelectedRow != nil) {
            return true
        }
        return false
    }
    
    // Only allow one selection.
    func numberOfSections(in tableView: UITableView) -> NSInteger {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        return tableView.tag == 1 ? 60 : 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        let label = UILabel(frame: CGRect(x: 12, y: 7, width: 200, height: 21))
        label.text = section == 0 ? "Settings" : "Videos"
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let currentValue = Array(settings[indexPath.row].values).first!
            let newValue = !currentValue
            let currentKey = Array(settings[indexPath.row].keys).first!
            settings[indexPath.row].updateValue(newValue, forKey: currentKey)
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            if currentKey == "auto start playback" {
                kAutoStartPlayback = newValue
            } else if currentKey == "use ima" {
                kUseIMA = newValue
            } else if currentKey == "allow av player expose" {
                kAllowAVPlayerExpose = newValue
            }
        }
    }
    
    // Returns the number of items to be presented in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settings.count
        }
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! IMASettingsTableViewCell
            cell.populate(Array(settings[indexPath.row].keys).first!, isSelected: Array(settings[indexPath.row].values).first!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IMAVideoTableViewCell
            cell.populateWithVideo(videos[(indexPath as NSIndexPath).row] as! Video)
            return cell
        }
    }
}
