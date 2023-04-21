//
//  FilterCollectionCell.swift
//  xkeeper
//
//  Created by Zignuts Technolab on 04/09/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import UIKit

class FilterCollectionCell: UICollectionViewCell {

    @IBOutlet weak var view_BG: UIView!
    @IBOutlet weak var btnDeleteFilter: UIButton!
    @IBOutlet weak var lbl_filterTitle: UILabel!
    @IBOutlet weak var constraint_height: NSLayoutConstraint!
    @IBOutlet weak var constraint_leading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.constraint_leading.constant = 16
    }

}
