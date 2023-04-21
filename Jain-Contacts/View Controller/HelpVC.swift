//
//  HelpVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 27/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class HelpVC: UIViewController, Storyboardable, SideMenuItemContent {

    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnSubmiit: UIButton!
    var arrContent = ["Call Support"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Register Cell
        self.tbl_View.register(UINib.init(nibName: "ContactHeaderCell", bundle: nil), forCellReuseIdentifier: "ContactHeaderCell")
        //***********************************************//
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnSideMenu_Action(_ sender: UIButton) {
        showSideMenu()
    }
    @IBAction func btnSubmit_Action(_ sender: UIButton) {
    }
    
}

//MARK: UITextView Delegate and Datasource Method
extension HelpVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type here" {
            textView.text = ""
            textView.textColor = .black
        }
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = "Type here"
            textView.textColor = .lightGray
        }
        return true
    }
}

//MARK: TableView Delegate and Datasource Method
extension HelpVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ContactHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ContactHeaderCell") as! ContactHeaderCell
        
        cell.img_BG.image = nil
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.img_Next.image = #imageLiteral(resourceName: "next").tint(with: UIColor.lightGray)
        
        cell.lbl_Title.text = self.arrContent[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            makeCall(number: "+919828429191")
        }
    }
    
}
