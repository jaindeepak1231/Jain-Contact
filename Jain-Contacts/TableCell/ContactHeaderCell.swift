//
//  ContactHeaderCell.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 22/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit


class ContactHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_BG: UIImageView!
    @IBOutlet weak var img_Next: UIImageView!
        

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
