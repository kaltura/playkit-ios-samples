//
//  ViewController.swift
//  LocalAssetsSample
//
//  Created by Noam Tamim on 16/12/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import AVFoundation
import DownPicker

let fpsCertificate = "MIIFETCCA/mgAwIBAgIISWLo8KcYfPMwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMjAxMTY0NTQ0WhcNMTgwMjAxMTY0NTQ0WjCBijELMAkGA1UEBhMCVVMxKDAmBgNVBAoMH1ZJQUNPTSAxOCBNRURJQSBQUklWQVRFIExJTUlURUQxEzARBgNVBAsMClE5QU5HR0w4TTYxPDA6BgNVBAMMM0ZhaXJQbGF5IFN0cmVhbWluZzogVklBQ09NIDE4IE1FRElBIFBSSVZBVEUgTElNSVRFRDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA2YmfdPWM86+te7Bbt4Ic6FexXwMeL+8AmExIj8jAaNxhKbfVFnUnuXzHOajGC7XDbXxsFbPqnErqjw0BqUoZhs+WVMy+0X4AGqHk7uRpZ4RLYganel+fqitL9rz9w3p41x8JfLV+lAej+BEN7zNeqQ2IsC4BxkViu1gA6K22uGsCAwEAAaOCAgcwggIDMB0GA1UdDgQWBBQK+Gmarl2PO3jtLP6A6TZeihOL3DAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFGPkR1TLhXFZRiyDrMxEMWRnAyy+MIHiBgNVHSAEgdowgdcwgdQGCSqGSIb3Y2QFATCBxjCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA1BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vY3JsLmFwcGxlLmNvbS9rZXlzZXJ2aWNlcy5jcmwwDgYDVR0PAQH/BAQDAgUgMEgGCyqGSIb3Y2QGDQEDAQH/BDYBZ2diOGN5bXpsb21vdXFqb3p0aHg5aXB6dDJ0bThrcGdqOGNwZGlsbGVhMWI1aG9saWlyaW8wPQYLKoZIhvdjZAYNAQQBAf8EKwF5aHZlYXgzaDB2Nno5dXBqcjRsNWVyNm9hMXBtam9zYXF6ZXdnZXFkaTUwDQYJKoZIhvcNAQEFBQADggEBAIaTVzuOpZhHHUMGd47XeIo08E+Wb5jgE2HPsd8P/aHwVcR+9627QkuAnebftasV/h3FElahzBXRbK52qIZ/UU9nRLCqqKwX33eS2TiaAzOoMAL9cTUmEa2SMSzzAehb7lYPC73Y4VQFttbNidHZHawGp/844ipBS7Iumas8kT8G6ZmIBIevWiggd+D5gLdqXpOFI2XsoAipuxW6NKnnlKnuX6aNReqzKO0DmQPDHO2d7pbd3wAz5zJmxDLpRQfn7iJKupoYGqBs2r45OFyM14HUWaC0+VSh2PaZKwnSS8XXo4zcT/MfEcmP0tL9NaDfsvIWnScMxHUUTNNsZIp3QXA="


struct Asset {
    let id: String
    let url: String
    let licenseUrl: String?
    
//    var downloadLocation: URL? = nil
    
    init(_ id: String, url: String, licenseUrl: String? = nil) {
        self.id = id
        self.url = url
        self.licenseUrl = licenseUrl
    }
    
//    func mediaEntry() -> MediaEntry {
//        let drmData = licenseUrl == nil ? nil : [
//            [
//            "licenseUrl": licenseUrl,
//            "fpsCertificate": fpsCertificate
//            ]
//        ]
//        
//        if let url = loadDownloadLocation(assetId: self.id) {
//            let mediaSource = 
//        }
//        let url = loadDownloadLocation(assetId: self.id)?.absoluteString ?? self.url
//        
//        return MediaEntry(json: [
//            "id": id,
//            "sources": [
//                [
//                    "url": url,
//                    "drmData": drmData as Any
//                ]
//            ]
//        ])
//    }
    
    func avAsset() -> AVURLAsset {
        return AVURLAsset(url: URL(string: url)!)
    }
}

let assets = [
    Asset("sintel", 
          url: "https://cdnapisec.kaltura.com/p/1851571/playManifest/entryId/0_pl5lbfo0/format/applehttp/protocol/https/a/a.m3u8", 
          licenseUrl: "https://udrmv3.kaltura.com/fps/license?custom_data=eyJjYV9zeXN0ZW0iOiJPVlAiLCJ1c2VyX3Rva2VuIjoiZGpKOE1UZzFNVFUzTVh3cWRGNk9CUTRBQlV1LUtvYmJuWndUMVEyb0daOUotYUg3T05Tblh3SmU4WDM5cXJfWGpuVXg4UnJNeFVZN0dKNkF6YVJIVmtzbzlmdll6WkRzdU5HOHNScUpHbnhoTHN0S2U4QlQyOHdWOGc9PSIsImFjY291bnRfaWQiOiIxODUxNTcxIiwiY29udGVudF9pZCI6IjBfcGw1bGJmbzAiLCJmaWxlcyI6IjBfendxM2w0NHIsMF91YTYycms2cywwX290bWFxcG5mLDBfeXdrbXFua2csMV9lMHF0YWoxaiwxX2IycXp5dmE3In0%3D&signature=3aYfqde7%2FPGrHjkOG3J0iXQ%2BEps%3D"),
    Asset("player",
          url: "https://cdnapisec.kaltura.com/p/243342/playManifest/entryId/1_sf5ovm7u/format/applehttp/protocol/https/a/a.m3u8"),
]

