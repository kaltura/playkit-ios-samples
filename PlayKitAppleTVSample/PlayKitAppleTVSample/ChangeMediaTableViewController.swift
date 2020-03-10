//
//  ChangeMediaTableViewController.swift
//  PlayKitAppleTVSample
//
//  Created by Nilit Danan on 3/1/20.
//  Copyright © 2020 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import PlayKit_IMA

class ChangeMediaTableViewController: UITableViewController {
    
    var player: Player?
    var playerSettings: PlayerSettings?
    var medias: [Media]?
    
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = medias?[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if activityIndicatorView.isAnimating { return }
        activityIndicatorView.startAnimating()
        
        guard let media = medias?[indexPath.row] else {
            activityIndicatorView.stopAnimating()
            return
        }
        
        player?.stop()
        media.mediaConfig(startTime: playerSettings?.startTime ?? 0, completionHandler: { [weak self] (mediaConfig) in
            guard let self = self else { return }
            self.activityIndicatorView.stopAnimating()
            guard let mc = mediaConfig else { return }
            
            // IMA Config
            let imaConfig = IMAConfig()
            imaConfig.playerVersion = PlayKitManager.versionString
            if var adTagURL = media.adTag?.rawValue, !adTagURL.isEmpty, adTagURL.hasSuffix("correlator=") {
                adTagURL += Date().description
                imaConfig.adTagUrl = adTagURL
            }
            
            self.player?.updatePluginConfig(pluginName: IMAPlugin.pluginName, config: imaConfig)
            self.player?.prepare(mc)
            if self.playerSettings?.autoplay == true {
                self.player?.play()
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
