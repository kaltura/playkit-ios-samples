//
//  ViewController.swift
//  IMATablePlayerSample
//
//  Created by Nilit Danan on 7/10/18.
//  Copyright © 2018 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit
import PlayKit_IMA

class ViewController: UITableViewController {
    
    var focusedCell: MediaTableViewCell?
    
    var videos: [Media] = [Media(id: "1_9bwuo813",
                                 url: "https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/1_9bwuo813/flavorIds/1_5j0bgx4v,1_x6tlvn4x,1_zj4vzg46/deliveryProfileId/13942/protocol/https/format/applehttp/a.m3u8",
                                 adTagURL: kPrerollTag + Date().description),
                           Media(id: "1_rxwrfdfj",
                                 url: "https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/1_rxwrfdfj/flavorIds/1_o3cxdp9u,1_w29cmwlg,1_mgiii602,1_gzsjh985/deliveryProfileId/13942/protocol/https/format/applehttp/a.m3u8",
                                 adTagURL: kSkippableTag + Date().description),
                           Media(id: "1_11c9ior9",
                                 url: "https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/1_11c9ior9/flavorIds/1_i7g0piuo,1_v7uw7150,1_nnd72o54,1_g6o1b0w8/deliveryProfileId/13942/protocol/https/format/applehttp/a.m3u8",
                                 adTagURL: kPrerollTag + Date().description),
                           Media(id: "1_gjcez3fh",
                                 url: "https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/1_gjcez3fh/flavorIds/1_3fmarl33,1_lm1wzhzo,1_ndpufq2s,1_bft31vyo/deliveryProfileId/13942/protocol/https/format/applehttp/a.m3u8",
                                 adTagURL: kSkippableTag + Date().description),
                           Media(id: "0_7tgcqs6y",
                                 url: "https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/0_7tgcqs6y/flavorIds/0_kwnn6xgi,0_82xweh1c,0_wsifv9ox,0_cjqz8b9d/deliveryProfileId/13942/protocol/https/format/applehttp/a.m3u8",
                                 adTagURL: kPrerollTag + Date().description),
                           Media(id: "0_574u4o4i",
                                 url: "https://cdnapisec.kaltura.com/p/2215841/sp/2215841/playManifest/entryId/0_574u4o4i/flavorIds/0_hhdo8rpj,0_8radsckt/deliveryProfileId/13942/protocol/https/format/applehttp/a.m3u8",
                                 adTagURL: kSkippableTag + Date().description)
                           ]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        focusedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MediaTableViewCell
        focusedCell?.playMedia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath) as! MediaTableViewCell
        
        let media = videos[indexPath.row]
        
        let adsConfig = IMAConfig()
//        adsConfig.enableDebugMode = true
        adsConfig.adTagUrl = media.adTagURL
        
        cell.pluginConfig = PluginConfig(config: [IMAPlugin.pluginName: adsConfig])
        cell.media = media
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.equalTo(CGSize.zero) { return }
        
        if let previouslyFocusedCell = focusedCell, completelyVisible(cell: previouslyFocusedCell) == true {
            return
        }
        
        for cell in tableView.visibleCells {
            if completelyVisible(cell: cell) == true {
                if let previouslyFocusedCell = focusedCell {
                    previouslyFocusedCell.pauseMedia()
                }
                let mediaCell = cell as? MediaTableViewCell
                mediaCell?.playMedia()
                focusedCell = mediaCell
                
                return
            }
        }
    }
    
    func completelyVisible(cell: UITableViewCell) -> Bool {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return false
        }
        
        let cellRect = tableView.rectForRow(at: indexPath)
        let completelyVisible = tableView.bounds.contains(cellRect)
        
        return completelyVisible
    }
}
