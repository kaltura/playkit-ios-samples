//
//  VideoData.swift
//  IMADAISample-Swift
//
//  Created by Nilit Danan on 2/24/19.
//  Copyright © 2019 Kaltura Inc. All rights reserved.
//

import Foundation
import PlayKit_IMA

struct VideoData {
    var title: String
    var entryID: String
    var baseURL: String
    var ks: String?
    var partnerID: Int
    var assetTitle: String
    var assetKey: String? // Live
    var contentSourceId: String? // VOD
    var videoId: String? // VOD
    var autoPlay: Bool = false
    var startPosition: Double = 0
    var streamType: PKIMADAIStreamType = .vod
    var alwaysStartWithPreroll: Bool = false
}
