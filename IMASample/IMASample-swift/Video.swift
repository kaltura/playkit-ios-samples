//
//  Video.swift
//  IMASample-swift
//
//  Created by Vadik on 07/11/2017.
//  Copyright © 2017 kaltura. All rights reserved.
//

import PlayKit

public class Video {
    var title: String
    var thumbnail: UIImage
    var tag: String
    var urlString: String
    var type: MediaType
    
    init(title: String, thumbnail: UIImage, tag: String, urlString: String, type: MediaType = .unknown) {
        self.title = title
        self.thumbnail = thumbnail
        self.tag = tag
        self.urlString = urlString
        self.type = type
    }
}
