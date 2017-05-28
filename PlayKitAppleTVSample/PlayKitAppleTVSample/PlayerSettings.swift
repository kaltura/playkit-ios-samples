//
//  PlayerSettings.swift
//  PlayKitAppleTVSample
//
//  Created by Gal Orlanczyk on 23/05/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import Foundation
import PlayKit

class PlayerSettings {
    
    enum MediaType: Int {
        case clear = 0, live, drm, kalturaCaptions, kalturaAudioTracks
    }
    
    var mediaType: MediaType = .clear
    var startTime: TimeInterval = 0
    var autoplay = false
    
    func createMediaConfig(completionHandler: @escaping (MediaConfig?) -> Void) {
        switch self.mediaType {
        case .clear:
            let id = "Apple Bip Bop"
            let contentUrl = "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
            let mediaEntry = self.createMediaEntry(fromUrl: contentUrl, andId: id)
            completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: self.startTime))
        case .live:
            let mediaEntry = self.createMediaEntry(fromUrl: "http://il-wowza-centos-01.dev.kaltura.com:8080/live/hls/p/1091/e/0_cb9k71rb/t/KQT69d74Ls5IGXrkjtAABQ/index-s32.m3u8", andId: "0_cb9k71rb")
            completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: self.startTime))
        case .drm:
            /*let id = "0_pl5lbfo0"
            let contentUrl = "https://cdnapisec.kaltura.com/p/1851571/playManifest/entryId/0_pl5lbfo0/format/applehttp/protocol/https/a/a.m3u8"
            let licenseDataUrl = URL(string: "https://cdnapisec.kaltura.com/html5/html5lib/v2.50/services.php?service=getLicenseData&uiconf_id=31956421&wid=_1851571&entry_id=0_pl5lbfo0&drm=fps")
            guard let dataTaskUrl = licenseDataUrl else {
                print("license data url for drm is wrong")
                completionHandler(nil)
                return
            }
            let dataTask = URLSession.shared.dataTask(with: dataTaskUrl) { (data, response, error) in
                if let data = data, error == nil {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let dict = json as? [String: Any], let drmData = DRMParams.fromJSON(dict) {
                        let mediaEntry = MediaEntry(id, sources: [MediaSource(id, contentUrl: URL(string: contentUrl)!, drmData: [drmData])])
                        DispatchQueue.main.async {
                            completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: self.startTime))
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            dataTask.resume()*/
            
            let sessionProvider = SimpleOVPSessionProvider(serverURL: "https://cdnapisec.kaltura.com", partnerId: 1851571, ks: nil)
            let mediaProvider = OVPMediaProvider(sessionProvider)
            mediaProvider.entryId = "0_pl5lbfo0"
            mediaProvider.loadMedia() { (mediaEntry, error) in
                if let me = mediaEntry {
                    completionHandler(MediaConfig(mediaEntry: me, startTime: self.startTime))
                }
            }
        case .kalturaCaptions:
            let contentUrl = "https://cdnapisec.kaltura.com/p/811441/playManifest/entryId/1_mhyj12pj/format/applehttp/protocol/https/a.m3u8"
            let mediaEntry = self.createMediaEntry(fromUrl: contentUrl, andId: "Kaltura Multi-Captions")
            completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: self.startTime))
        case .kalturaAudioTracks:
            let contentUrl = "https://cdnapisec.kaltura.com/p/2035982/sp/203598200/playManifest/entryId/0_7s8q41df/format/applehttp/protocol/https/name/a.m3u8"
            let mediaEntry = self.createMediaEntry(fromUrl: contentUrl, andId: "Kaltura Multi-Audio")
            completionHandler(MediaConfig(mediaEntry: mediaEntry, startTime: self.startTime))
        }
    }
    
    private func createMediaEntry(fromUrl url: String, andId id: String) -> MediaEntry {
        let mediaSource = MediaSource.init(id, contentUrl: URL(string: url))
        return MediaEntry.init(id, sources: [mediaSource])
    }
}
