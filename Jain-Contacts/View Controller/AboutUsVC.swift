//
//  AboutUsVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 25/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class AboutUsVC: UIViewController, Storyboardable, SideMenuItemContent {

    @IBOutlet weak var btn_SideMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    @IBAction func btnSideMenu_Action(_ sender: UIButton) {
        showSideMenu()
    }

}
