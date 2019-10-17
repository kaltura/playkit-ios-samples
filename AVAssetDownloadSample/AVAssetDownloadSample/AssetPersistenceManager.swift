/*
 `AssetPersistenceManager` is the main class in this sample that demonstrates how to manage downloading HLS streams.  
 It includes APIs for starting and canceling downloads, deleting existing assets off the users device, and monitoring 
 the download progress.
 This class can be copied to the application's code, and modified to fit particular needs. It was derived from Apple's
 "HLSCatalog" sample app, with minimal changes and fixes.
 
 When downloading a new asset, this implementation first downloads the main video in low resolution (265000bps), then 
 downloads all additional media selections (subtitles, audio). This logic SHOULD be customized to fit app needs.
 
 */

import Foundation
import AVFoundation

/// Notification for when download progress has changed.
let AssetDownloadProgressNotification: NSNotification.Name = NSNotification.Name(rawValue: "AssetDownloadProgressNotification")

/// Notification for when the download state of an Asset has changed.
let AssetDownloadStateChangedNotification: NSNotification.Name = NSNotification.Name(rawValue: "AssetDownloadStateChangedNotification")

/// Notification for when AssetPersistenceManager has completely restored its state.
let AssetPersistenceManagerDidRestoreStateNotification: NSNotification.Name = NSNotification.Name(rawValue: "AssetPersistenceManagerDidRestoreStateNotification")

class AssetPersistenceManager: NSObject {
    // MARK: Properties
    
    /// Singleton for AssetPersistenceManager.
    static let sharedManager = AssetPersistenceManager()
    
    /// Internal Bool used to track if the AssetPersistenceManager finished restoring its state.
    private var didRestorePersistenceManager = false
    
    /// The AVAssetDownloadURLSession to use for managing AVAssetDownloadTasks.
    fileprivate var assetDownloadURLSession: AVAssetDownloadURLSession!
    
    /// Internal map of AVAssetDownloadTask to its corresponding Asset.
    fileprivate var activeDownloadsMap = [AVAssetDownloadTask : Asset]()
    
    /// Internal map of AVAssetDownloadTask to its resoled AVMediaSelection
    fileprivate var mediaSelectionMap = [AVAssetDownloadTask : AVMediaSelection]()
    
    // MARK: Intialization
    
    override private init() {
        
        super.init()
        
        // Create the configuration for the AVAssetDownloadURLSession.
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "AAPL-Identifier")
        
        // Create the AVAssetDownloadURLSession using the configuration.
        assetDownloadURLSession = AVAssetDownloadURLSession(configuration: backgroundConfiguration, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
    }
    
    /// Restores the Application state by getting all the AVAssetDownloadTasks and restoring their Asset structs.
    func restorePersistenceManager() {
        guard !didRestorePersistenceManager else { return }
        
        didRestorePersistenceManager = true
        
        // Grab all the tasks associated with the assetDownloadURLSession
        assetDownloadURLSession.getAllTasks { tasksArray in
            // For each task, restore the state in the app by recreating Asset structs and reusing existing AVURLAsset objects.
            for task in tasksArray {
                guard let assetDownloadTask = task as? AVAssetDownloadTask, let assetName = task.taskDescription else { break }
                
                let asset = Asset(name: assetName, urlAsset: assetDownloadTask.urlAsset)
                self.activeDownloadsMap[assetDownloadTask] = asset
            }
            
            NotificationCenter.default.post(name: AssetPersistenceManagerDidRestoreStateNotification, object: nil)
        }
    }
    
    /// Triggers the initial AVAssetDownloadTask for a given Asset.
    func downloadStream(for asset: Asset) {
        /*
         For the initial download, we ask the URLSession for an AVAssetDownloadTask
         with a minimum bitrate corresponding with one of the lower bitrate variants
         in the asset.
         */
        guard let task = assetDownloadURLSession.makeAssetDownloadTask(asset: asset.urlAsset, assetTitle: asset.name, assetArtworkData: nil, options: [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 265000]) else {
            fatalError("Failed to create download task")
        }
        
        // To better track the AVAssetDownloadTask we set the taskDescription to something unique for our sample.
        task.taskDescription = asset.name
        
        activeDownloadsMap[task] = asset
        
        task.resume()
        
        var userInfo = [String: Any]()
        userInfo[Asset.Keys.name] = asset.name
        userInfo[Asset.Keys.downloadState] = Asset.DownloadState.downloading.rawValue
        
        NotificationCenter.default.post(name: AssetDownloadStateChangedNotification, object: nil, userInfo:  userInfo)
    }
    
    /// Returns an Asset given a specific name if that Asset is asasociated with an active download.
    func assetForStream(withName name: String) -> Asset? {
        var asset: Asset?
        
        for (_, assetValue) in activeDownloadsMap {
            if name == assetValue.name {
                asset = assetValue
                break
            }
        }
        
        return asset
    }
    
