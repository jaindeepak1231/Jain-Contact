//
//  LoginVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 17/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit
import AccountKit
import InteractiveSideMenu

class LoginVC: UIViewController, Storyboardable, SideMenuItemContent {

    var strMobileNo = ""
    var accountKit: AKFAccountKit!
    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var btn_SideMenu: UIButton!
    @IBOutlet weak var activityIndicate: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.strMobileNo = "1111111111"
        
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
    }
    
    //==========================//
    func StartactivityLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.isUserInteractionEnabled = false
        }) { (finish) in
            self.activityIndicate.startAnimating()
        }
    }
    
    func StopactivityLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.isUserInteractionEnabled = true
        }) { (finish) in
            self.activityIndicate.stopAnimating()
        }
    }
    //**************************//
    
    //MARK:- Prepare LoginViewController
    func prepareLoginViewController( viewController: AKFViewController){
        viewController.delegate = self
        viewController.enableGetACall = true
        viewController.uiManager = AKFSkinManager.init(skinType: AKFSkinType.contemporary, primaryColor: UIColor.black)
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
    @IBAction func btnLogin_Action(_ sender: UIButton) {
        self.APICallForLogin()
        return
        let inputState: String = UUID().uuidString
        let viewController = self.accountKit.viewControllerForPhoneLogin(with: nil, state: inputState)
        self.prepareLoginViewController(viewController: viewController)
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnSideMenu_Action(_ sender: UIButton) {
        showSideMenu()
    }

}


//MARK: - Account Kit Delegate Method

extension LoginVC: AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        debugPrint("[Mobile] viewControllerDidCancel")
    }
    
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        debugPrint("[Mobile] didFailWithError \(error!)")
        //ShowNotification("", error.localizedDescription)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        print("tokenString:",accessToken.tokenString)
        print(state.debugDescription)
        self.accountKit.requestAccount { (account, error) in
            if(error != nil){
                //error while fetching information
                print("[Mobile Login] Error :: \((error?.localizedDescription)!)")
            }else{
                print("[Mobile Login] Account ID  \(account?.accountID ?? "")")
                ///DismissProgressHud()
                if let phoneNum = account?.phoneNumber{
                    
                    self.strMobileNo = "\(phoneNum.phoneNumber)"
                    print("[Mobile Login] Phone Number:-\("+" + phoneNum.countryCode + " " + phoneNum.phoneNumber)")
                    
                    self.APICallForLogin()
                    
                    
                    
                }
            }
        }
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        
        print(code)
        print(state)
    }
    
    
    //MARK:- API Call
    @objc func APICallForLogin() {

        StartactivityLoading()

        let strURL = "\(k_BaseURL)checkMobileNumberExists&mobile=\(self.strMobileNo)"
        
        print("Api for Login:---->>\(strURL)")
        
        ServerCall.sharedInstance.ServieceWithURl(methodType: .get, processView: self, baseView: self, proccesTitle: MSG_PleaseWait, api: strURL) { (JSON, data) in
            
            DispatchQueue.main.async {
                
                if let status = JSON?["success"] as? Int, status == 1 {
                    if let dicData = (JSON?["result"] as? NSDictionary) {
                        _userDefault.set(true, forKey: eUserDefaultsKey.key_isLogin.rawValue)
                        _userDefault.set(dicData, forKey: "User_Data")
                        let objHost = self.storyboard?.instantiateViewController(withIdentifier: "HostViewController") as! HostViewController
                        self.navigationController?.pushViewController(objHost, animated: true)
                    }
                    else {
                        let objRegister = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                        objRegister.strMobileNo = self.strMobileNo
                        self.navigationController?.pushViewController(objRegister, animated: true)
                    }
                }
                else {
                    self.view.makeToast(JSON?["msg"] as? String ?? "Connection failed, please try again!")
                }
                
                self.StopactivityLoading()
            }
        }
    }
}









