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

let globalFpsCertificate = "MIIFETCCA/mgAwIBAgIISWLo8KcYfPMwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMjAxMTY0NTQ0WhcNMTgwMjAxMTY0NTQ0WjCBijELMAkGA1UEBhMCVVMxKDAmBgNVBAoMH1ZJQUNPTSAxOCBNRURJQSBQUklWQVRFIExJTUlURUQxEzARBgNVBAsMClE5QU5HR0w4TTYxPDA6BgNVBAMMM0ZhaXJQbGF5IFN0cmVhbWluZzogVklBQ09NIDE4IE1FRElBIFBSSVZBVEUgTElNSVRFRDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA2YmfdPWM86+te7Bbt4Ic6FexXwMeL+8AmExIj8jAaNxhKbfVFnUnuXzHOajGC7XDbXxsFbPqnErqjw0BqUoZhs+WVMy+0X4AGqHk7uRpZ4RLYganel+fqitL9rz9w3p41x8JfLV+lAej+BEN7zNeqQ2IsC4BxkViu1gA6K22uGsCAwEAAaOCAgcwggIDMB0GA1UdDgQWBBQK+Gmarl2PO3jtLP6A6TZeihOL3DAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFGPkR1TLhXFZRiyDrMxEMWRnAyy+MIHiBgNVHSAEgdowgdcwgdQGCSqGSIb3Y2QFATCBxjCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA1BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vY3JsLmFwcGxlLmNvbS9rZXlzZXJ2aWNlcy5jcmwwDgYDVR0PAQH/BAQDAgUgMEgGCyqGSIb3Y2QGDQEDAQH/BDYBZ2diOGN5bXpsb21vdXFqb3p0aHg5aXB6dDJ0bThrcGdqOGNwZGlsbGVhMWI1aG9saWlyaW8wPQYLKoZIhvdjZAYNAQQBAf8EKwF5aHZlYXgzaDB2Nno5dXBqcjRsNWVyNm9hMXBtam9zYXF6ZXdnZXFkaTUwDQYJKoZIhvcNAQEFBQADggEBAIaTVzuOpZhHHUMGd47XeIo08E+Wb5jgE2HPsd8P/aHwVcR+9627QkuAnebftasV/h3FElahzBXRbK52qIZ/UU9nRLCqqKwX33eS2TiaAzOoMAL9cTUmEa2SMSzzAehb7lYPC73Y4VQFttbNidHZHawGp/844ipBS7Iumas8kT8G6ZmIBIevWiggd+D5gLdqXpOFI2XsoAipuxW6NKnnlKnuX6aNReqzKO0DmQPDHO2d7pbd3wAz5zJmxDLpRQfn7iJKupoYGqBs2r45OFyM14HUWaC0+VSh2PaZKwnSS8XXo4zcT/MfEcmP0tL9NaDfsvIWnScMxHUUTNNsZIp3QXA="


struct Asset {
    let id: String
    let url: String
    let licenseUri: String?
    let licenseDataUrl: String?
    
    init(_ id: String, url: String, licenseUri: String? = nil, licenseDataUrl: String? = nil) {
        self.id = id
        self.url = url
        self.licenseUri = licenseUri
        self.licenseDataUrl = licenseDataUrl
    }
    
    func avAsset() -> AVURLAsset {
        return AVURLAsset(url: URL(string: url)!)
    }
}

let assets = [
    Asset("multiSubs", url: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_nzffqkbk/flavorIds/1_fwqw0ess,1_yq43k0hz,1_7pjl2kat,1_tebzcakx/format/applehttp/protocol/https/a.m3u8"),
    Asset("player", url: "https://cdnapisec.kaltura.com/p/243342/playManifest/entryId/1_sf5ovm7u/format/applehttp/protocol/https/a/a.m3u8"),
    Asset("sintel", 
          url: "https://cdnapisec.kaltura.com/p/1851571/playManifest/entryId/0_pl5lbfo0/format/applehttp/protocol/https/a/a.m3u8", 
          licenseDataUrl: "https://cdnapisec.kaltura.com/html5/html5lib/v2.50/services.php?service=getLicenseData&uiconf_id=31956421&wid=_1851571&entry_id=0_pl5lbfo0&drm=fps"
          ),
]

fileprivate let simpleStorage: LocalDrmStorage? = {
    return try? DefaultLocalDrmStorage()
}()

func downloadPathKeyName(_ assetId: String) -> String {
    return "\(assetId).localPath"
}

func loadDownloadLocation(assetId: String) -> URL? {
    guard let data = try? simpleStorage?.load(key: downloadPathKeyName(assetId)) else {
        return nil
    }
    guard let value = data, let relativePath = String(data: value, encoding: .utf8) else {
        return nil
    }
    
    return URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true).appendingPathComponent(relativePath)
}

func saveDownloadLocation(assetId: String, downloadLocation: URL) {
    if let data = downloadLocation.relativePath.data(using: .utf8) {
        try? simpleStorage?.save(key: downloadPathKeyName(assetId), value: data)
    }
}


class ViewController: UIViewController {

    var player : Player!
    var currentDownloadingAsset: Asset?
    var selectedAsset: Asset?
    
    
    lazy var assetsManager: LocalAssetsManager = {
        return LocalAssetsManager(storage: simpleStorage!)
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
        print("selected asset:", self.selectedAsset ?? "<nil>")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func startDownload(_ asset: Asset) {
        let entry = self.mediaEntry(asset, allowLocal: false)
        let avAsset = asset.avAsset()
        
        guard let task = downloadSession.makeAssetDownloadTask(asset: avAsset, assetTitle: asset.id, assetArtworkData: nil, options: nil) else {
            return
        }
        
        guard let source = entry.sources?.first else {
            return
        }
        assetsManager.prepareForDownload(asset: avAsset, mediaSource: source)
        
        task.resume()
        
        currentDownloadingAsset = asset
    }
    
    func drmData(for asset: Asset) -> [DRMData]? {
        
        var drmData: DRMData? = nil
        
        if let licenseUri = asset.licenseUri {
            drmData = DRMData.fromJSON([
                "licenseUri": licenseUri,
                "fpsCertificate": globalFpsCertificate
                ])
        } else if let licenseDataUrl = asset.licenseDataUrl, let url = URL(string: licenseDataUrl) {
            var response: URLResponse?
            var responseData: Data? = nil
            do {
                responseData = try NSURLConnection.sendSynchronousRequest(URLRequest.init(url: url), returning: &response)
            } catch let error {
                print("Error:", error)
                return nil
            }

            let json = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers)
            if let dict = json as? [String: Any] {
                drmData = DRMData.fromJSON(dict)
            }

        }
        
        if let data = drmData {
            return [data]
        }
        
        return nil
    }
    
    func mediaEntry(_ asset: Asset, allowLocal: Bool = true) -> MediaEntry {
        
        if allowLocal, let url = loadDownloadLocation(assetId: asset.id) {
            return assetsManager.createLocalMediaEntry(for: asset.id, localURL: url)
        } else {
            // Note: this should actually come from the media provider
            return MediaEntry(asset.id, sources: [
                MediaSource(asset.id, contentUrl: URL(string: asset.url), drmData: drmData(for: asset))
                ])
        }
                
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

