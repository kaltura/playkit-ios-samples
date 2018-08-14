//
//  MediaTableViewController.swift
//  VRSample
//
//  Created by Nilit Danan on 6/6/18.
//  Copyright © 2018 Kaltura. All rights reserved.
//

import Foundation
import UIKit

class MediaTableViewController: UITableViewController {
    
    var mediaArray: Array<MediaData> = []
    
    override func viewDidLoad() {
        mediaArray.append(MediaData(serverURL: "http://cdnapi.kaltura.com", partnerId: 1424501, entryId: "0_a54foq3g"))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MediaTableViewCell")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PlayMediaSegue":
            guard let playerVC = segue.destination as? ViewController else { return }
            guard let cell = sender as? UITableViewCell else { return }
            guard let index = tableView.indexPath(for: cell)?.row else { return }
            playerVC.mediaData = mediaArray[index]
        default:
            return
        }
    }
    
    //MARK: - UITableViewDataSource
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath)
        
        let mediaData = mediaArray[indexPath.row]
        cell.textLabel?.text = "PartnerId: \(mediaData.partnerId) EntryId: \(mediaData.entryId)"
        cell.detailTextLabel?.text = "\(mediaData.serverURL)"
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "PlayMediaSegue", sender: tableView.cellForRow(at: indexPath))
    }
}

