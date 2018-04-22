//
//  PlayableItem.swift
//  AVAssetDownloadSample
//
//  Created by Nilit Danan on 4/18/18.
//  Copyright © 2018 Kaltura Inc. All rights reserved.
//

import Foundation
import PlayKit

class PlayableItem {
    let id: String
    let title: String
    let partnerId: Int?
    
    var url: URL?
    var entry: PKMediaEntry?
    
    init(id: String, url: String) {
        self.id = id
        self.title = id
        self.url = URL(string: url)!
        
        let source = PKMediaSource(id, contentUrl: URL(string: url))
        self.entry = PKMediaEntry(id, sources: [source])
        
        self.partnerId = nil
    }
    
    init(title: String, id: String, partnerId: Int, env: String = "http://cdnapi.kaltura.com") {
        self.id = id
        self.title = title
        self.partnerId = partnerId
        
        self.url = nil
        
        OVPMediaProvider(SimpleOVPSessionProvider(serverURL: env, partnerId: Int64(partnerId), ks: nil))
            .set(entryId: id)
            .loadMedia { (entry, error) in
                self.entry = entry
        }
    }
}
