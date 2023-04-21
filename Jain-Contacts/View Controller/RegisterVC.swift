//
//  RegisterVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 05/12/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit
import Material
import SDWebImage
import SVProgressHUD

class RegisterRowsData: NSObject {
    
    var numOfrows = 0
    var sectionID = ""
    var key = ""
    var value = ""
    
    convenience init(_ rows: Int, _ id: String, _ key:String, _ value: String) {
        self.init()
        self.numOfrows = rows
        self.sectionID = id
        self.key = key
        self.value = value
    }
}

class RegisterVC: UIViewController {
    var strMobileNo = ""
    var dicUserData = [String: Any]()
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constraint_tblBottom: NSLayoutConstraint!

    var arrSectionsRow: [RegisterRowsData]! = [RegisterRowsData]()
    var birthdatePicker = UIDatePicker()
    var didSelectedDate: ((UIDatePicker)->Void)? = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_back.setImage(#imageLiteral(resourceName: "back").tint(with: .white), for: UIControl.State.normal)
        
        self.setUpDictionary()
        self.initiliseSection()
        
        //***Register Cell***//
        self.tblView.register(UINib.init(nibName: "cellRegistertype1", bundle: nil), forCellReuseIdentifier: "cellRegistertype1")
        
        self.tblView.register(UINib.init(nibName: "cellRegisterType2", bundle: nil), forCellReuseIdentifier: "cellRegisterType2")
        
        //***********************************************//
    }
    
    func initiliseSection() {
        self.arrSectionsRow.removeAll()
        self.arrSectionsRow.append(RegisterRowsData.init(1, "header", "", "header"))
        self.arrSectionsRow.append(RegisterRowsData.init(1, k_name, key_name, dicUserData[key_name] as? String ?? ""))
        self.arrSectionsRow.append(RegisterRowsData.init(1, k_mobile, key_mobile, self.strMobileNo))
        self.arrSectionsRow.append(RegisterRowsData.init(1, k_email, key_email
            , dicUserData[key_email] as? String ?? ""))
        self.arrSectionsRow.append(RegisterRowsData.init(1, k_dob, key_dob, dicUserData[key_dob] as? String ?? ""))
        self.arrSectionsRow.append(RegisterRowsData.init(1, k_profession, key_profession, dicUserData[key_profession] as? String ?? ""))
        self.arrSectionsRow.append(RegisterRowsData.init(1, k_gender, key_gender, dicUserData[key_gender] as? String ?? ""))
        self.arrSectionsRow.append(RegisterRowsData.init(1, "continue", "", ""))
        self.tblView.reloadData()
    }
    
    func setUpDictionary() {
        self.dicUserData[key_gender] = "m"
        self.dicUserData[key_name] = ""
        self.dicUserData[key_mobile] = self.strMobileNo
        self.dicUserData[key_email] = ""
        self.dicUserData[key_dob] = ""
        self.dicUserData[key_profession] = ""
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
    //*******************************************//
    
    //MARK: Call API for Update User Profile
    func callAPIforRegisterUser() {
        
        let fullName = getParamValue(key: key_name)
        let email = getParamValue(key: key_email)
        let profession = getParamValue(key: key_profession)
        let dob = getParamValue(key: key_dob)
        let mobile = getParamValue(key: key_mobile)
        let gender = getParamValue(key: key_gender)
        
        let strApiURL = k_BaseURL + "register&fullName=\(fullName)&email=\(email)&gender=\(gender)&qualification=&profession=\(profession)&blood_group=&dob=\(dob)&mobile=\(mobile)"
        
        if let escapedString = strApiURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) {
            
            ServerCall.sharedInstance.ServieceWithURl(methodType: .get, processView: self, baseView: self, proccesTitle: MSG_PleaseWait, api: escapedString ) { (JSON, data) in
                
                if let strMsg = JSON?["msg"] as? String, strMsg == "You have registered successfully" {
                    if let dicData = (JSON?["result"] as? NSDictionary) {
                        _userDefault.set(true, forKey: eUserDefaultsKey.key_isLogin.rawValue)
                        _userDefault.set(dicData, forKey: "User_Data")
                        let objHost = self.storyboard?.instantiateViewController(withIdentifier: "HostViewController") as! HostViewController
                        self.navigationController?.pushViewController(objHost, animated: true)
                    }
                    else {
                        self.view.makeToast(JSON?["msg"] as? String ?? "Connection failed try again!")
                    }
                }
                else {
                    self.view.makeToast(JSON?["msg"] as? String ?? "Connection failed try again!")
                }
                SVProgressHUD.dismiss()
            }
            
        }


    }
    
