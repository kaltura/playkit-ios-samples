//
//  ViewController.swift
//  OfflineSampleSwift
//
//  Created by Noam Tamim on 27/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit


class ViewController: UIViewController {
    
    var player: Player?
    @IBOutlet var playerContainer: UIView!
    var playerView: PlayerView!
    
    let simpleStorage = DefaultLocalDataStore.defaultDataStore()
    
    // The sample entries are initialized asynchronously by loadSampleEntries().
    var sampleEntries = [PKMediaEntry]()
    
    
    // Use a LocalAssetsManager to handle local (offline, downloaded) assets.
    lazy var assetsManager: LocalAssetsManager = {
        return LocalAssetsManager.manager(storage: self.simpleStorage!)
    }()
    
    let downloadManager = AssetPersistenceManager.sharedManager
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(forName: AssetDownloadProgressNotification, object: nil, queue: OperationQueue.main) { (notif) in
            print("AssetDownloadProgressNotification", notif)
        }
        
        NotificationCenter.default.addObserver(forName: AssetDownloadStateChangedNotification, object: nil, queue: OperationQueue.main) { (notif) in
            print("AssetDownloadProgressNotification", notif)
        }
        
        let pluginConfig = PluginConfig(config: [:])
        guard let player = try? PlayKitManager.shared.loadPlayer(pluginConfig: pluginConfig) else { return }
        
        loadSampleEntries()
        
        self.playerView = PlayerView.init(frame: playerContainer.bounds)
        playerContainer.addSubview(playerView)
        player.view = self.playerView
        
        self.player = player
    }
    
    override func viewDidLayoutSubviews() {
        self.player?.view?.frame = self.playerContainer.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startDownload(_ index: Int) {
        // Start AVAssetDownloadTask
        
        let entry = sampleEntries[index]
                
        // prepareForDownload() returns an AVURLAsset that points to the preferred download source.
        // The returned asset is also configured for FairPlay support (iOS 10+ only).
        guard let (avAsset, _) = assetsManager.prepareForDownload(of: entry) else { return }
        
        let assetName = "entry_\(index)"
        downloadManager.downloadStream(for: Asset(name: assetName, urlAsset: avAsset))
    }
    
    func playLocal(_ index: Int) {
        
        // Get Local asset and play it
        
        let assetName = "entry_\(index)"
        guard let localAsset = downloadManager.localAssetForStream(withName: assetName) else { return }
        
        let localURL = localAsset.urlAsset.url
        
        let localEntry = assetsManager.createLocalMediaEntry(for: assetName, localURL: localURL)
        
        let mediaConfig = MediaConfig(mediaEntry: localEntry)
        player!.prepare(mediaConfig)
        player!.play()
    }
    
    
    @IBAction func download1() {
        startDownload(0)
    }
    
    @IBAction func download2() {
        startDownload(1)
    }
    
    @IBAction func play1() {
        playLocal(0)
    }
    
    @IBAction func play2() {
        playLocal(1)
    }
    
    
    // TODO: replace with your own entry loading logic. 
    func loadSampleEntries() {
        // Use OVPMediaProvider to load a hardcoded entry.
        
        let serverURL = "http://cdnapi.kaltura.com"

        let params: [(partnerId: Int, entryId: String)] = [
            (2215841, "1_9bwuo813"),    // Clear HLS
            (2222401, "1_z9tkt5uz"),    // HLS with FairPlay DRM
        ]
        
        for item in params {
            let session = SimpleOVPSessionProvider(serverURL: serverURL, partnerId: Int64(item.partnerId), ks: nil)
            OVPMediaProvider()
                .set(sessionProvider: session)
                .set(entryId: item.entryId)
                .loadMedia { (entry, error) in
                    if let entry = entry {
                        self.sampleEntries.append(entry)
                    }
            }
        }
    }
}