    /// Returns an Asset pointing to a file on disk if it exists.
    func localAssetForStream(withName name: String) -> Asset? {
        let userDefaults = UserDefaults.standard
        guard let localFileLocation = userDefaults.value(forKey: name) as? Data else {
            print("Not downloaded")
            return nil 
        }
        
        var asset: Asset?
        var bookmarkDataIsStale = false
        do {
            let url = try URL(resolvingBookmarkData: localFileLocation, bookmarkDataIsStale: &bookmarkDataIsStale)
            
            if bookmarkDataIsStale {
                fatalError("Bookmark data is stale!")
            }
            
            asset = Asset(name: name, urlAsset: AVURLAsset(url: url))
            
            return asset
        } catch  {
            fatalError("Failed to create URL from bookmark with error: \(error)")
        }
    }
    
    /// Returns the current download state for a given Asset.
    func downloadState(for assetName: String) -> Asset.DownloadState {
        // Check if there is a file URL stored for this asset.
        if let localFileLocation = localAssetForStream(withName: assetName)?.urlAsset.url {
            // Check if the file exists on disk
            if FileManager.default.fileExists(atPath: localFileLocation.path) {
                return .downloaded
            }
        }
        
        // Check if there are any active downloads in flight.
        for (_, assetValue) in activeDownloadsMap {
            if assetName == assetValue.name {
                return .downloading
            }
        }
        
        return .notDownloaded
    }
    
    /// Deletes an Asset on disk if possible.
    func deleteAsset(_ asset: Asset) {
        let userDefaults = UserDefaults.standard
        
        do {
            if let localFileLocation = localAssetForStream(withName: asset.name)?.urlAsset.url {
                try FileManager.default.removeItem(at: localFileLocation)
                
                userDefaults.removeObject(forKey: asset.name)
                
                var userInfo = [String: Any]()
                userInfo[Asset.Keys.name] = asset.name
                userInfo[Asset.Keys.downloadState] = Asset.DownloadState.notDownloaded.rawValue
                
                NotificationCenter.default.post(name: AssetDownloadStateChangedNotification, object: nil, userInfo:  userInfo)
            }
        } catch {
            print("An error occured deleting the file: \(error)")
        }
    }
    
    /// Cancels an AVAssetDownloadTask given an Asset.
    func cancelDownload(for asset: Asset) {
        var task: AVAssetDownloadTask?
        
        for (taskKey, assetVal) in activeDownloadsMap {
            if asset == assetVal  {
                task = taskKey
                break
            }
        }
        
        task?.cancel()
    }
    
    // MARK: Convenience
    
    typealias MediaSelectionPair = (group: AVMediaSelectionGroup?, option: AVMediaSelectionOption?)
    fileprivate var mediaSelectionOptions = [AVURLAsset: [MediaSelectionPair]]()
    
    fileprivate func buildSelectionOptions(for asset: AVURLAsset) {
        
        if mediaSelectionOptions[asset] != nil {
            return
        }

        var options = [MediaSelectionPair]()
        
        let mediaCharacteristics = [AVMediaCharacteristic.audible, AVMediaCharacteristic.legible]
        
        guard let assetCache = asset.assetCache else { return }
        for mediaCharacteristic in mediaCharacteristics {
            if let mediaSelectionGroup = asset.mediaSelectionGroup(forMediaCharacteristic: mediaCharacteristic) {
                let savedOptions = assetCache.mediaSelectionOptions(in: mediaSelectionGroup)
                
                if savedOptions.count < mediaSelectionGroup.options.count {
                    // There are still media options left to download.
                    for option in mediaSelectionGroup.options {
                        if !savedOptions.contains(option) && option.mediaType.rawValue != AVMediaType.closedCaption.rawValue {
                            // This option has not been downloaded.
                            options.append((mediaSelectionGroup, option))
                        }
                    }
                }
            }
        }
        
        let reversed = Array(options.reversed())
        
        mediaSelectionOptions[asset] = reversed
    }

    /**
     This function demonstrates returns the next `AVMediaSelectionGroup` and
     `AVMediaSelectionOption` that should be downloaded if needed. This is done
     by querying an `AVURLAsset`'s `AVAssetCache` for its available `AVMediaSelection`
     and comparing it to the remote versions.
     */
    fileprivate func nextMediaSelection(_ asset: AVURLAsset) -> MediaSelectionPair? {
        
        // PlayKit note: originally, this function iterates over all media selections every time it's called,
        // Looking for new things to download. This logic is slightly modified: we first build a list of all
        // additional selections, and then download all of them.
        buildSelectionOptions(for: asset)
        
        if var options = mediaSelectionOptions[asset] {
            if options.count > 0 {
                let selection = options.removeLast()
                mediaSelectionOptions[asset] = options
                return selection
            } else {
                return nil
            }
        }
        
        // At this point all media options have been downloaded.
        return nil
    }
}

/**
 Extend `AVAssetDownloadDelegate` to conform to the `AVAssetDownloadDelegate` protocol.
 */
extension AssetPersistenceManager: AVAssetDownloadDelegate {
    
