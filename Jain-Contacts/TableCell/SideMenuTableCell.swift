//
//  SideMenuTableCell.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 25/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

class SideMenuTableCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectedView.backgroundColor = selected ? #colorLiteral(red: 0, green: 0.7791629434, blue: 0.9159522653, alpha: 1) : UIColor.clear
        lbl_Title.textColor = selected ? #colorLiteral(red: 0, green: 0.7791629434, blue: 0.9159522653, alpha: 1) : UIColor.white
    }
    
}
