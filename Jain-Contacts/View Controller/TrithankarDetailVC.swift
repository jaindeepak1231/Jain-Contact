//
//  TrithankarDetailVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 28/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

class TrithankarDetailVC: UIViewController {

    var strIndex = 0
    var strPredecessor = ""
    var strSuccessor = ""
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_age: UILabel!
    @IBOutlet weak var lbl_Born: UILabel!
    @IBOutlet weak var lbl_Died: UILabel!
    @IBOutlet weak var lbl_color: UILabel!
    @IBOutlet weak var lbl_Parents: UILabel!
    @IBOutlet weak var lbl_Symbol: UILabel!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Inner: UIView!
    @IBOutlet weak var lbl_TrithnkarName: UILabel!
    @IBOutlet weak var lbl_TrithnkarIndex: UILabel!
    @IBOutlet weak var lbl_venerated: UILabel!
    @IBOutlet weak var lbl_successor_title: UILabel!
    @IBOutlet weak var lbl_predecessor_title: UILabel!
    @IBOutlet weak var lbl_predecessor: UILabel!
    @IBOutlet weak var lbl_successor: UILabel!
    
    
    var dicDetail = HomeListData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let str_Index = NumericToString(self.strIndex)
        self.view_Main.layer.cornerRadius = 20
        self.view_Inner.layer.cornerRadius = 20
        self.lbl_Title.text = self.dicDetail.name
        self.lbl_TrithnkarName.text = self.dicDetail.name
        
        if self.lbl_TrithnkarName.text == First_Tirthankar {
            self.lbl_predecessor.text = ""
            self.lbl_predecessor_title.text = ""
        }
        else if self.lbl_TrithnkarName.text == TwentyFour_Tirthankar {
            self.lbl_successor.text = ""
            self.lbl_successor_title.text = ""
        }
        
        self.lbl_venerated.text = "Jainism"
        self.lbl_successor.text = self.strSuccessor
        self.lbl_predecessor.text = self.strPredecessor
        
        self.lbl_age.text = self.dicDetail.age
        self.lbl_Symbol.text = self.dicDetail.symbol
        self.lbl_color.text = self.dicDetail.colour
        
        self.lbl_Died.text = self.dicDetail.died
        self.lbl_Born.text = self.dicDetail.birth_place
        
        self.lbl_TrithnkarIndex.text = "\(str_Index) Jain Tirthankara"
        self.lbl_Parents.text = "\(self.dicDetail.f_name ?? "") (father)\n\(self.dicDetail.m_name ?? "") (mother)"
        
        self.btn_Back.setImage(#imageLiteral(resourceName: "back").tint(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: UIControl.State.normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - UIButton Mathod Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
