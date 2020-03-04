//
//  Medias.swift
//  PlayKitAppleTVSample
//
//  Created by Nilit Danan on 3/3/20.
//  Copyright © 2020 Kaltura. All rights reserved.
//

import Foundation

struct Medias {
    static func create() -> [Media] {
        
        var medias: [Media] = []
        
        // Basic
        medias.append(Media(id: "Apple Bip Bop",
                            contentUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"))
        // Basic with Preroll
        medias.append(Media(id: "Apple Bip Bop",
                            contentUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
                            adTag: .Preroll))
        // Basic with Preroll
        medias.append(Media(id: "Apple Bip Bop",
                            contentUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
                            adTag: .Postroll))
        
        // Basic live
        medias.append(Media(id: "Live",
                            contentUrl: "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_f8re4ujs/protocol/http/format/applehttp/flavorIds/0_cqe1sj58,0_4grpaumc,0_77l646yh/a.m3u8"))
        // Basic live with Preroll
        medias.append(Media(id: "Live",
                            contentUrl: "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_f8re4ujs/protocol/http/format/applehttp/flavorIds/0_cqe1sj58,0_4grpaumc,0_77l646yh/a.m3u8",
                            adTag: .Preroll))
        
        medias.append(Media(id: "Kaltura Multi-Captions",
                            contentUrl: "https://cdnapisec.kaltura.com/p/811441/playManifest/entryId/1_mhyj12pj/format/applehttp/protocol/https/a.m3u8"))
        
        medias.append(Media(id: "Kaltura Multi-Audio",
                            contentUrl: "https://cdnapisec.kaltura.com/p/2035982/sp/203598200/playManifest/entryId/0_7s8q41df/format/applehttp/protocol/https/name/a.m3u8"))
        
        medias.append(OTTMedia(assetId: "828674",
                               serverURL: "https://rest-as.ott.kaltura.com/v5_0_3/api_v3/",
                               partnerId: 225,
                               adTag: .Preroll,
                               formats: ["HLS_Linear_P"],
                               networkProtocol: "https"))
        
        medias.append(OVPMedia(entryId: "1_2si8665o", baseUrl: "https://cdnapisec.kaltura.com", partnerId: 2488041, adTag: .Preroll))
       
        return medias
    }
}
