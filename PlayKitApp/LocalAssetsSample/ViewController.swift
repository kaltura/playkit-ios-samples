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
    
    var downloadLocation: URL? = nil
    
    init(_ id: String, url: String, licenseUrl: String? = nil) {
        self.id = id
        self.url = url
        self.licenseUrl = licenseUrl
    }
    
    func mediaEntry() -> MediaEntry {
        return MediaEntry(dict: [
            "id": id,
            "sources": [
                [
                    "url": url,
                    "drmData": [
                        "licenseUrl": licenseUrl,
                        "fpsCertificate": fpsCertificate
                    ]
                ]
            ]
        ])
    }
    
    func avAsset() -> AVURLAsset {
        return AVURLAsset(url: URL(string: url)!)
    }
}

let assets = [
    Asset("sintel", 
          url: "https://cdnapisec.kaltura.com/p/1851571/sp/185157100/playManifest/entryId/0_pl5lbfo0/format/applehttp/protocol/https/a/a.m3u8", 
          licenseUrl: "https://udrmv3.kaltura.com/fps/license?custom_data=eyJjYV9zeXN0ZW0iOiJPVlAiLCJ1c2VyX3Rva2VuIjoiZGpKOE1UZzFNVFUzTVh4VVNvWks3T1NWaEpOSFIzQWV5X0stQWFDWG4xWEQ0NldiQzdwTE9GRHJVS3N3amxlOHNrWFRTZE1UR1FpdkRtLWxtRVVhMmhyMkFJY0xaZ1JoSFZNREg4bEtFbG9KdUY3cnUzcnBPRGhLbnc9PSIsImFjY291bnRfaWQiOiIxODUxNTcxIiwiY29udGVudF9pZCI6IjBfcGw1bGJmbzAiLCJmaWxlcyI6IjBfendxM2w0NHIsMF91YTYycms2cywwX290bWFxcG5mLDBfeXdrbXFua2csMV9lMHF0YWoxaiwxX2IycXp5dmE3In0%3D&signature=F343zeUI%2BvxzrrLbV3xTmXW4p3Y%3D")
]

class ViewController: UIViewController {
    
    
    var player : Player!
    let assetsManager = LocalAssetsManager()
    var currentDownloadingAsset: Asset?
    

    @IBOutlet var itemSelector: UITextField?
    var picker: DownPicker?


    @IBAction func playTapped(_: UIButton) {
        
    }
    
    @IBAction func downloadTapped(_: UIButton) {
        let asset = assets[(picker?.selectedIndex)!]
        self.startDownload(asset)
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let pickerData = assets.map { (_ asset: Asset) -> String in
//            return asset.id
//        }
        
        let pickerData = assets.map { $0.id }
        
        
        self.picker = DownPicker.init(textField: self.itemSelector, withData: pickerData)
        self.picker?.selectedIndex = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


extension ViewController: AVAssetDownloadDelegate {
    func startDownload(_ asset: Asset) {
        let entry = asset.mediaEntry()
        let avAsset = asset.avAsset()

        guard let source = entry.sources?.first else {
            return
        }
        assetsManager.prepareForDownload(asset: avAsset, assetId: asset.id, mediaSource: source)

        let assetConfig = URLSessionConfiguration.background(withIdentifier: "download-\(asset.id)")
        let downloadSession = AVAssetDownloadURLSession(configuration: assetConfig, assetDownloadDelegate: self, delegateQueue: nil)
        let task = downloadSession.makeAssetDownloadTask(asset: avAsset, assetTitle: asset.id, assetArtworkData: nil, options: nil)
        task?.resume()
        
        currentDownloadingAsset = asset
    }
    
    
    
    @available(iOS 10.0, *)
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        currentDownloadingAsset?.downloadLocation = location
        print(assetDownloadTask, location)
    }
    
    @available(iOS 9.0, *)
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        print(assetDownloadTask, timeRange, loadedTimeRanges, timeRangeExpectedToLoad)
    }
    
    @available(iOS 9.0, *)
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didResolve resolvedMediaSelection: AVMediaSelection) {
        print(assetDownloadTask, resolvedMediaSelection)
    }
    

}

