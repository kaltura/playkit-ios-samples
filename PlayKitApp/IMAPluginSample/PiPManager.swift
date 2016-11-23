//
//  PiPManager.swift
//  PlayKitApp
//
//  Created by Vadim Kononov on 21/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import PlayKit

@available(iOS 9.0, *)
class PiPManager : NSObject {
    
    var pictureInPictureController: AVPictureInPictureController?
    var playerController: Player!
    var parent: AVPictureInPictureControllerDelegate!
    
    init(playerController: Player, parent: AVPictureInPictureControllerDelegate) {
        self.playerController = playerController
        self.parent = parent
        self.pictureInPictureController = self.playerController.createPiPController(with: self.parent)
    }
    
    func togglePiP(pipEnabled: Bool) {
        if (pictureInPictureController!.isPictureInPictureActive) {
            pictureInPictureController!.stopPictureInPicture();
        } else if pipEnabled {
            pictureInPictureController!.startPictureInPicture();
        }
    }
    
    func isPictureInPictureActive() -> Bool {
        return pictureInPictureController == nil || !pictureInPictureController!.isPictureInPictureActive
    }

    static func isPictureInPictureSupported() -> Bool {
        return AVPictureInPictureController.isPictureInPictureSupported()
    }
}
