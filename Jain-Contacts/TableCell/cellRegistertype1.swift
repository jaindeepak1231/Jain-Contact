//
//  cellRegistertype1.swift
//  Comedie
//
//  Created by Zignuts Technolab on 09/05/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import UIKit
import Material

class cellRegistertype1: UITableViewCell {

   
    @IBOutlet var textField: TextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet var img_arrow: UIImageView!
    @IBOutlet var constraintLeading: NSLayoutConstraint!
    @IBOutlet var constraintTop: NSLayoutConstraint!
    @IBOutlet var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btncontinueLeading: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if textField != nil {
            self.textField.setDevider()
        }
        
//        if btnContinue != nil {
//            btncontinueLeading.constant = 50 * screenScale
//
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
//                let gradientAdvance = CAGradientLayer.init(frame: self.btnContinue.frame, colors: [#colorLiteral(red: 0.9725490196, green: 0.09019607843, blue: 0.4039215686, alpha: 1),#colorLiteral(red: 0.9411764706, green: 0.2666666667, blue: 0.2666666667, alpha: 1)], direction: .Right)
//                let imageAdvance = gradientAdvance.creatGradientImage()
//                self.btnContinue.backgroundColor = UIColor.init(patternImage: imageAdvance!)
//                self.btnContinue.shadowColor = #colorLiteral(red: 0.9725490196, green: 0.09019607843, blue: 0.4039215686, alpha: 1).withAlphaComponent(0.3)
                //self.btnContinue.RoundWithShadow = true
            })
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
