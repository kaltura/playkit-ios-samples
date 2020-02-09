//
//  ViewController.swift
//  TablePlayerSample
//
//  Created by Nilit Danan on 11/13/19.
//  Copyright © 2018 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit

enum ScrollDirection {
    case up
    case down
}

class ViewController: UITableViewController, MediaTableViewCellDelegate {
    
    var focusedCell: MediaTableViewCell?

    // Medias with flavers
    var videos: [OVPMedia] = [OVPMedia(partnerId: 2215841, entryId: "1_j09ivavh", autoBuffer: true, autoPlay: true),
                              OVPMedia(partnerId: 2215841, entryId: "1_9bwuo813"),
                              OVPMedia(partnerId: 2215841, entryId: "0_axrfacp3"),
                              OVPMedia(partnerId: 2215841, entryId: "1_cl4ic86v")]
    
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .down
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        focusedCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MediaTableViewCell
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
        
        cell.delegate = self
        cell.media = media
        
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            // swipes from top to bottom of screen -> down
            scrollDirection = .up
        } else {
            // swipes from bottom to top of screen -> up
            scrollDirection = .down
        }
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
    
    // MARK: - MediaTableViewCellDelegate
    
    func startedPlayingMedia(_ cell: MediaTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // Depending on the scroll direction once receiving that the focused cell is playing, start buffering the next cell.
        var nextRow = indexPath.row
        switch scrollDirection {
        case .up:
            nextRow -= 1
        case .down:
            nextRow += 1
        }
        if let nextCell = tableView.cellForRow(at: IndexPath(row: nextRow, section: indexPath.section)) as? MediaTableViewCell {
            nextCell.startBuffering()
        }
    }
}
