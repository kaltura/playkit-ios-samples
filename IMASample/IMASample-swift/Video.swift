//
//  Video.swift
//  IMASample-swift
//
//  Created by Vadik on 07/11/2017.
//  Copyright © 2017 kaltura. All rights reserved.
//

import UIKit

public class Video {
    var title: String
    var thumbnail: UIImage
    var tag: String?
    var adsResponse: String?
    
    init(title: String, thumbnail: UIImage, tag: String? = "", adsResponse: String? = "") {
        self.title = title
        self.thumbnail = thumbnail
        self.tag = tag
        self.adsResponse = adsResponse
    }
}
