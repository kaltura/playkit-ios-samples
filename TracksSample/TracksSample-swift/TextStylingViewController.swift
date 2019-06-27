//
//  TextStylingViewController.swift
//  TracksSample-swift
//
//  Created by Nilit Danan on 5/21/19.
//  Copyright © 2019 kaltura. All rights reserved.
//

import Foundation
import UIKit
import PlayKit

enum PickerView: Int {
    case textColor = 1
    case backgroundColor = 2
    case edgeStyle = 3
    case edgeColor = 4
    case fontFamily = 5
}

class TextStylingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let defaultTextSize = 10
    
    var player: Player?
    
    typealias Color = (value: UIColor, name: String)
    let colors: [Color] = [(UIColor.red, "Red"),
                           (UIColor.blue, "Blue"),
                           (UIColor.black, "Black"),
                           (UIColor.white, "White"),
                           (UIColor.clear, "Clear")]
    typealias Style = (value: PKTextMarkupCharacterEdgeStyle, name: String)
    let edgeStyles: [Style] = [(.none, "None"),
                               (.raised, "Raised"),
                               (.depressed, "Depressed"),
                               (.uniform, "Uniform"),
                               (.dropShadow, "Drop Shadow")]
    let fontsFamily = ["Helvetica", "Arial", "Courier", "Georgia", "Avenir"]
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var textColorPickerView: UIPickerView!
    @IBOutlet weak var backgroundColorPickerView: UIPickerView!
    @IBOutlet weak var textSizeTextField: UITextField!
    @IBOutlet weak var edgeStylePickerView: UIPickerView!
    @IBOutlet weak var edgeColorPickerView: UIPickerView!
    @IBOutlet weak var fontFamilyPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(applyClicked))
        rightBarButtonItem.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        backgroundColorPickerView.selectRow(3, inComponent: 0, animated: false)
        edgeColorPickerView.selectRow(2, inComponent: 0, animated: false)
        edgeColorPickerView.isUserInteractionEnabled = false // currently not working on AVPlayer
        
        setupLabel()
    }
    
    func setupLabel() {
        captionLabel.textColor = colors[textColorPickerView.selectedRow(inComponent: 0)].value
        captionLabel.backgroundColor = colors[backgroundColorPickerView.selectedRow(inComponent: 0)].value
        updateEdgeStyle(to: edgeStyles[edgeStylePickerView.selectedRow(inComponent: 0)].value)
//        edgeColor - currently not working on AVPlayer
        captionLabel.font = UIFont(name: fontsFamily[fontFamilyPickerView.selectedRow(inComponent: 0)], size: calculateFontSize())
    }
    
    func calculateFontSize() -> CGFloat {
        var textSize: Float
        if let size = textSizeTextField.text {
            textSize = Float(size) ?? Float(defaultTextSize)
        } else {
            textSize = Float(defaultTextSize)
        }
        
        let percentTextSize: Float = Float(videoView.frame.size.height) * textSize / 100
        
        return CGFloat(percentTextSize)
    }
    
    func updateEdgeStyle(to type: PKTextMarkupCharacterEdgeStyle) {
        switch type {
        case .none:
            captionLabel.shadowOffset = CGSize(width: 0, height: 0)
        case .raised:
            captionLabel.shadowOffset = CGSize(width: -1, height: 1)
        case .depressed:
            captionLabel.shadowOffset = CGSize(width: 1, height: -1)
        case .uniform:
            captionLabel.shadowOffset = CGSize(width: 0, height: 0)
        case .dropShadow:
            captionLabel.shadowOffset = CGSize(width: 0, height: 1)
        }
    }
    
    @objc func applyClicked() {
        let textColor = colors[textColorPickerView.selectedRow(inComponent: 0)]
        let backgroundColor = colors[backgroundColorPickerView.selectedRow(inComponent: 0)]
        let textSize = Int(textSizeTextField.text ?? defaultTextSize.description) ?? defaultTextSize
        let edgeStyle = edgeStyles[edgeStylePickerView.selectedRow(inComponent: 0)]
        let edgeColor = colors[edgeColorPickerView.selectedRow(inComponent: 0)]
        let fontFamily = fontsFamily[fontFamilyPickerView.selectedRow(inComponent: 0)]
        
        player?.settings.textTrackStyling
            .setTextColor(textColor.value)
            .setBackgroundColor(backgroundColor.value)
            .setTextSize(percentageOfVideoHeight: textSize)
            .setEdgeStyle(edgeStyle.value)
            .setEdgeColor(edgeColor.value)
            .setFontFamily(fontFamily)
        player?.updateTextTrackStyling()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case PickerView.textColor.rawValue, PickerView.backgroundColor.rawValue, PickerView.edgeColor.rawValue:
            return colors[row].name
        case PickerView.edgeStyle.rawValue:
            return edgeStyles[row].name
        case PickerView.fontFamily.rawValue:
            return fontsFamily[row]
        default:
            break
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case PickerView.textColor.rawValue:
            captionLabel.textColor = colors[row].value
        case PickerView.backgroundColor.rawValue:
            captionLabel.backgroundColor = colors[row].value
        case PickerView.edgeStyle.rawValue:
            updateEdgeStyle(to: edgeStyles[row].value)
        case PickerView.edgeColor.rawValue:
            break // currently not working on AVPlayer
        case PickerView.fontFamily.rawValue:
            captionLabel.font = UIFont(name: fontsFamily[row], size: calculateFontSize())
            break
        default:
            break
        }
    }

    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case PickerView.textColor.rawValue, PickerView.backgroundColor.rawValue, PickerView.edgeColor.rawValue:
            return colors.count
        case PickerView.edgeStyle.rawValue:
            return edgeStyles.count
        case PickerView.fontFamily.rawValue:
            return fontsFamily.count
        default:
            break
        }
        return 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        captionLabel.font = UIFont(name: fontsFamily[fontFamilyPickerView.selectedRow(inComponent: 0)], size: calculateFontSize())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textSizeTextField.resignFirstResponder()
        return true
    }
}
