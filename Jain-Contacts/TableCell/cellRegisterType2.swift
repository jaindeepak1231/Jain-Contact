//
//  cellRegisterType2.swift
//  Comedie
//
//  Created by Zignuts Technolab on 09/05/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import UIKit

class cellRegisterType2: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var collectionGender: UICollectionView!
    
    @IBOutlet var constarintLblLeading: NSLayoutConstraint!
    @IBOutlet var constarintLblTop: NSLayoutConstraint!
    @IBOutlet var constarintLblBottom: NSLayoutConstraint!
    @IBOutlet var constarintColBottom: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //***Register Cell*****//
        self.collectionGender.register(UINib.init(nibName: "cellGenderCollection", bundle: nil), forCellWithReuseIdentifier: "cellGenderCollection")
        //========//
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
