//
//  VideoData.swift
//  PhoenixAnalyticsSample-Swift
//
//  Created by Nilit Danan on 7/17/19.
//  Copyright © 2019 Kaltura. All rights reserved.
//

import Foundation
import PlayKitProviders

struct VideoData {
    var partnerID: Int
    var serverURL: String
    var ks: String?
    var assetId: String
    var epgId: String? // optional for live /var assetId: String live Dvr
    var assetType: AssetType
    var assetRefType: AssetReferenceType
    var assetPlaybackContextType: PlaybackContextType
    var formats: [String]?
    var fileIds: [String]?
    var networkProtocol: String?
    var referrer: String?
}
