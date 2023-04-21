//
//  MyProfileVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 05/12/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit
import SDWebImage
import AccountKit
import SVProgressHUD
import InteractiveSideMenu

class MyProfileVC: UIViewController, Storyboardable, SideMenuItemContent {

    var strDOB = ""
    var strHeadID = ""
    var is_Save = false
    var changedImage = UIImage()
    var selectedIndexPath = IndexPath()
    var dicUserData = [String: Any]()
    var arrBloodGroup = ["A+", "O+", "B+", "AB+", "A-", "O-", "B-", "AB-"]
    var arrContent = ["Profile", k_mobile, k_email, k_dob, k_qualification, k_profession, k_family_members, k_blood_group]

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_editSave: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constraint_tblBottom: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    
    var accountKit: AKFAccountKit!
    var observingData = NSMutableDictionary()
    var dictParamForDataChange = NSMutableDictionary()
    
    var overlayImageView: UIImageView?
    var overlayDarkView: UIView?
    var selectedImageView: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        
        //Register Cell
        self.tblView.register(UINib.init(nibName: "ProfileImageTableCell", bundle: nil), forCellReuseIdentifier: "ProfileImageTableCell")
        
        self.tblView.register(UINib.init(nibName: "AnotherFileldTableCell", bundle: nil), forCellReuseIdentifier: "AnotherFileldTableCell")
        //***********************************************//
        
        
        if (_userDefault.dictionary(forKey: "User_Data") != nil) {
            self.dicUserData = _userDefault.dictionary(forKey: "User_Data") ?? [:]
            
            print(dicUserData)
            self.strHeadID = dicUserData["head_id"] as? String ?? ""
            if self.strHeadID != "1" {
                self.arrContent.remove(at: 6)
            }
            
            //***********************************************************************//
            //Set Data For Observing
            observingData["isPhotoUpdate"] = false
            observingData["id"] = self.dicUserData["id"] as? String ?? ""
            observingData["mobile"] = self.dicUserData["mobile"] as? String ?? ""
            observingData["image"] = self.dicUserData["image"] as? String ?? ""
            observingData["gender"] = self.dicUserData["gender"] as? String ?? ""
            observingData["fullName"] = self.dicUserData["fullName"] as? String ?? ""
            observingData["email"] = self.dicUserData["email"] as? String ?? ""
            observingData["dob"] = self.dicUserData["dob"] as? String ?? ""
            observingData["blood_group"] = self.dicUserData["blood_group"] as? String ?? ""
            observingData["profession"] = self.dicUserData["profession"] as? String ?? ""
            observingData["qualification"] = self.dicUserData["qualification"] as? String ?? ""
            observingData["nag_family_id"] = self.dicUserData["nag_family_id"] as? String ?? ""
            observingData["family_members"] = self.dicUserData["family_members"] as? String ?? ""
            //************************************************************************//
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    //MARK: Keyboard Function
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            self.constraint_tblBottom.constant = keyboardSize.height - 50
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.constraint_tblBottom.constant = 0
        }
    }
    
    //MARK:- Prepare LoginViewController
    func prepareLoginViewController( viewController: AKFViewController) {
        viewController.delegate = self
        viewController.enableGetACall = true
        viewController.uiManager = AKFSkinManager.init(skinType: AKFSkinType.contemporary, primaryColor: UIColor.black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let keys = observingData.map({$0.key as? String ?? ""})
        keys.forEach({ (key) in
            observingData.addObserver(self, forKeyPath: key, options: [.old, .new], context: nil)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let keys = observingData.map({$0.key as? String ?? ""})
        keys.forEach({ (key) in
            observingData.removeObserver(self, forKeyPath: key, context: nil)
        })
    }

    
    //=================================================================================//
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if change?[NSKeyValueChangeKey.newKey] as? String != change?[NSKeyValueChangeKey.oldKey] as? String {
            if let key = keyPath {
                self.dictParamForDataChange[key] = change?[NSKeyValueChangeKey.newKey] as? String
            }
        }
        else if change?[NSKeyValueChangeKey.newKey] as? Bool != change?[NSKeyValueChangeKey.oldKey] as? Bool {
            if let key = keyPath {
                self.dictParamForDataChange[key] = change?[NSKeyValueChangeKey.newKey] as? Bool
                print("Change Data", key)
            }
        }
    }
    //*********************************************************************************//
    //*********************************************************************************//
    
    
    //MARK: Call API for Update User Profile
    func callAPIforupdateProfile() {
        
        let strApiURL = k_BaseURL + "editMember"
        
        if let isPhoto = self.observingData["isPhotoUpdate"] as? Bool {
            
            self.observingData.removeObject(forKey: "image")
            self.observingData.removeObject(forKey: "isPhotoUpdate")
            
            if isPhoto != true {

                ServerCall.sharedInstance.ServieceWithURlandParameter(methodType: .post, processView: self, baseView: self, params: self.observingData as! [String : AnyObject], proccesTitle: MSG_PleaseWait, api: strApiURL) { (JSON, data) in
                    
                    self.getSuccessError(json: JSON)
                }
            }
            else {
                if let img_fileData = changedImage.jpegData(compressionQuality: 0.5) {
                    
                    ServerCall.sharedInstance.ServiceMultiPartWithUrlAndParameters(processView: self, baseView: self
                    , parameters: self.observingData as! [String : Any], proccesTitle: MSG_PleaseWait, api: strApiURL, fileParameterName: "user_pic", fileName: "image.jpg", fileData: img_fileData, mimeType: "image/jpeg") { (JSON, Data) in
                        
                        self.getSuccessError(json: JSON)

                    }
                }
            }
        }
    }
    
    func getSuccessError(json: NSDictionary?) {
        if (json?["success"] as? String) != nil {
            
            if let dicData = (json?["result"] as? NSDictionary) {
                _userDefault.set(dicData, forKey: "User_Data")
                self.dicUserData["image"] = dicData["image"] as? String ?? ""
            }
            self.is_Save = false
            self.btn_editSave.setImage(#imageLiteral(resourceName: "edit"), for: UIControl.State.normal)
        }
        else {
            self.view.makeToast(json?["error"] as? String ?? "Connection failed try again!")
        }
        SVProgressHUD.dismiss()
        self.tblView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: UITextField Delegate and Datasource Method
    //==============================================================================//
    //MARK :- UITextField Delegate Method===========================================//

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == 3 || textField.tag == 7 {
            return false
        }
//        if textField == txtName {
//            let maxLength = 100
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            if newString.length > maxLength {
//                return false
//            }
//            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//
//            return (string == filtered)
//        }
//
//
//        if textField == txtMobile {
//            let maxLength = 10
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            if newString.length > maxLength {
//                return false
//            }
//            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_NUMBERS).inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//
//            return (string == filtered)
//        }
//
        return true
    }
    
    @objc func didChangeValueField(_ textFild: UITextField) {
        var strKeys = ""
        if let strKey = textFild.accessibilityValue {
            if strKey == k_email {
                strKeys = "email"
            }
            else if strKey == k_qualification {
                strKeys = "qualification"
            }
            else if strKey == k_profession {
                strKeys = "profession"
            }
            self.dicUserData[strKeys] = textFild.text
            self.observingData[strKeys] = textFild.text
        }
    }
    
    //*********************************************************************************//
    //*********************************************************************************//
    //*********************************************************************************//
    

    func setDatepickerView(_ txtfield: UITextField) {
        let toobar = UIToolbar()
        toobar.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(self.doneTxt(_:)))
        doneButton.tag = txtfield.tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toobar.setItems([ spaceButton, doneButton], animated: false)
        toobar.isUserInteractionEnabled = true
        
        txtfield.inputAccessoryView = toobar
        txtfield.clearButtonMode = .never
        
        let datepicker = UIDatePicker()
        datepicker.date = Date()
        datepicker.datePickerMode = .date
        datepicker.maximumDate = Date()
        
        let formatter = DateFormatter()
        if txtfield.text == "" || txtfield.text == nil {
            formatter.dateFormat = "dd-MM-yyyy"
            txtfield.text = formatter.string(from: datepicker.date)
            formatter.dateFormat = "yyyy-MM-dd"
            let strDte = formatter.string(from: datepicker.date)
            self.observingData["dob"] = strDte
            self.dicUserData["dob"] = strDte
        }
        else {
            formatter.dateFormat = "dd-MM-yyyy"
            datepicker.date = formatter.date(from: txtfield.text ?? "")!
        }
        datepicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: .valueChanged)
        txtfield.inputView = datepicker
    }
    
    
    @IBAction func handleDatePicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.strDOB = formatter.string(from: sender.date)
        
        formatter.dateFormat = "yyyy-MM-dd"
        let strDte = formatter.string(from: sender.date)
        self.observingData["dob"] = strDte
        self.dicUserData["dob"] = strDte
        
        
        if let currentCell = self.tblView.cellForRow(at: self.selectedIndexPath) as? AnotherFileldTableCell {
            formatter.dateFormat = "dd-MM-yyyy"
            currentCell.txt_value.text = formatter.string(from: sender.date)
        }
    }
    
    @IBAction func doneTxt(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    //For Blood Group Picker
    func setBloodGroupPickerView(_ txtfield: UITextField) {
        let picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        let toobar = UIToolbar()
        toobar.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(self.doneTxt(_:)))
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(self.doneTxt(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toobar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toobar.isUserInteractionEnabled = true
        toobar.tintColor = .black
        txtfield.inputView = picker
        txtfield.inputAccessoryView = toobar
    }
    //*********************************************************************************//
    //*********************************************************************************//
    //*********************************************************************************//
    //*********************************************************************************//

    //MARK: UIButton Method
    @IBAction func btnSideMenu_Action(_ sender: UIButton) {
        showSideMenu()
    }
    
    @IBAction func btn_editSave_Action(_ sender: UIButton) {
        if is_Save {
            SVProgressHUD.show(withStatus: MSG_PleaseWait)
            self.callAPIforupdateProfile()
        }
        else {
            self.is_Save = true
            self.btn_editSave.setImage(#imageLiteral(resourceName: "save"), for: UIControl.State.normal)
        }
        self.tblView.reloadData()
    }
}

//MARK: TableView Delegate and Datasource Method
extension MyProfileVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContent.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell: ProfileImageTableCell = tblView.dequeueReusableCell(withIdentifier: "ProfileImageTableCell", for: indexPath) as! ProfileImageTableCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.view_ImgBG.layer.cornerRadius = 60
            cell.img_Profile.layer.cornerRadius = 50
            cell.img_Profile.layer.masksToBounds = true
            cell.clipsToBounds = true
            
            if self.is_Save {
                cell.img_Edit.isHidden = false
                cell.btn_ChangeProfile.isHidden = false
            }
            else {
                cell.img_Edit.isHidden = true
                cell.btn_ChangeProfile.isHidden = true
            }
            
            if let is_Update = self.observingData["isPhotoUpdate"] as? Bool, is_Update == true {
                cell.img_Profile.image = changedImage
            }
            else {
                if let strImage = self.dicUserData["image"] as? String {
                    cell.img_Profile.sd_setImage(with: URL.init(string: strImage), placeholderImage: #imageLiteral(resourceName: "ic_user_default"))
                }
            }
            
            let FullName = self.dicUserData["fullName"] as? String ?? ""
            if FullName.contains("s/o") {
                let ar = FullName.components(separatedBy: "s/o")
                let name = ar.first ?? ""
                cell.lbl_Name.text = name.capitalized// + " Jain"
            }
            else {
                cell.lbl_Name.text = FullName.capitalized
            }
            
            
            cell.btn_ChangeProfile.tag = indexPath.row
            cell.btn_ChangeProfile.addTarget(self, action: #selector(btnChangeProfile_Action(_:)), for: UIControl.Event.touchUpInside)
            
            cell.img_Profile.isUserInteractionEnabled = true
            cell.img_Profile.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didAnimate(_:))))
            
            
            return cell
        }
        else {
            let cell: AnotherFileldTableCell = tblView.dequeueReusableCell(withIdentifier: "AnotherFileldTableCell", for: indexPath) as! AnotherFileldTableCell
            
            cell.selectionStyle = .none
            cell.txt_value.delegate = self
            
            if self.arrContent[indexPath.row] == k_mobile {
                cell.txt_value.isUserInteractionEnabled = false
                cell.img_edit.isHidden = self.strHeadID == "1" ? true : self.is_Save ? false : true
            }
            else {
                cell.img_edit.isHidden = self.is_Save ? false : true
                cell.txt_value.isUserInteractionEnabled = self.is_Save ? true : false
            }
            
            var strValue = ""
            let strContent = self.arrContent[indexPath.row]
            cell.lbl_Title.text = strContent
            if strContent == k_mobile {
                strValue = self.dicUserData["mobile"] as? String ?? ""
            }
            else if strContent == k_email {
                strValue = self.dicUserData["email"] as? String ?? ""
            }
            else if strContent == k_dob {
                strValue = self.dicUserData["dob"] as? String ?? ""
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dete = formatter.date(from: strValue)

                formatter.dateFormat = "dd-MM-yyyy"
                strValue = formatter.string(from: dete ?? Date())
            }
            else if strContent == k_qualification {
                strValue = self.dicUserData["qualification"] as? String ?? ""
            }
            else if strContent == k_profession {
                strValue = self.dicUserData["profession"] as? String ?? ""
            }
            else if strContent == k_family_members {
                strValue = self.dicUserData["family_members"] as? String ?? ""
            }
            else if strContent == k_blood_group {
                strValue = self.dicUserData["blood_group"] as? String ?? ""
            }
            
            cell.txt_value.text = strValue
            cell.txt_value.accessibilityValue = strContent
            
            
            cell.txt_value.addTarget(self, action: #selector(didPressDateofBirthValueField(_:)), for: UIControl.Event.editingDidBegin)
            
            cell.txt_value.addTarget(self, action: #selector(didChangeValueField(_:)), for: UIControl.Event.editingChanged)
            return cell
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            var hit = (screenHeight/4)
            hit = hit + 120
            return hit
        }
        return 73//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.sizeToFit()
        viewFooter.backgroundColor = .clear
        viewFooter.isUserInteractionEnabled = false
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (tableView.numberOfSections - 1){
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.is_Save {
            if indexPath.row == 1 {
                if self.strHeadID != "1" {
                    let inputState: String = UUID().uuidString
                    let viewController = self.accountKit.viewControllerForPhoneLogin(with: nil, state: inputState)
                    self.prepareLoginViewController(viewController: viewController)
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    //*****************************************************************************//
    //*****************************************************************************//
    
    
    @IBAction func didPressDateofBirthValueField(_ sender: UITextField) {
        let btn = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let indexpa = tblView.indexPathForRow(at: btn)
        
        if let indxie = indexpa {
            self.selectedIndexPath = indxie
            
            if let strKey = sender.accessibilityValue {
                if strKey == k_dob {
                    let currentCell = tblView.cellForRow(at: indxie) as! AnotherFileldTableCell
                    self.setDatepickerView(currentCell.txt_value)
                }
                else if strKey == k_blood_group {
                    let currentCell = tblView.cellForRow(at: indxie) as! AnotherFileldTableCell
                    if currentCell.txt_value.text == "" {
                        currentCell.txt_value.text = self.arrBloodGroup[0]
                        self.dicUserData["blood_group"] = self.arrBloodGroup[0]
                        self.observingData["blood_group"] = self.arrBloodGroup[0]
                    }
                    self.setBloodGroupPickerView(currentCell.txt_value)
                }
            }
        }
    }
    

    //For Value Change
    @IBAction func btnChangeProfile_Action(_ sender: UIButton) {
        let btn = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let indexpa = tblView.indexPathForRow(at: btn)
        if let indxie = indexpa {
            let currentCell = tblView.cellForRow(at: indxie) as! ProfileImageTableCell
            self.openImagePicker(currentCell.img_Profile)
        }
    }
    
    func openImagePicker(_ imgView: UIImageView) {
        
        let imageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            imageAlert.dismiss(animated: true, completion: nil)
        })

        let Capture = UIAlertAction.init(title: "Take Photo", style: .destructive, handler: { (action) in
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .front
            self.imagePicker.showsCameraControls = true
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let chosefromlib = UIAlertAction.init(title: "Choose Photo", style: .default, handler: { (action) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        imageAlert.addAction(Capture)
        imageAlert.addAction(chosefromlib)
        imageAlert.addAction(cancel)
        self.present(imageAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let pickedIamge = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.changedImage = pickedIamge
                self.observingData["isPhotoUpdate"] = true
                self.tblView.reloadData()
            }
        }
    }

}


//MARK: UIPickerView Delegate Datasource Method
extension MyProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrBloodGroup.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrBloodGroup[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dicUserData["blood_group"] = self.arrBloodGroup[row]
        self.observingData["blood_group"] = self.arrBloodGroup[row]
        
        if let currentCell = self.tblView.cellForRow(at: self.selectedIndexPath) as? AnotherFileldTableCell {
            currentCell.txt_value.text = self.arrBloodGroup[row]
        }
    }
}
//**********************************************************************************//
//**********************************************************************************//
//**********************************************************************************//


//MARK: Animate Full Image
extension MyProfileVC {
    
    @IBAction func didAnimate(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: self.tblView)
        if let indexPath = tblView.indexPathForRow(at: touch) {
            let currentCell = self.tblView.cellForRow(at: indexPath) as! ProfileImageTableCell
                animateOverlayView(selectedImageView: currentCell.img_Profile)
            }
    }
    
    func animateOverlayView(selectedImageView: UIImageView) {
        
        self.selectedImageView = selectedImageView
        self.overlayDarkView = UIView.init(frame: self.view.bounds)
        self.overlayDarkView?.alpha = 0
        self.overlayDarkView?.backgroundColor = UIColor.darkText //.withAlphaComponent(0.9)
        self.view.addSubview(self.overlayDarkView!)
        
        if let rect = selectedImageView.superview?.convert(selectedImageView.frame, to: nil){
            
            self.overlayImageView = UIImageView.init(frame: rect)
            self.overlayImageView?.isUserInteractionEnabled = true
            
            let buttonClose = UIButton.init(type: UIButton.ButtonType.custom)
            buttonClose.setImage(#imageLiteral(resourceName: "close_white"), for: .normal)
            buttonClose.tintColor = .white
            buttonClose.tag = 22
            self.overlayImageView?.addSubview(buttonClose)
            buttonClose.translatesAutoresizingMaskIntoConstraints = false
            
            var topSafeAria: CGFloat = 30
            if #available(iOS 11.0, *){
                topSafeAria = appDelegate.window?.safeAreaInsets.top ?? 30
            }
            buttonClose.topAnchor.constraint(equalTo: (self.overlayImageView?.topAnchor)!, constant: (topSafeAria + 30)).isActive = true
            buttonClose.trailingAnchor.constraint(equalTo: (self.overlayImageView?.trailingAnchor)!, constant: -10).isActive = true
            buttonClose.heightAnchor.constraint(equalToConstant: 40).isActive = true
            buttonClose.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            buttonClose.addTarget(self, action: #selector(didDeinitOverlayView(_:)), for: UIControl.Event.touchUpInside)
            self.overlayImageView?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didDeinitOverlayView(_:))))
            
            self.overlayImageView?.image = selectedImageView.image
            self.overlayImageView?.backgroundColor = selectedImageView.backgroundColor
            self.overlayImageView?.clipsToBounds = selectedImageView.clipsToBounds
            self.overlayImageView?.contentMode = .scaleAspectFit // selectedImageView.contentMode
            selectedImageView.alpha = 0
            self.view.addSubview(self.overlayImageView!)
            self.view.bringSubviewToFront(self.overlayImageView!)
            self.view.layoutIfNeeded()
            
            buttonClose.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                
                self.overlayImageView?.frame = self.view.frame
                buttonClose.alpha = 1
                self.overlayDarkView?.alpha = 1
                //self.overlayImageView?.contentMode = .scaleAspectFill
            }, completion: { (isdone) in
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func didDeinitOverlayView(_ sender: Any) {
        
        if let rect = self.selectedImageView?.superview?.convert((self.selectedImageView?.frame)!, to: nil){
            
            let button = self.overlayImageView?.viewWithTag(22) as? UIButton
            button?.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                
                self.overlayImageView?.frame = rect
                self.overlayDarkView?.alpha = 0
                //self.overlayImageView?.alpha = 0
                self.selectedImageView?.alpha = 1
                //self.overlayImageView?.contentMode = .scaleToFill
                
            }, completion: { (isdone) in
                
                self.selectedImageView?.alpha = 1
                button?.removeFromSuperview()
                self.overlayImageView?.removeFromSuperview()
                self.overlayDarkView?.removeFromSuperview()
                
                self.view.layoutIfNeeded()
            })
            
        }
    }
}


//MARK: - Account Kit Delegate Method
extension MyProfileVC: AKFViewControllerDelegate {
    
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
                self.tblView.reloadData()
            }
            else {
                print("[Mobile Login] Account ID  \(account?.accountID ?? "")")
                if let phoneNum = account?.phoneNumber {
                    
                    self.dicUserData["mobile"] = "\(phoneNum.phoneNumber)"
                    self.observingData["mobile"] = "\(phoneNum.phoneNumber)"

                    print("[Mobile Login] Phone Number:-\("+" + phoneNum.countryCode + " " + phoneNum.phoneNumber)")
                    
                    self.tblView.reloadData()

                }
            }
        }
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        
        print(code)
        print(state)
    }
}
