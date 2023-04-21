//
//  UpdateVersionVC.swift
//  xkeeper
//
//  Created by Zignuts Technolab on 05/11/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import UIKit

class UpdateVersionVC: UIViewController {

    var strNewVersion = ""
    //<<====================IBOutlets====================>>//
    @IBOutlet weak var lbl_currentVersion: UILabel!
    @IBOutlet weak var lblNew_VersioTxt: UILabel!
    @IBOutlet weak var btn_Update: UIButton!
    @IBOutlet weak var btn_Skip: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.lbl_currentVersion.text = "Application Version : \(appVersion)"
        }
        
        self.lblNew_VersioTxt.text = "Update \(strNewVersion) is available to download.                                 Downloading the latest version you will get the latest feature, improvements, and bug fixes of Xkeeper application."
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openURL(_ strURL: String, _ title: String) {
        DispatchQueue.main.async {
            if let checkURL = NSURL(string: strURL) {
                UIApplication.shared.open(checkURL as URL, options: [:], completionHandler: nil)
            } else {
                print("Invalid URL")
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UIButto Method Action
    @IBAction func btnUpdate_Action(_ sender: UIButton) {
        self.openURL("https://itunes.apple.com/us/app/xkeeper/id1440361703?ls=1&mt=8", "")
    }
    
    @IBAction func btnSKip_Action(_ sender: UIButton) {
        //app_Delegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }

}
