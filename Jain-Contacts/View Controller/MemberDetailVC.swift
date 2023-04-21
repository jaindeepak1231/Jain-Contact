//
//  MemberDetailVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 25/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit
import ContactsUI

class MemberDetailVC: UIViewController {

    var is_AlreadyAddContact = false
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Call: UIButton!
    @IBOutlet weak var lbl_FamilyName: UILabel!
    @IBOutlet weak var view_ImgBG: UIView!
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var lbl_MemberName: UILabel!
    @IBOutlet weak var lbl_MobileNo: UILabel!
    @IBOutlet weak var btn_addContact: UIButton!
    @IBOutlet weak var lbl_profession: UILabel!
    @IBOutlet weak var lbl_familyMenbers: UILabel!
    @IBOutlet weak var lbl_MobileNo_Underline: UILabel!
    @IBOutlet weak var constraint_membrView_Height: NSLayoutConstraint!
    var dicMemberDetail = HeadListData()
    
    var overlayImageView: UIImageView?
    var overlayDarkView: UIView?
    var selectedImageView: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_Call.layer.cornerRadius = 22
        self.view_ImgBG.layer.cornerRadius = 60
        self.img_Profile.layer.cornerRadius = 50
        self.img_Profile.layer.masksToBounds = true
        self.lbl_MobileNo.text = dicMemberDetail.mobile ?? ""
        self.btn_Call.setImage(#imageLiteral(resourceName: "call-answer").tint(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: UIControl.State.normal)
        self.lbl_Title.text = dicMemberDetail.fullName?.capitalized
        self.lbl_profession.text = dicMemberDetail.profession?.capitalized
        self.lbl_FamilyName.text = dicMemberDetail.family_name?.uppercased()
        self.btn_Back.setImage(#imageLiteral(resourceName: "back").tint(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: UIControl.State.normal)
        
        let fullName = dicMemberDetail.fullName ?? ""
        if fullName.contains("s/o") {
            let ar = fullName.components(separatedBy: "s/o")
            let name = ar.first ?? ""
            self.lbl_MemberName.text = name.capitalized// + " Jain"
        }
        
        let membersCount = dicMemberDetail.family_members ?? ""
        if membersCount == "" || membersCount == "0" {
            self.lbl_familyMenbers.isHidden = true
            self.constraint_membrView_Height.constant = 0
        }
        else {
            self.lbl_familyMenbers.text = "Family Members: \(membersCount)"
        }
        self.lbl_MobileNo_Underline.isHidden = self.lbl_MobileNo.text == "" ? true : false
        //***************************************//
        
        //Ask Permission For Contact
        self.requestAccess(completionHandler: { (found) in
            print(found)
            if found {

                let strNo = self.dicMemberDetail.mobile ?? ""
                if strNo != "" {
                    self.iscontactInContactbook(strNo, Hendler: { (isfound) in
                        self.is_AlreadyAddContact = isfound
                        if isfound {
                            self.btn_addContact.setImage(#imageLiteral(resourceName: "add_con").tint(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: UIControl.State.normal)
                        }
                        else {
                            self.btn_addContact.setImage(#imageLiteral(resourceName: "add_contact"), for: UIControl.State.normal)
                        }
                    })
                }
                
            }
            else {
                self.btn_addContact.isHidden = true
            }
        })
        
        
        self.img_Profile.isUserInteractionEnabled = true
        self.img_Profile.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didAnimate(_:))))
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
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCall_Action(_ sender: UIButton) {
        let strMobile = dicMemberDetail.mobile
        makeCall(number: strMobile ?? "")
    }
    
    @IBAction func btnAddcontact_Action(_ sender: UIButton) {
        if self.is_AlreadyAddContact {
            self.view.makeToast("\(self.lbl_MemberName.text ?? "") is already added in your Contact list.")
            return
        }

        let contactalert = UIAlertController.init(title: "Add Contact !", message: "Are you sure to add this contact to your Phone Book?", preferredStyle: .alert)

        let addcontact = UIAlertAction.init(title: "Add To Contact", style: UIAlertAction.Style.destructive, handler: { (actio) in

            self.iscontactt_nameInCobntactbook(self.lbl_MemberName.text ?? "", Hendler: { (isfound,fContact) in

                DispatchQueue.main.async {
                    if isfound {
                        do {
                            let contactToUpdate = fContact.mutableCopy() as! CNMutableContact
                            var phone: [CNLabeledValue<CNPhoneNumber>] = [CNLabeledValue.init(label: "home", value: CNPhoneNumber.init(stringValue: self.lbl_MobileNo.text ?? ""))]

                            for item in fContact.phoneNumbers {
                                phone.append(item)
                            }
                            contactToUpdate.phoneNumbers = phone

                            let saveRequest = CNSaveRequest()
                            saveRequest.update(contactToUpdate)
                            try CNContactStore().execute(saveRequest)
                            self.is_AlreadyAddContact = true
                            self.view.makeToast("Contact added succesfully!")
                            self.btn_addContact.setImage(#imageLiteral(resourceName: "add_con").tint(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: UIControl.State.normal)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                    else {
                        let contact = CNMutableContact()
                        contact.givenName = self.lbl_MemberName.text ?? ""
                        contact.phoneNumbers = [CNLabeledValue.init(label: "home", value: CNPhoneNumber.init(stringValue: self.lbl_MobileNo.text ?? ""))]

                        let request = CNSaveRequest()
                        request.add(contact, toContainerWithIdentifier: nil)
                        do {
                            try CNContactStore().execute(request)
                            self.is_AlreadyAddContact = true
                            self.view.makeToast("Contact added succesfully!")
                            self.btn_addContact.setImage(#imageLiteral(resourceName: "add_con").tint(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: UIControl.State.normal)
                        } catch let error{
                            print(error.localizedDescription)
                        }
                    }
                }
            })
        })

        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            contactalert.dismiss(animated: true, completion: nil)
        })

        contactalert.addAction(cancel)
        contactalert.addAction(addcontact)
        self.present(contactalert, animated: true, completion: nil)
    }

    
    
    //MARK: Check Contact and Sync Contact
    func iscontactt_nameInCobntactbook(_ contactname: String, Hendler complition:@escaping (_ isfind: Bool, _ fContact: CNContact) -> Void ) {
        
        CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: { (isgranted, err) in
            if isgranted {
                let predicate = CNContact.predicateForContacts(matchingName: contactname)
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactNoteKey, CNContactTypeKey, CNContactDatesKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
                var contacts = [CNContact]()
                
                let contactsStore = CNContactStore()
                do {
                    contacts = try contactsStore.unifiedContacts(matching: predicate, keysToFetch: keys as! [CNKeyDescriptor])
                    if contacts.count == 0 {
                        complition(false, CNContact())
                    }
                    else {
                        complition(true,(contacts.last)!)
                    }
                }
                catch {
                    print("Unable to fetch contacts.")
                }
            }
        })
    }
    
    func iscontactInContactbook(_ phoneNumber: String, Hendler complition:@escaping (_ isfind: Bool) -> Void ) {
        CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: { (isgranted, err) in
            if isgranted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactPhoneNumbersKey]
                var contacts = [CNContact]()
                let contactsStore = CNContactStore()
                do {
                    try contactsStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])) {
                        (contact, cursor) -> Void in
                        if (!contact.phoneNumbers.isEmpty) {
                            let phoneNumberToCompareAgainst = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                            
                            for fonnumber in contact.phoneNumbers {
                                if let phoneNumberStruct = fonnumber.value as? CNPhoneNumber {
                                    let phoneNumberString = phoneNumberStruct.stringValue
                                    let phoneNumberToCompare = phoneNumberString.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                                    if phoneNumberToCompare == phoneNumberToCompareAgainst {
                                        contacts.append(contact)
                                    }
                                }
                            }
                        }
                    }
                    if contacts.count == 0 {
                        complition(false)
                    }
                    else {
                        complition(true)
                    }
                }
                catch {
                    print("Unable to fetch contacts.")
                }
            }
            //complition(false)
        })
    }
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        }
    }
    
    func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "Jain requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        
        self.present(alert, animated: true)
    }
}


//MARK: Animate Full Image
extension MemberDetailVC {
    
    @IBAction func didAnimate(_ sender: UITapGestureRecognizer){
        animateOverlayView(selectedImageView: self.img_Profile)
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
            self.overlayImageView?.contentMode = .scaleAspectFit// selectedImageView.contentMode
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
    
    @objc func didDeinitOverlayView(_ sender: Any){
        
        if let rect = self.selectedImageView?.superview?.convert((self.selectedImageView?.frame)!, to: nil){
            
            let button = self.overlayImageView?.viewWithTag(22) as? UIButton
            button?.alpha = 0
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                
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
