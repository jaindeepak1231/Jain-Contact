//
//  ButtonTableCell.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 13/12/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

class ButtonTableCell: UITableViewCell {

    @IBOutlet weak var btn_Submit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
