//
//  PlayerViewController.swift
//  MacPlayer
//
//  Created by Noam Tamim on 21/06/2019.
//  Copyright © 2019 Noam Tamim. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

fileprivate let errorTag = "Error"
fileprivate let errorLogTag = "ErrorLog"
fileprivate let accessLogTag = "AccessLog"

fileprivate let resourceLoadingRequestQueue = DispatchQueue(label: "com.example.resourcerequests")

var playerItemContext = 0


class PlayerViewController: NSViewController {
    
    var asset: Asset?
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet var logView: NSTextView!
    
    @IBOutlet weak var scrollView: NSScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logView.textColor = .black
        logView.backgroundColor = .lightGray
        
        guard let asset = self.asset else {fatalError("No asset")}

        guard let url = URL(string: asset.url) else {
            return
        }
        
        let avAsset = AVURLAsset(url: url)
        avAsset.resourceLoader.setDelegate(self, queue: resourceLoadingRequestQueue)
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let assetKeysRequiredToPlay = [
            "playable",
            "tracks",
            "hasProtectedContent",
            "duration"
        ]
        
        let playerItem = AVPlayerItem(asset: avAsset, automaticallyLoadedAssetKeys: assetKeysRequiredToPlay)
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        
        let player = AVPlayer(playerItem: playerItem)
        
        playerView.player = player
        player.allowsExternalPlayback = true
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onErrorLogEntryNotification), name: .AVPlayerItemNewErrorLogEntry, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAccessLogEntryNotification), name: .AVPlayerItemNewAccessLogEntry, object: playerItem)

    }
    
    @objc func onErrorLogEntryNotification(notification: Notification) {
        guard let item = notification.object as? AVPlayerItem,
            let errorLog = item.errorLog(),
            let lastEvent = errorLog.events.last
            else { return }
        
        appendToLog(errorLogTag, "\(String(describing: lastEvent.errorComment)) (Code: \(lastEvent.errorStatusCode) @ \(lastEvent.errorDomain)")
    }

    @objc func onAccessLogEntryNotification(notification: Notification) {
        guard let item = notification.object as? AVPlayerItem,
            let accessLog = item.accessLog(),
            let lastEvent = accessLog.events.last
            else { return }
        
        appendToLog(accessLogTag, """
            averageAudioBitrate: \(lastEvent.averageAudioBitrate); \
            averageVideoBitrate: \(lastEvent.averageVideoBitrate); \
            indicatedAverageBitrate: \(lastEvent.indicatedAverageBitrate); \
            indicatedBitrate: \(lastEvent.indicatedBitrate) \
            observedBitrate: \(lastEvent.observedBitrate) \
            observedMaxBitrate: \(lastEvent.observedMaxBitrate) \ 
            observedMinBitrate: \(lastEvent.observedMinBitrate) \ 
            switchBitrate: \(lastEvent.switchBitrate)
            """)
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func appendToLog(_ tag: String, _ text: String) {
        
        let boldFont = NSFont.boldSystemFont(ofSize: 10)
        let prefix = [errorLogTag: "⚠️", errorTag: "‼️"][tag] ?? "😎"
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            let text = NSMutableAttributedString(string: "\(prefix) [\(tag)] \(text)\n")
            text.addAttribute(.font, value: boldFont, range: NSMakeRange(2, tag.count + 2))
            self.logView.textStorage?.append(text)
            self.logView.scrollToEndOfDocument(self)
        }
    }
    
    func appendToLog(error: Error) {
        appendToLog(errorTag, "\(error)")
    }
    
//    func showError(_ error: Error) {
//        
//        DispatchQueue.main.async { [weak self] in
//            
//            guard let self = self else {return}
//            
//            let nse = error as NSError
//            
//            let alert = NSAlert()
//            alert.messageText = nse.localizedDescription
//            alert.informativeText = "\(nse.userInfo)\n\(nse.code) @ \(nse.domain)"
//            alert.addButton(withTitle: "OK")
//            alert.runModal()
//        }
//    }
    
    override func viewWillDisappear() {
        playerView.player?.pause()
        playerView.player?.replaceCurrentItem(with: nil)
        playerView.player = nil
    }
    
    deinit {

    }
}


extension PlayerViewController {
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                appendToLog("Status", "\(change ?? [:])")
                break
            case .failed:
                appendToLog(errorTag, "Playback failed")
                if let item = object as? AVPlayerItem, let error = item.error {
                    appendToLog(error: error)
                }
                
            default:
                appendToLog(errorTag, "Item state changed to unknown: \(change ?? [:])")
            }
        }
    }
}

extension PlayerViewController: AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        guard let asset = self.asset else {fatalError("No asset")}
        
        guard let drm = asset.drm.first else {
            appendToLog(errorTag, "Asset uses FairPlay but DRM params not specified")
            return false
        }
        
        var fpsProvider: FairPlayLicenseProvider
        switch drm.serverProtocol {
        case 0, nil:
            fpsProvider = KalturaFairPlayLicenseProvider()
        case 1:
            fpsProvider = FormFairPlayLicenseProvider(drm.customData ?? "")
        default:
            fatalError("Invalid server protocol")
        }


        let url = loadingRequest.request.url
        if url?.scheme != "skd" {
            return false
        }
        
        guard let assetId = url?.host else {
            return false
        }
        
        let spc = try! loadingRequest.streamingContentKeyRequestData(forApp: Data(base64Encoded: drm.certificate)!, contentIdentifier: assetId.data(using: .utf8)!, options: [:])
        
        fpsProvider.getLicense(spc: spc, assetId: assetId, url: URL(string: drm.licenseURL)!, headers: [:]) { [weak self] (ckc, duration, e) in 
            if let e = e {
                self?.appendToLog(error: e)
            } else {
                loadingRequest.dataRequest?.respond(with: ckc!)
                loadingRequest.finishLoading()
            }
        }
        
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        return self.resourceLoader(resourceLoader, shouldWaitForLoadingOfRequestedResource: renewalRequest)
    }
}


