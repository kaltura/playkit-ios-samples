//
//  IMASettingsTableViewCell.swift
//  PlayKitApp
//
//  Created by Vadim Kononov on 08/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit

class IMASettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func populate(_ text: String, isSelected: Bool) {
        label.text = text
        icon.isHidden = !isSelected
    }
}
