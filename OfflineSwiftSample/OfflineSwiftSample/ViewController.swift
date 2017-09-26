//
//  ViewController.swift
//  OfflineSwiftSample
//
//  Created by Noam Tamim on 26/03/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import AVFoundation






class ViewController: UIViewController {

    var player : Player!
    
    let simpleStorage = DefaultLocalDataStore.defaultDataStore()

    // TODO: this sample entry is initialized by loadSampleEntry(). 
    var sampleEntry: MediaEntry?
    

    // Use a LocalAssetsManager to handle local (offline, downloaded) assets.
    lazy var assetsManager: LocalAssetsManager = {
        return LocalAssetsManager.manager(storage: self.simpleStorage!)
    }()
    
    // See HLSCatalog for more on session configuration and management. 
    lazy var downloadConfig: URLSessionConfiguration = {
        return URLSessionConfiguration.background(withIdentifier: "playkit-demo-download")
    }()
    
    lazy var downloadSession: AVAssetDownloadURLSession = {
        return AVAssetDownloadURLSession(configuration: self.downloadConfig, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadSampleEntry()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startDownload() {
        // Start AVAssetDownloadTask
        
        guard let entry = sampleEntry else { return }
        
        // prepareForDownload() returns an AVURLAsset that points to the preferred download source.
        // The returned asset is also configured for FairPlay support (iOS 10+ only).
        guard let (avAsset, _) = assetsManager.prepareForDownload(of: entry) else { return }
        
        // For finer control on download source selection, 
        
        guard let task = downloadSession.makeAssetDownloadTask(asset: avAsset, assetTitle: entry.id, assetArtworkData: nil, options: nil) else {
            return
        }
        
        task.resume()
        
    }
    
    @IBAction func downloadTapped() {
        startDownload()
    }
    
    @IBAction func playTapped() {
        if let id = sampleEntry?.id, let url = loadDownloadLocation(assetId: id) {
            let localEntry = self.assetsManager.createLocalMediaEntry(for: id, localURL: url)
            
            // Now prepare Player with localEntry
            let mediaConfig = MediaConfig (mediaEntry: localEntry)
            player.prepare(mediaConfig)
            // TODO: continue normal player flow.
        }
        
    }
    
    // TODO: replace with an app-specific method to store the local URL.
    // Note that the stored URL must be relative -- never store absolute pathnames.
    func saveDownloadLocation(assetId: String, downloadLocation: URL) {
        let relativePath = downloadLocation.relativePath
        
        // This implementation reuses the local data store
        if let data = relativePath.data(using: .utf8) {
            try? simpleStorage?.save(key: "\(assetId).localPath", value: data)
        }
    }
    
    // TODO: replace with app-specific method to reconstruct a local URL.
    // Note that the stored URL is relative to the application's home directory, 
    // and we must provide an absolute URL.
    func loadDownloadLocation(assetId: String) -> URL? {
        // This implementation reuses the local data store
        
        guard let data = try? simpleStorage?.load(key: "\(assetId).localPath") else {
            return nil
        }
        guard let value = data, let relativePath = String(data: value, encoding: .utf8) else {
            return nil
        }
        
        if relativePath.contains(NSHomeDirectory()) {
            return URL(string: relativePath)
        }
        
        return URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true).appendingPathComponent(relativePath)
    }
    
    // TODO: replace with your own entry loading logic. 
    func loadSampleEntry() {
        // Use OVPMediaProvider to load a hardcoded entry.
        
        let EntryId = "1_q81a5nbp"
        let PartnerId = 2222401
        let KalturaServerURL = "https://cdnapisec.kaltura.com"
        OVPMediaProvider()
            .set(sessionProvider: SimpleOVPSessionProvider(serverURL: KalturaServerURL, partnerId: Int64(PartnerId), ks: nil))
            .set(entryId: EntryId)
            .loadMedia { (entry, error) in
                self.sampleEntry = entry
        }
    }
}



// TODO: more optional methods should be implemented, see HLSCatalog app.
extension ViewController: AVAssetDownloadDelegate {
    
    @available(iOS 10.0, *)
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        print(assetDownloadTask, location)
        // Save download location for later.
        if let assetId = sampleEntry?.id {
            saveDownloadLocation(assetId: assetId, downloadLocation: location)
        }
    }
}

