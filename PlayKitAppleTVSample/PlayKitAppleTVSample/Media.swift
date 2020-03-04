//
//  Media.swift
//  PlayKitAppleTVSample
//
//  Created by Nilit Danan on 3/1/20.
//  Copyright © 2020 Kaltura. All rights reserved.
//

import Foundation
import PlayKit
import PlayKitProviders

enum MediaType: Int, CustomStringConvertible {
    case basic = 0
    case ovp
    case ott
    
    var description: String {
        switch self {
        case .basic:
            return "Basic"
        case .ovp:
            return "OVP"
        case .ott:
            return "OTT"
        }
    }
}

class Media: NSObject {
    var mediaType: MediaType = .basic
    var id: String
    var url: String
    var adTag: IMAAdTag?
    
    init(id: String, contentUrl: String, adTag: IMAAdTag? = nil) {
        self.id = id
        self.url = contentUrl
        self.adTag = adTag
    }
    
    override var description: String {
        let adTagString: String = adTag == nil ? "" : "\(adTag?.description ?? ""), "
        return "\(mediaType.description), \(id), \(adTagString)\(url)"
    }
    
    func mediaConfig(startTime: TimeInterval, completionHandler: @escaping (MediaConfig?) -> Void) {
        let mediaSource = PKMediaSource(id, contentUrl: URL(string: url))
        let mediaEntry = PKMediaEntry(id, sources: [mediaSource])
        completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: startTime))
    }
}

class OVPMedia: Media {
    var partnerId: Int64
    
    init(entryId: String, baseUrl: String, partnerId: Int64, adTag: IMAAdTag? = nil) {
        self.partnerId = partnerId
        super.init(id: entryId, contentUrl: baseUrl, adTag: adTag)
        self.mediaType = .ovp
    }
    
    override var description: String {
        let adTagString: String = adTag == nil ? "" : "\(adTag?.description ?? ""), "
        return "\(mediaType.description), \(partnerId), \(id), \(adTagString)\(url)"
    }
    
    override func mediaConfig(startTime: TimeInterval, completionHandler: @escaping (MediaConfig?) -> Void) {
        let sessionProvider = SimpleSessionProvider(serverURL: url, partnerId: partnerId, ks: nil)
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        mediaProvider.entryId = id
        mediaProvider.loadMedia { (pkMediaEntry, error) in
            guard let mediaEntry = pkMediaEntry else { return }
            completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: startTime))
        }
    }
}

class OTTMedia: Media {
    var partnerId: Int64
    var formats: [String]?
    var networkProtocol: String?
    
    init(assetId: String, serverURL: String, partnerId: Int64, adTag: IMAAdTag? = nil, formats: [String]? = nil, networkProtocol: String? = nil) {
        self.partnerId = partnerId
        self.formats = formats
        self.networkProtocol = networkProtocol
        super.init(id: assetId, contentUrl: serverURL, adTag: adTag)
        self.mediaType = .ott
    }
    
    override var description: String {
        let format: String = formats?.isEmpty == true ? "" : "\(String(describing: formats)), "
        let adTagString: String = adTag == nil ? "" : "\(adTag?.description ?? ""), "
        return "\(mediaType.description), \(partnerId), \(id), \(adTagString)\(networkProtocol ?? "https"), \(format)\(url)"
    }
    
    override func mediaConfig(startTime: TimeInterval, completionHandler: @escaping (MediaConfig?) -> Void) {
        // Create a session provider
        let sessionProvider = SimpleSessionProvider(serverURL: url, partnerId: partnerId, ks: nil)

        // Create the media provider
        let phoenixMediaProvider = PhoenixMediaProvider()
        phoenixMediaProvider.set(assetId: id)
        phoenixMediaProvider.set(type: .media)
        phoenixMediaProvider.set(refType: .unset)
        phoenixMediaProvider.set(playbackContextType: .playback)
        phoenixMediaProvider.set(formats: formats)
        phoenixMediaProvider.set(networkProtocol: networkProtocol)
        phoenixMediaProvider.set(sessionProvider: sessionProvider)

        phoenixMediaProvider.loadMedia { (pkMediaEntry, error) in
            guard let mediaEntry = pkMediaEntry else { return }
            completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: startTime))
        }
    }
}