    func getParamValue(key: String) -> String {
        let strValue = self.dicUserData[key] as? String ?? ""
        return strValue
    }

    //*********************************************************************************//
    //*********************************************************************************//
    //*********************************************************************************//
    

    //MARK: - UIButton Mathod Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_Action(_ sender: UIButton) {
        if let strName = dicUserData[key_name] as? String, strName == "" {
            self.view.makeToast(m_enterName)
            return
        }
        if let strMobile = dicUserData[key_mobile] as? String, strMobile == "" {
            self.view.makeToast(m_enterMobile)
            return
        }
        if let strDOB = dicUserData[key_dob] as? String, strDOB == "" {
            self.view.makeToast(m_enterdob)
            return
        }
        if let strEmail = dicUserData[key_email] as? String, strEmail != "" {
            if !(strEmail.isValidEmail()) {
                self.view.makeToast(m_enterValidEmail)
                return
            }
        }
        
        SVProgressHUD.show(withStatus: MSG_PleaseWait)
        self.callAPIforRegisterUser()
    }
}


//MARK: TableView Delegate and Datasource Method
extension RegisterVC: UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSectionsRow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSectionsRow[section].numOfrows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let strID = self.arrSectionsRow[indexPath.section].sectionID

        if strID == k_gender {
            
            let cell: cellRegisterType2 = tableView.dequeueReusableCell(withIdentifier: "cellRegisterType2", for: indexPath) as! cellRegisterType2
            
            cell.constarintLblLeading.constant = 24 * screenScale
            cell.constarintLblTop.constant = 13 * screenScale
            cell.constarintLblBottom.constant = 14 * screenScale
            cell.constarintColBottom.constant = 10 * screenScale
            
            cell.collectionGender.delegate = self
            cell.collectionGender.dataSource = self
            
            cell.collectionGender.reloadData()
            
            return cell
        }

        else if strID == "header" {
            
            let cell: cellRegisterHeader = tableView.dequeueReusableCell(withIdentifier: "cellRegisterHeader", for: indexPath) as! cellRegisterHeader
            cell.lblHeader.text = "Register"
            cell.constarintLeading.constant = 24 * screenScale //24
            cell.constarintTop.constant = 10 * screenScale //24
            cell.constarintBottom.constant = 5 * screenScale //12
            return cell
        }
        else if strID == "continue" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellContinue", for: indexPath) as! cellRegistertype1
            cell.selectionStyle = .none
            cell.btnContinue.addTarget(self, action: #selector(btnSubmit_Action(_:)), for: .touchUpInside)
            return cell
        }
            
        let cell: cellRegistertype1 = tableView.dequeueReusableCell(withIdentifier: "cellRegistertype1", for: indexPath) as! cellRegistertype1
        cell.textField.textColor = .white
        cell.textField.placeholder = strID.capitalized

        cell.textField.tag = indexPath.section
        cell.textField.delegate = self
        
        cell.textField.accessibilityHint = strID
        cell.textField.accessibilityIdentifier = self.arrSectionsRow[indexPath.section].key
        
        if let strValue = dicUserData[self.arrSectionsRow[indexPath.section].key] as? String {
            if self.arrSectionsRow[indexPath.section].key == key_dob {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy-MM-dd"
                let dte = dateFormater.date(from: strValue)
                dateFormater.dateFormat = "dd-MM-yyyy"
                cell.textField.text = strValue == "" ? "" : dateFormater.string(from: dte ?? Date())
            }
            else {
                cell.textField.text = strValue
            }
        }
        else if let number = dicUserData[self.arrSectionsRow[indexPath.section].key] as? NSNumber{
            cell.textField.text = "\(number)"
        }
            
        switch self.arrSectionsRow[indexPath.section].key  {
        case key_name:
            cell.textField.isUserInteractionEnabled = true
            cell.textField.keyboardType = .default
            cell.textField.returnKeyType = .default
            cell.textField.autocapitalizationType = .words
            
        case key_mobile:
            cell.textField.isUserInteractionEnabled = false
            
        case key_email:
            cell.textField.keyboardType = .emailAddress
            cell.textField.returnKeyType = .default
            cell.textField.autocapitalizationType = .none
            cell.textField.isUserInteractionEnabled = true
            
        case key_dob:
            cell.textField.isUserInteractionEnabled = true
            self.birthdatePicker.datePickerMode = .date
            self.birthdatePicker.maximumDate = Date()
            self.birthdatePicker.addTarget(self, action: #selector(datePickerDidSetectDate(_:)), for: UIControl.Event.valueChanged)
            self.didSelectedDate = {(sender) in
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd-MM-yyyy"
                cell.textField.text = dateFormater.string(from: sender.date)
                
                let birth_date = dateFormater.string(from: sender.date)
                if let bday = self.dicUserData[key_dob] as? String {
                    debugPrint("Selected age [\(bday)]")
                }
            }
            cell.textField.addDoneToolbar()
            cell.textField.inputView = self.birthdatePicker
            cell.textField.autocapitalizationType = .none
            
            cell.textField.rightViewMode = .always
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: cell.textField.bounds.height, height: cell.textField.bounds.height)
            button.contentMode = .scaleAspectFit
            button.isUserInteractionEnabled = false
            button.setImage(#imageLiteral(resourceName: "calender"), for: .normal)
            cell.textField.rightView = button

        default:
            cell.textField.isUserInteractionEnabled = true
            break
        }
            
        cell.constraintLeading.constant = 24 * screenScale //24
        cell.constraintTop.constant = 25 * screenScale // 32
        cell.constraintBottom.constant = 5 * screenScale //10
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    }
}
//**********************************************************************************//
//**********************************************************************************//
//**********************************************************************************//

