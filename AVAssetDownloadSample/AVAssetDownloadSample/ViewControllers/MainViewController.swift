//
//  ViewController.swift
//  AVAssetDownloadSample
//
//  Created by Nilit Danan on 4/18/18.
//  Copyright © 2018 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit
import Toast
import AVFoundation

class MainViewController: UIViewController {

    let simpleStorage = DefaultLocalDataStore.defaultDataStore()
    
    // Use a LocalAssetsManager to handle local (offline, downloaded) assets.
    lazy var localAssetsManager: LocalAssetsManager = {
        return LocalAssetsManager.manager(storage: simpleStorage!)
    }()
    
    let assetPersistenceManager = AssetPersistenceManager.sharedManager
    
    @IBOutlet weak var selectedItemTextField: UITextField!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let items = [
        Item("FPS: Ella 1", id: "1_x14v3p06", partnerId: 1788671),
        Item("FPS: QA 1", id: "0_4s6xvtx3", partnerId: 4171, env: "http://cdntesting.qa.mkaltura.com"),
        Item("Clear: Kaltura", id: "1_sf5ovm7u", partnerId: 243342),
        // Item not good getting an error
        //        Item(id: "QA multi/multi", url: "http://qa-apache-testing-ubu-01.dev.kaltura.com/p/1091/sp/109100/playManifest/entryId/0_mskmqcit/flavorIds/0_et3i1dux,0_pa4k1rn9/format/applehttp/protocol/http/a.m3u8"),
        Item(id: "Eran multi audio", url: "https://cdnapisec.kaltura.com/p/2035982/sp/203598200/playManifest/entryId/0_7s8q41df/format/applehttp/protocol/https/name/a.m3u8?deliveryProfileId=4712"),
        Item(id: "Trailer", url: "http://cdnbakmi.kaltura.com/p/1758922/sp/175892200/playManifest/entryId/0_ksthpwh8/format/applehttp/tags/ipad/protocol/http/f/a.m3u8"),
        Item(id: "AES-128 multi-key", url: "https://noamtamim.com/random/hls/test-enc-aes/multi.m3u8")
        ]
    
    var selectedItem: Item! {
        didSet {
            let downloadState = self.downloadState(of: selectedItem)
            DispatchQueue.main.async {
                self.statusValueLabel.text = self.statusOf(self.selectedItem)
                switch downloadState {
                case .downloaded:
                    self.progressView.progress = 1.0
                default:
                    self.progressView.progress = 0.0
                }
            }
        }
    }
    
