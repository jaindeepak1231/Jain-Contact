//
//  ContactTableCell.swift
//  demo
//
//  Created by Zignuts Technolab on 20/11/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import UIKit


class ContactTableCell: UITableViewCell {

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var view_imgBG: UIView!
    @IBOutlet weak var lbl_Mobile: UILabel!
    @IBOutlet weak var lbl_areaName: UILabel!
    @IBOutlet weak var img_Phone: UIImageView!
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var lbl_Underline: UILabel!
    

    let underLineAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.white,                                                                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    var listData: HeadListData? {
        
        didSet {
            let strMobile = listData?.mobile ?? ""
            self.lbl_Name.text = listData?.fullName?.capitalized
            self.lbl_areaName.text = listData?.family_name?.uppercased()
            
            let attributeString = NSMutableAttributedString(string: strMobile, attributes: underLineAttributes)
            self.lbl_Mobile.attributedText = attributeString
            
//            if let imageURI = listData?.image, imageURI != ""{
//                self.img_Profile.af_setImage(withURL: URL.init(string: imageURI)!)
//            }else{
//                self.imgUserView.image = self.isFromCourier == false ? #imageLiteral(resourceName: "ic_user_default") : #imageLiteral(resourceName: "ic_courier_default")
//            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        self.img_Profile.layer.cornerRadius = self.img_Profile.frame.height/2
        self.img_Profile.layer.masksToBounds = false
        
        self.view_imgBG.layer.cornerRadius = self.view_imgBG.frame.height/2
        self.view_imgBG.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
