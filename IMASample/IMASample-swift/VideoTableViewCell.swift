//
//  VideoTableViewCell.swift
//  IMASample-swift
//
//  Created by Vadik on 07/11/2017.
//  Copyright © 2017 kaltura. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
    
    func populate(with video: Video) {
        videoLabel.text = video.title
        thumbnail.image = video.thumbnail
    }
}
