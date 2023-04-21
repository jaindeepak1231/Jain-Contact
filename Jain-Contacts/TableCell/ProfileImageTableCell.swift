//
//  ProfileImageTableCell.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 05/12/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

class ProfileImageTableCell: UITableViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var view_ImgBG: UIView!
    @IBOutlet weak var btn_ChangeProfile: UIButton!
    @IBOutlet weak var img_Edit: UIImageView!
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var constraint_imgBg_Height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.constraint_imgBg_Height.constant = (screenHeight/4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
