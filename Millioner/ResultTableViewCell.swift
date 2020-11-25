//
//  ResultTableViewCell.swift
//  Millioner
//
//  Created by Aleksandr Pavlov on 18.11.2020.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
