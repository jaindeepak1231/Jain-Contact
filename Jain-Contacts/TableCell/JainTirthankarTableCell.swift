//
//  JainTirthankarTableCell.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 28/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

class JainTirthankarTableCell: UITableViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img_arrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.img_arrow.image = #imageLiteral(resourceName: "next").tint(with: UIColor.groupTableViewBackground)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
