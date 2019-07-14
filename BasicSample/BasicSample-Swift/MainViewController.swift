//
//  MainViewController.swift
//  BasicSample-Swift
//
//  Created by Nilit Danan on 7/13/19.
//  Copyright © 2019 Kaltura. All rights reserved.
//

import UIKit
import AVKit
import PlayKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var videos: [VideoData] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initVideos()
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {
            
        }
    }
    
    func initVideos() {
        
        videos.append(VideoData(title: "sintel",
                                entryID: "sintel",
                                contentURL: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let videoData = videos[indexPath.row]
                
                let source = PKMediaSource(videoData.entryID,
                                           contentUrl: URL(string: videoData.contentURL),
                                           drmData: nil,
                                           mediaFormat: .hls)
                let mediaEntry = PKMediaEntry(videoData.entryID, sources: [source], duration: -1)
                
                if let videoVC = segue.destination as? MediaViewController {
                    videoVC.mediaEntry = mediaEntry
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = videos[indexPath.row].title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