    func postUpdate(_ userInfo: [String: Any]) {
        NotificationCenter.default.post(name: AssetDownloadStateChangedNotification, object: nil, userInfo: userInfo)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let userDefaults = UserDefaults.standard
        
        /*
         This is the ideal place to begin downloading additional media selections
         once the asset itself has finished downloading.
         */
        guard let task = task as? AVAssetDownloadTask, let asset = activeDownloadsMap.removeValue(forKey: task) else { return }
        
        // Prepare the basic userInfo dictionary that will be posted as part of our notification.
        var userInfo = [String: Any]()
        userInfo[Asset.Keys.name] = asset.name
        
        if let error = error as NSError? {
            print("An error occured: \(error)")
            
            switch error.domain {
            case AVFoundationErrorDomain:
                break
                
            case NSURLErrorDomain:
                switch error.code {
                case NSURLErrorCancelled:
                    /*
                     This task was canceled, you should perform cleanup using the
                     URL saved from AVAssetDownloadDelegate.urlSession(_:assetDownloadTask:didFinishDownloadingTo:).
                     */
                    guard let localFileLocation = localAssetForStream(withName: asset.name)?.urlAsset.url else { return }
                    
                    do {
                        try FileManager.default.removeItem(at: localFileLocation)
                        
                        userDefaults.removeObject(forKey: asset.name)
                    } catch {
                        print("An error occured trying to delete the contents on disk for \(asset.name): \(error)")
                    }
                    
                    userInfo[Asset.Keys.downloadState] = Asset.DownloadState.notDownloaded.rawValue
                default:
                    break
                }
            default:
                break
            }
            
            postUpdate(userInfo)
            return
        }

        guard let pair = nextMediaSelection(task.urlAsset), let group = pair.group, let option = pair.option else {
            // All additional media selections have been downloaded.
            userInfo[Asset.Keys.downloadState] = Asset.DownloadState.downloaded.rawValue
            postUpdate(userInfo)
            return
        }
                    
        /*
         This task did complete sucessfully. At this point the application
         can download additional media selections if needed.
         
         To download additional `AVMediaSelection`s, you should use the
         `AVMediaSelection` reference saved in `AVAssetDownloadDelegate.urlSession(_:assetDownloadTask:didResolve:)`.
         */
        
        guard let originalMediaSelection = mediaSelectionMap[task] else { return }
        
        /*
         There are still media selections to download.
         
         Create a mutable copy of the AVMediaSelection reference saved in
         `AVAssetDownloadDelegate.urlSession(_:assetDownloadTask:didResolve:)`.
         */
        let mediaSelection = originalMediaSelection.mutableCopy() as! AVMutableMediaSelection
        
        // Select the AVMediaSelectionOption in the AVMediaSelectionGroup we found earlier.
        mediaSelection.select(option, in: group)
        
        /*
         Ask the `URLSession` to vend a new `AVAssetDownloadTask` using
         the same `AVURLAsset` and assetTitle as before.
         
         This time, the application includes the specific `AVMediaSelection`
         to download as well as a higher bitrate.
         */
        guard let nextTask = assetDownloadURLSession.makeAssetDownloadTask(asset: task.urlAsset, assetTitle: asset.name, assetArtworkData: nil, options: [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 2000000, AVAssetDownloadTaskMediaSelectionKey: mediaSelection]) else { return }
        
        nextTask.taskDescription = asset.name
        
        activeDownloadsMap[nextTask] = asset
        
        nextTask.resume()
        
        userInfo[Asset.Keys.downloadState] = Asset.DownloadState.downloading.rawValue
        userInfo[Asset.Keys.downloadSelectionDisplayName] = option.displayName
        
        postUpdate(userInfo)
    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        let userDefaults = UserDefaults.standard
        
        /*
         This delegate callback should only be used to save the location URL
         somewhere in your application. Any additional work should be done in
         `URLSessionTaskDelegate.urlSession(_:task:didCompleteWithError:)`.
         */
        if let asset = activeDownloadsMap[assetDownloadTask] {
            
            do {
                let bookmark = try location.bookmarkData()
                
                userDefaults.set(bookmark, forKey: asset.name)
            } catch {
                print("Failed to create bookmark for location: \(location)")
                deleteAsset(asset)
            }
        }
    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        // This delegate callback should be used to provide download progress for your AVAssetDownloadTask.
        guard let asset = activeDownloadsMap[assetDownloadTask] else { return }
        
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange : CMTimeRange = value.timeRangeValue
            percentComplete += CMTimeGetSeconds(loadedTimeRange.duration) / CMTimeGetSeconds(timeRangeExpectedToLoad.duration)
        }
        
        var userInfo = [String: Any]()
        userInfo[Asset.Keys.name] = asset.name
        userInfo[Asset.Keys.percentDownloaded] = percentComplete
        
        NotificationCenter.default.post(name: AssetDownloadProgressNotification, object: nil, userInfo:  userInfo)
    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didResolve resolvedMediaSelection: AVMediaSelection) {
        /*
         You should be sure to use this delegate callback to keep a reference
         to `resolvedMediaSelection` so that in the future you can use it to
         download additional media selections.
         */
        mediaSelectionMap[assetDownloadTask] = resolvedMediaSelection
    }
}
