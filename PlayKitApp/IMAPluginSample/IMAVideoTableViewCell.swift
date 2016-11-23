//
//  IMAVideoTableViewCell.swift
//  PlayKitApp
//
//  Created by Vadim Kononov on 08/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit

class IMAVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
    
    func populateWithVideo(_ video: Video) {
        videoLabel.text = video.title
        thumbnail.image = video.thumbnail
    }

}
