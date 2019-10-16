//
//  FairPlayServer.swift
//  MacFairPlayer
//
//  Created by Noam Tamim on 10/06/2019.
//  Copyright © 2019 Noam Tamim. All rights reserved.
//

import Foundation

@objc public protocol FairPlayLicenseProvider {
    @objc func getLicense(spc: Data, assetId: String, url: URL, headers: [String:String],
                          callback: @escaping (_ ckc: Data?, _ offlineDuration: TimeInterval, _ error: Error?) -> Void)
}


struct KalturaLicenseResponseContainer: Codable {
    var ckc: String?
    var persistence_duration: TimeInterval?
}

enum FPSServerError: Error {
    case drmServerError(_ error: Error, _ url: URL)
}

class KalturaFairPlayLicenseProvider: FairPlayLicenseProvider {
    
    static let sharedInstance = KalturaFairPlayLicenseProvider()
    
    func getLicense(spc: Data, assetId: String, url: URL, headers: [String:String], callback: @escaping (Data?, TimeInterval, Error?) -> Void) {
        var request = URLRequest(url: url)
        for (header, value) in headers {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        // If a specific content-type was requested by the adapter, use it. 
        // Otherwise, the uDRM requires application/octet-stream.
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = spc.base64EncodedData()
        request.httpMethod = "POST"
        
        print("Sending SPC to server")
        let startTime = Date.timeIntervalSinceReferenceDate
        let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let error = error {
                callback(nil, 0, FPSServerError.drmServerError(error, url))
                return
            }
            
            do {
                let endTime: Double = Date.timeIntervalSinceReferenceDate
                print("Got response in \(endTime-startTime) sec")
                
                guard let data = data else {
                    callback(nil, 0, NSError(domain: "KalturaFairPlayLicenseProvider", code: 1, userInfo: nil))
                    return
                }
                
                let lic = try JSONDecoder().decode(KalturaLicenseResponseContainer.self, from: data)
                callback(Data(base64Encoded: lic.ckc ?? ""), lic.persistence_duration ?? 0, nil)
                
            } catch let e {
                callback(nil, 0, e)
            }
        }
        dataTask.resume()
    }
}

class FormFairPlayLicenseProvider: NSObject, FairPlayLicenseProvider {
    
    let customData: String
    
    init(_ customData: String) {
        self.customData = customData
    }
    
    func getLicense(spc: Data, assetId: String, url: URL, headers: [String:String], callback: @escaping (Data?, TimeInterval, Error?) -> Void) {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpBody = "assetid=\(assetId)&spc=\(spc.base64EncodedString())".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        for (header, value) in headers {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(customData, forHTTPHeaderField: "customData")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle HTTP error
            if error != nil {
                callback(nil, 0, error)
                return
            }
            
            // ASSUMING the response data is base64-encoded CKC.
            guard let data = data, let ckc = Data(base64Encoded: data) else {
                callback(nil, 0, NSError(domain: "FormPostFairPlayLicenseProvider", code: 1, userInfo: nil));
                return
            }
            
            callback(ckc, /* offline duration */ 0, nil)
            }.resume()
    }
}