    let itemPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedItem = items.first!
        itemPickerView.delegate = self
        itemPickerView.dataSource = self
        selectedItemTextField.inputView = itemPickerView
        selectedItemTextField.inputView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        selectedItemTextField.text = items.first?.title ?? ""
        selectedItemTextField.inputAccessoryView = getAccessoryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: AssetDownloadProgressNotification, object: nil, queue: OperationQueue.main) { (notif) in
            print("AssetDownloadProgressNotification", notif)
            
            guard let userInfo = notif.userInfo else {
                return
            }
            
            guard let assetNameIndex = userInfo.index(forKey: Asset.Keys.name) else {
                return
            }
            
            let assetName = userInfo[assetNameIndex].value as! String
            let selectedItemAssetName = self.assetName(for: self.selectedItem)
            if assetName != selectedItemAssetName {
                return
            }
            
            guard let percentDownloadedIndex = userInfo.index(forKey: Asset.Keys.percentDownloaded) else {
                return
            }
            
            let value: Double = userInfo[percentDownloadedIndex].value as! Double
            
            DispatchQueue.main.async {
                self.progressView.progress = Float(value)
            }
        }
        
        NotificationCenter.default.addObserver(forName: AssetDownloadStateChangedNotification, object: nil, queue: OperationQueue.main) { (notif) in
            print("AssetDownloadStateChangedNotification", notif)
            
            guard let userInfo = notif.userInfo else {
                return
            }
            
            guard let assetNameIndex = userInfo.index(forKey: Asset.Keys.name) else {
                return
            }
            
            let assetName = userInfo[assetNameIndex].value as! String
            let selectedItemAssetName = self.assetName(for: self.selectedItem)
            if assetName != selectedItemAssetName {
                return
            }
            
            guard let downloadStateIndex = userInfo.index(forKey: Asset.Keys.downloadState) else {
                return
            }
            
            let state = userInfo[downloadStateIndex].value as! String
            
            DispatchQueue.main.async {
                self.statusValueLabel.text = self.downloadState(state)
                switch Asset.DownloadState(rawValue: state) {
                case .downloaded?:
                    self.progressView.progress = 1.0
                default:
                    self.progressView.progress = 0.0
                }
            }
        }
    }
    
    private func getAccessoryView() -> UIView {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        
        return toolBar
    }
    
    @objc private func doneButtonTapped(button: UIBarButtonItem) -> Void {
        selectedItemTextField.resignFirstResponder()
    }
    
    private func assetName(for item: Item) -> String {
        return item.id
    }
    
    private func statusOf(_ item: Item) -> String {
        let downloadState = self.downloadState(of: item)
        return self.downloadState(downloadState)
    }
    
    private func downloadState(of item: Item) -> Asset.DownloadState {
        let assetName = self.assetName(for: item)
        return assetPersistenceManager.downloadState(for: assetName)
    }
    
    private func downloadState(_ state: Asset.DownloadState) -> String {
        switch state {
        case .downloaded:
            return "Download Completed"
        case .downloading:
            return "In Progress"
        case .notDownloaded:
            return "New"
        }
    }
    
    private func downloadState(_ state: String) -> String {
        switch state {
        case Asset.DownloadState.downloaded.rawValue:
            return "Download Completed"
        case Asset.DownloadState.downloading.rawValue:
            return "In Progress"
        case Asset.DownloadState.notDownloaded.rawValue:
            return "New"
        default:
            return state
        }
    }
    
    private func toastShort(_ message: String) {
        print(message)
        view.makeToast(message, duration: 0.6, position: CSToastPositionCenter)
    }
    
    private func toastMedium(_ message: String) {
        print(message)
        view.makeToast(message, duration: 1.0, position: CSToastPositionCenter)
    }
    
    private func toastLong(_ message: String) {
        print(message)
        view.makeToast(message, duration: 1.5, position: CSToastPositionCenter)
    }

    // MARK: - IBActions
    
    @IBAction func startDownloadClicked(_ sender: Any) {
        let assetName = self.assetName(for: selectedItem)
        
        if assetPersistenceManager.downloadState(for: assetName) == Asset.DownloadState.downloaded {
            toastLong("The media was already downloaded.")
            return
        }
        
        guard let entry = selectedItem.entry else {
            toastLong("The entry for the selected media is empty.")
            return
        }
        
        // prepareForDownload() returns an AVURLAsset that points to the preferred download source.
        // The returned asset is also configured for FairPlay support (iOS 10+ only).
        guard let (avAsset, _) = localAssetsManager.prepareForDownload(of: entry) else {
            toastLong("Preferred download source could not be created.")
            return
        }
        
        assetPersistenceManager.downloadStream(for: Asset(name: assetName, urlAsset: avAsset))
    }
    
    @IBAction func cancelDownloadClicked(_ sender: Any) {
        let assetName = self.assetName(for: selectedItem)
        
        guard let asset = assetPersistenceManager.assetForStream(withName: assetName) else {
            toastLong("Can't cancel an item which is not in progress.")
            return
        }
        
        assetPersistenceManager.cancelDownload(for: asset)
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        let assetName = self.assetName(for: selectedItem)
        
        guard let asset = assetPersistenceManager.localAssetForStream(withName: assetName) else {
            toastLong("Can't remove an item that doesn't exists.")
            return
        }
        
        assetPersistenceManager.deleteAsset(asset)
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "PlayRemoteItemSegue":
            if selectedItem.entry == nil {
                toastLong("Can't play without a mediaEntry.")
                return false
            }
            
        case "SelectTracksSegue":
            let assetName = self.assetName(for: selectedItem)
            if assetPersistenceManager.localAssetForStream(withName: assetName) == nil {
                toastLong("There is no local asset to play.")
                return false
            }
            
        default:
            print("Unhandled Segue: \(identifier)")
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "PlayRemoteItemSegue"?:
            guard let destinationViewController = segue.destination as? MediaPlayerViewController else {
                return
            }
            
            destinationViewController.mediaEntry = selectedItem.entry
        
        case "SelectTracksSegue"?:
            guard let destinationViewController = segue.destination as? TracksViewController else {
                return
            }
            
            let assetName = self.assetName(for: selectedItem)
            guard let localAsset = assetPersistenceManager.localAssetForStream(withName: assetName) else {
                return
            }
            
            let localURL = localAsset.urlAsset.url
            
            destinationViewController.localURL = localURL
            destinationViewController.mediaEntry = localAssetsManager.createLocalMediaEntry(for: assetName, localURL: localURL)
        
        default:
            print("Unhandled Segue: \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToCollectionViewController(segue:UIStoryboardSegue) {
        
    }
}

/************************************************************/
// MARK: - UIPickerViewDataSource
/************************************************************/

extension MainViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
}

/************************************************************/
// MARK: - UIPickerViewDelegate
/************************************************************/

extension MainViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItemTextField.text = items[row].title
        selectedItem = items[row]
    }
}
