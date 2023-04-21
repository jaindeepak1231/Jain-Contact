//
//  AreaVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 23/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

protocol isBackDelegate {
    func backtoBackScreenFromFilter(areaID: String, areaNAME: String)
}

class AreaVC: UIViewController {
    
    var areID = ""
    var delegate: isBackDelegate?
    @IBOutlet weak var view_MainBG: UIView!
    @IBOutlet weak var view_Inner: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var view_CloseBG: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var layoutCenterYpos: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.layoutCenterYpos.constant = screenHeight
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        self.view_Inner.layer.cornerRadius = 15
        self.view_MainBG.layer.cornerRadius = 15
        self.view_CloseBG.layer.cornerRadius = self.view_CloseBG.frame.height/2
        
        //Register Cell
        self.tblView.register(UINib.init(nibName: "ContactHeaderCell", bundle: nil), forCellReuseIdentifier: "ContactHeaderCell")
        //***********************//
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.showHidePopup(isShow: true, completion: { (isFinish) in})
        }
    }
    
    func showHidePopup(isShow:Bool,completion:@escaping (Bool)->Void) {
        var toyY: CGFloat = 20.0
        let upYpos = screenHeight
        
        if #available(iOS 11.0, *) {
            toyY = (isShow ? UIApplication.shared.statusBarFrame.size.height + 60 : screenHeight)// appDelegate.window?.safeAreaInsets.top ?? 20
        }
        
        self.layoutCenterYpos.constant = (isShow ? toyY : upYpos)
        UIView.transition(with: view_MainBG, duration: 0.7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.black.withAlphaComponent((isShow ? 0.5:0))
        }) { (isFinish) in
            if isShow == false {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
            completion(isFinish)
        }
    }
    
    
    //MARK:- UIButton Action
    @IBAction func btnClose_Action(_ sender: UIButton) {
        self.showHidePopup(isShow: false, completion: { (isFinish) in
        })
    }
}
    

    //MARK: UITable View Delegate Datasource Method
extension  AreaVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appDelegate.arrAreaList.count > 0 {
            return appDelegate.arrAreaList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let  cell = tableView.dequeueReusableCell(withIdentifier: "ContactHeaderCell", for: indexPath as IndexPath) as! ContactHeaderCell

        let arID = appDelegate.arrAreaList[indexPath.row].id
        if arID == self.areID {
            cell.img_Next.image = UIImage.init(named: "save")?.tint(with: .black)
        }
        else {
            cell.img_Next.image = nil
        }
        
        cell.lbl_Title.text = appDelegate.arrAreaList[indexPath.row].area_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = self.tblView.cellForRow(at: indexPath) as! ContactHeaderCell
        currentCell.img_Next.image = UIImage.init(named: "save")?.tint(with: .black)
        self.showHidePopup(isShow: false, completion: { (isFinish) in
            let areID = appDelegate.arrAreaList[indexPath.row].id ?? ""
            let areNme = appDelegate.arrAreaList[indexPath.row].area_name ?? ""
            self.delegate?.backtoBackScreenFromFilter(areaID: areID, areaNAME: areNme)
        })
    }
}
    //*******************************************************************************//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

