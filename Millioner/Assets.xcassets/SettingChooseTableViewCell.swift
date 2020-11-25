//
//  SettingChooseTableViewCell.swift
//  Millioner
//
//  Created by Aleksandr Pavlov on 26.11.2020.
//

import UIKit

class SettingChooseTableViewCell: UITableViewCell {
    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var isEnabled: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }

}
