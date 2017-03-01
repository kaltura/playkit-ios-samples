//
//  Downloader.swift
//  PlayKitApp
//
//  Created by Eliza Sapir on 19/02/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import AVFoundation

class Downloader: NSObject, URLSessionDownloadDelegate {
    var onDownloadFinishBlock: ((String)->Void)?
    
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString,
            let destinationURL = localFilePathForUrl(previewUrl: originalURL) {
            
            print(destinationURL)
            
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: destinationURL as URL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
            do {
                try fileManager.copyItem(at: location, to: destinationURL as URL)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
            
            onDownloadFinishBlock?(destinationURL.absoluteString!)
        }
    }
    
    func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), let lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }

    var url: String
    var progress: Float = 0.0
    var destinationURL: URL?
    
    var downloadTask: URLSessionDownloadTask?
    var resumeData: NSData?
    
    init(url: String) {
        self.url = url
    }
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

        return session
    }()

    func startDownload(asset: Asset?, block: ((String)->Void)?) {
        if let urlString = asset?.url, let url =  NSURL(string: urlString) {
            onDownloadFinishBlock = block
            let download = Downloader(url: urlString)
            download.downloadTask = downloadsSession.downloadTask(with: url as URL)
            download.downloadTask!.resume()
        }
    }
}
