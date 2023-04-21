//
//  AnotherFileldTableCell.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 05/12/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

class AnotherFileldTableCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_edit: UIImageView!
    @IBOutlet weak var txt_value: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
