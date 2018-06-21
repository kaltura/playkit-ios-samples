//
//  TracksViewController.swift
//  AVAssetDownloadSample
//
//  Created by Nilit Danan on 4/26/18.
//  Copyright © 2018 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit
import AVFoundation

enum TracksSection: Int {
    case Audio = 0
    case Subtitle

    case COUNT
}

class TracksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mediaEntry: PKMediaEntry?
    var localURL: URL?
    var asset: AVURLAsset?
    
    var subtitleArray: [(language: String, title: String)] = []
    var audioArray: [(language: String, title: String)] = []
    
    var selectedTextLanguageIndex: Int = 0
    var selectedAudioLanguageIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TracksTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        guard let localURL = localURL else {
            return
        }
        
        asset = AVURLAsset(url: localURL)
        setupSubtitleArray()
        setupAudioArray()
        
        tableView.reloadData()
        
        tableView.selectRow(at: IndexPath(row: selectedAudioLanguageIndex, section: TracksSection.Audio.rawValue), animated: false, scrollPosition: UITableViewScrollPosition.none)
        tableView.selectRow(at: IndexPath(row: selectedTextLanguageIndex, section: TracksSection.Subtitle.rawValue), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
    
    // MARK: - Private
    
    private func setupSubtitleArray() {
        guard let tracks = asset?.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)?.options else {
            return
        }
        
        for track in tracks {
            let language = track.extendedLanguageTag ?? ""
            let title = track.displayName
            subtitleArray.append((language: language, title: title))
        }
    }
    
    private func setupAudioArray() {
        guard let tracks = asset?.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible)?.options else {
            return
        }
        
        for track in tracks {
            let language = track.extendedLanguageTag ?? ""
            let title = track.displayName
            audioArray.append((language: language, title: title))
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "PlayDownloadedItemSegue"?:
            guard let destinationViewController = segue.destination as? MediaPlayerViewController else {
                return
            }
            
            destinationViewController.mediaEntry = mediaEntry
            destinationViewController.selectedAudio = audioArray[selectedAudioLanguageIndex].language
            destinationViewController.selectedSubtitle = subtitleArray[selectedTextLanguageIndex].language
            
        default:
            print("Unhandled Segue: \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TracksSection.COUNT.rawValue
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TracksSection.Audio.rawValue:
            let count = audioArray.count
            return count
        case TracksSection.Subtitle.rawValue:
            let count = subtitleArray.count
            return count
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TracksTableViewCell", for: indexPath)
        cell.isSelected = false
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        
        switch indexPath.section {
        case TracksSection.Audio.rawValue:
            cell.textLabel?.text = audioArray[indexPath.row].title
        case TracksSection.Subtitle.rawValue:
            cell.textLabel?.text = subtitleArray[indexPath.row].title
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case TracksSection.Audio.rawValue:
            return "Select Audio"
        case TracksSection.Subtitle.rawValue:
            return "Select Subtitle"
        default:
            return ""
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section {
        case TracksSection.Audio.rawValue:
            if indexPath.row == selectedAudioLanguageIndex {
                return nil
            }
        case TracksSection.Subtitle.rawValue:
            if indexPath.row == selectedTextLanguageIndex {
                return nil
            }
        default:
            return indexPath
        }
        
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case TracksSection.Audio.rawValue:
            tableView.deselectRow(at: IndexPath(row:selectedAudioLanguageIndex, section: TracksSection.Audio.rawValue), animated: true)
            selectedAudioLanguageIndex = indexPath.row
        case TracksSection.Subtitle.rawValue:
            tableView.deselectRow(at: IndexPath(row: selectedTextLanguageIndex, section: TracksSection.Subtitle.rawValue), animated: true)
            selectedTextLanguageIndex = indexPath.row
        default:
            return
        }
    }
}