fileprivate let simpleStorage: LocalDrmStorage? = {
    return try? DefaultLocalDrmStorage()
}()

func downloadPathKeyName(_ assetId: String) -> String {
    return "\(assetId).localPath"
}

func loadDownloadLocation(assetId: String) -> URL? {
    guard let data = simpleStorage?.load(key: downloadPathKeyName(assetId)) else {
        return nil
    }
    guard let relativePath = String(data: data, encoding: .utf8) else {
        return nil
    }
    
    return URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true).appendingPathComponent(relativePath)
}

func saveDownloadLocation(assetId: String, downloadLocation: URL) {
    if let data = downloadLocation.relativePath.data(using: .utf8) {
        simpleStorage?.save(key: downloadPathKeyName(assetId), value: data)
    }
}


class ViewController: UIViewController {
    
    
    
    var player : Player!
    var currentDownloadingAsset: Asset?
    var selectedAsset: Asset?
    
    
    lazy var assetsManager: LocalAssetsManager = {
        return LocalAssetsManager(storage: simpleStorage)
    }()
    
    lazy var downloadConfig: URLSessionConfiguration = {
        return URLSessionConfiguration.background(withIdentifier: "playkit-demo-download")
    }()

    lazy var downloadSession: AVAssetDownloadURLSession = {
        return AVAssetDownloadURLSession(configuration: self.downloadConfig, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
    }()


    @IBOutlet var itemSelector: UITextField!
    @IBOutlet var playerContainer: UIView!
    var picker: DownPicker!

    @IBAction func playTapped(_: UIButton) {
        guard let asset = self.selectedAsset else {
            return
        }
        
        let config = PlayerConfig()
        
        let mediaEntry = self.mediaEntry(asset)
        
        config.set(mediaEntry: mediaEntry)
        
        self.player = PlayKitManager.sharedInstance.loadPlayer(config:config)
        self.player.view.frame = playerContainer.bounds
        self.playerContainer.addSubview(player.view)
        self.player.play()
    }
    
    @IBAction func downloadTapped(_: UIButton) {
        if let asset = self.selectedAsset {
            self.startDownload(asset)
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()

        
        let pickerData = assets.map { $0.id }
                
        self.picker = DownPicker.init(textField: self.itemSelector, withData: pickerData)
        self.picker.addTarget(self, action: #selector(assetSelected), for:.valueChanged)
        
        self.picker.selectedIndex = 0
        self.assetSelected()
    }
    
    func assetSelected(_: Any? = nil) {
        self.selectedAsset = assets[picker.selectedIndex]
        print("selected asset:", self.selectedAsset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func startDownload(_ asset: Asset) {
        let entry = self.mediaEntry(asset, allowLocal: false)
        let avAsset = asset.avAsset()
        
        let task = downloadSession.makeAssetDownloadTask(asset: avAsset, assetTitle: asset.id, assetArtworkData: nil, options: nil)
        
        guard let source = entry.sources?.first else {
            return
        }
        assetsManager.prepareForDownload(asset: avAsset, assetId: asset.id, mediaSource: source)
        
        task?.resume()
        
        currentDownloadingAsset = asset
    }
    
    func mediaEntry(_ asset: Asset, allowLocal: Bool = true) -> MediaEntry {
        
        let mediaSource: MediaSource
        if allowLocal, let url = loadDownloadLocation(assetId: asset.id) {
            mediaSource = assetsManager.createLocalMediaSource(for: asset.id, localURL: url)
        } else {
            
            let drmData = [DRMData.fromJSON([
                "licenseUrl": asset.licenseUrl,
                "fpsCertificate": fpsCertificate
                ])].flatMap({$0})
            mediaSource = MediaSource(asset.id, contentUrl: URL(string: asset.url), drmData: drmData)
        }
                
        return MediaEntry(asset.id, sources: [mediaSource])
    }
    

}


extension ViewController: AVAssetDownloadDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function, task, error.debugDescription)
    }
    
    @available(iOS 10.0, *)
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        print(assetDownloadTask, location)
        if let assetId = selectedAsset?.id {
            saveDownloadLocation(assetId: assetId, downloadLocation: location)
        }
    }
    
    @available(iOS 9.0, *)
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        print("didLoadTimeRange: \(timeRange.start.value/Int64(timeRange.start.timescale)) (\(timeRange.duration.value/Int64(timeRange.duration.timescale))) expected: \(timeRangeExpectedToLoad.duration.value/Int64(timeRangeExpectedToLoad.duration.timescale))") 
    }
    
    @available(iOS 9.0, *)
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didResolve resolvedMediaSelection: AVMediaSelection) {
        print(assetDownloadTask, resolvedMediaSelection)
    }
    

}