// MARK: - collectionview Datasource & Delegate

extension RegisterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: cellGenderCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "cellGenderCollection", for: indexPath) as! cellGenderCollection
        
        
        if indexPath.row == 0 {
            cell.btnGender.setImage(#imageLiteral(resourceName: "male_unselect"), for: .normal)
            cell.btnGender.setImage(#imageLiteral(resourceName: "male_selected").tint(with: .white), for: .selected)
        }
        else {
            cell.btnGender.setImage(#imageLiteral(resourceName: "female_unselect"), for: .normal)
            cell.btnGender.setImage(#imageLiteral(resourceName: "female_selected").tint(with: .white), for: .selected)
        }
        cell.btnGender.isSelected = false
        cell.btnGender.setTitle("", for: .normal)
        
        if indexPath.row == 1 && self.dicUserData[key_gender] as? String == "f" {
            cell.btnGender.isSelected = true
        }
        else if indexPath.row == 0 && self.dicUserData[key_gender] as? String == "m" {
            cell.btnGender.isSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return (20 * screenScale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dicUserData[key_gender] = (indexPath.row == 0 ? "m":"f")
        collectionView.reloadData()
    }
    
}


//MARK:- textfield Delegate & Actions

extension RegisterVC: UITextFieldDelegate {
    
    @IBAction func datePickerDidSetectDate(_ sender: UIDatePicker){
        if self.didSelectedDate != nil {
            self.didSelectedDate!(sender)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 22 {
            textField.placeholder = textField.accessibilityHint?.capitalized
            textField.attributedPlaceholder = nil
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 22 {
            textField.placeholder = textField.text != "" ? textField.accessibilityHint?.capitalized : ""
            textField.attributedPlaceholder = NSAttributedString(string: (textField.accessibilityHint?.capitalized ?? "")!, attributes: [NSAttributedString.Key.foregroundColor: (textField as? TextField)?.placeholderNormalColor ?? UIColor.lightGray, NSAttributedString.Key.font : textField.font!])
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  let strID = textField.accessibilityHint {
            if string == " " {
                if strID == "password" {
                    return false
                }
            }
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if strID == "Phone Number" {
                return newString.length <= MAX_PHONE
            }else if strID == "password" {
                return newString.length <= MAX_PASSWORD
            }else if strID == "name" {
                
                
                let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if string != filtered{
                    return false
                }
                return newString.length <= MAX_NICKNAME
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let strID = textField.accessibilityIdentifier {
            if strID == key_dob {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd-MM-yyyy"
                let dte = dateFormater.date(from: textField.text ?? "")
                dateFormater.dateFormat = "yyyy-MM-dd"
                self.dicUserData[strID] = dateFormater.string(from: dte ?? Date())
            }
            else {
                self.dicUserData[strID] = textField.text
            }
        }
    }
    
}


//MARK:- HeaderCell

class cellRegisterHeader: UITableViewCell {
    
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var constarintLeading: NSLayoutConstraint!
    @IBOutlet var constarintTop: NSLayoutConstraint!
    @IBOutlet var constarintBottom: NSLayoutConstraint!
}

class PhoneTextF: TextField {
    
    let padding = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 8)
    let paddingDefault = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if self.tag == 22 {
            return bounds.inset(by: padding)
        }
        return bounds.inset(by: paddingDefault)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if self.tag == 22 {
            return bounds.inset(by: padding)
        }
        return bounds.inset(by: paddingDefault)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if self.tag == 22 {
            return bounds.inset(by: padding)
        }
        return bounds.inset(by: paddingDefault)
    }
    
}


