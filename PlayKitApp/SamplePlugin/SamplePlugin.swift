//
//  SamplePlugin.swift
//  PlayKitApp
//
//  Created by Eliza Sapir on 16/01/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import Foundation
import PlayKit

class SamplePlugin: PKPlugin {
    
    static var pluginName: String {
        return "SamplePlugin"
    }
    
    required init() {}
    
    func load(player: Player, mediaConfig: MediaEntry, pluginConfig: Any?, messageBus: MessageBus) {
        print((pluginConfig as! SamplePluginConfig).data)
        // do your initial steps here
    }
    
    func destroy() {
        // destory your objects
    }
}
