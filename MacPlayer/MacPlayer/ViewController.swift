//
//  ViewController.swift
//  MacPlayer
//
//  Created by Noam Tamim on 12/06/2019.
//  Copyright © 2019 Noam Tamim. All rights reserved.
//

import Cocoa
import AVKit

struct Asset: Codable {
    let url: String
    let drm: [DRMParams]
    
    struct DRMParams: Codable {
        let certificate: String
        let licenseURL: String
        let customData: String?
        let serverProtocol: UInt?
    }
}


class ViewController: NSViewController {

    @IBOutlet weak var certBase64: NSTextField!
    @IBOutlet weak var contentURL: NSTextField!
    @IBOutlet weak var licenseURL: NSTextField!
    @IBOutlet weak var customData: NSTextField!
    @IBOutlet weak var serverProtocol: NSPopUpButton!
    
    var player: PlayerViewController?
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        guard let player = segue.destinationController as? PlayerViewController else {return}
        
        
        self.player = player
        
        player.asset = makeAsset()
    }
    
    func makeAsset() -> Asset {
        let drm = Asset.DRMParams(certificate: certBase64.stringValue, 
                                  licenseURL: licenseURL.stringValue, 
                                  customData: customData.stringValue, 
                                  serverProtocol: UInt(serverProtocol.indexOfSelectedItem))
        return Asset(url: contentURL.stringValue, drm: [drm])        
    }
    
    @IBAction func clear(_ sender: Any) {
        for control in [certBase64, contentURL, licenseURL, customData] {
            control?.stringValue = ""
        }
        serverProtocol.selectItem(at: 0)
    }
    
    @IBAction func `import`(_ sender: Any) {
        
        clear(self)
        
        guard let text = NSPasteboard.general.string(forType: .string) else {return}
        guard let data = text.trimmingCharacters(in: CharacterSet(charactersIn: ",")).data(using: .utf8) else {return}
        
        do {
            let asset = try JSONDecoder().decode(Asset.self, from: data)

            guard let drm = asset.drm.first else {return}
            
            contentURL.stringValue = asset.url
            certBase64.stringValue = drm.certificate
            licenseURL.stringValue = drm.licenseURL
            customData.stringValue = drm.customData ?? ""
            
            if let serverIndex = drm.serverProtocol, serverIndex < serverProtocol.numberOfItems {
                serverProtocol.selectItem(at: Int(serverIndex))
            }
            
        } catch {
            
        }
        
    }
    
    @IBAction func export(_ sender: Any) {
        do {
            let data = try JSONEncoder().encode(makeAsset())
//            guard let string = String(data: data, encoding: .utf8) else {return}
//            print(string)
            let pb = NSPasteboard.general
            pb.declareTypes([.string], owner: nil)
//            pb.setString(string, forType: .string)
            pb.setData(data, forType: .string)
        } catch {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewController.viewDidLoad")

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

