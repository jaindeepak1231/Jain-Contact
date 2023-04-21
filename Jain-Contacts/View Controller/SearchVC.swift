//
//  SearchVC.swift
//  demo
//
//  Created by Zignuts Technolab on 23/11/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import UIKit


class SearchVC: UIViewController {

    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var viewMain_BG: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var lbl_NoData: UILabel!
    @IBOutlet weak var layoutYpos: NSLayoutConstraint!
    @IBOutlet weak var activityIndicate: UIActivityIndicatorView!
    @IBOutlet weak var constraint_viewHeightforLoader: NSLayoutConstraint!
    
    var arrKeys = [String]()
    var arrSearchListData = [String : [HeadListData]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lbl_NoData.text = ""
        self.viewTop.layer.cornerRadius = 15
        self.viewMain_BG.layer.cornerRadius = 15
        self.activityIndicate.color = #colorLiteral(red: 0, green: 0.7791629434, blue: 0.9159522653, alpha: 1)
        
        self.searchBar.textColor = UIColor.white
        self.searchBar.setPlaceholderTextColorTo(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5))
        self.searchBar.setMagnifyingGlassColorTo(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5))
        self.searchBar.ClearButtonWhiteColor()

        self.layoutYpos.constant = screenHeight
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.showHidePopup(isShow: true, completion: { (isFinish) in})
        }
        
        //Register Cell
        self.tblView.register(UINib.init(nibName: "ContactHeaderCell", bundle: nil), forCellReuseIdentifier: "ContactHeaderCell")
        
        self.tblView.register(UINib.init(nibName: "ContactTableCell", bundle: nil), forCellReuseIdentifier: "ContactTableCell")
        //***********************************************//
    }
    
    //==========================//
    func StartactivityLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.constraint_viewHeightforLoader.constant = 35
        }) { (finish) in
            self.activityIndicate.startAnimating()
        }
    }
    
    func StopactivityLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.constraint_viewHeightforLoader.constant = 0
        }) { (finish) in
            self.activityIndicate.stopAnimating()
        }
    }
    //**************************//
    
    
    func showHidePopup(isShow:Bool,completion:@escaping (Bool)->Void) {
        let screenHeight = UIScreen.main.bounds.height
        self.layoutYpos.constant = (isShow ? UIApplication.shared.statusBarFrame.size.height + 60 : screenHeight)
        UIView.transition(with: self.viewMain_BG, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.black.withAlphaComponent((isShow ? 0.5:0))
        }) { (isFinish) in
            if isShow == false {
                self.view.endEditing(true)
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
            else {
                self.searchBar.becomeFirstResponder()
            }
            completion(isFinish)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- API Call
    @objc func APICallForSearchContactsData(_ animate: Bool = false, _ searchTxt: String = "") {
        
        if animate {
            StartactivityLoading()
        }
        let strURL = "\(k_BaseURL)globalSearch&search=\(searchTxt)"
        
        print("Api for Search Head List:---->>\(strURL)")
        
        ServerCall.sharedInstance.ServieceWithURl(methodType: .get, processView: self, baseView: self, proccesTitle: MSG_PleaseWait, api: strURL) { (JSON, data) in
            
            DispatchQueue.main.async {
                
                if (JSON?["success"] as? String) != nil {
                    if let data = data {
                        
                        do {
                            let arrData = try JSONDecoder().decode(HeadData.self, from: data)
                            if let data = arrData.result {
                                
                                self.arrSearchListData = Dictionary.init(grouping: data, by: { (contactdata) -> String in
                                    
                                    let strAreaName = contactdata.area_name ?? ""
                                    
                                    return strAreaName
                                })
                            }

                            self.arrKeys = self.arrSearchListData.keys.sorted{ $0.description.compare($1.description) == .orderedAscending}
                            
                            self.tblView.reloadData()
                            self.lbl_NoData.text = ""
                            
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                    
                }
                else {
                    self.arrKeys.removeAll()
                    self.arrSearchListData.removeAll()
                    self.tblView.reloadData()
                    self.lbl_NoData.text = search_No_Result
                }
                self.StopactivityLoading()
            }
        }
    }
    //*******************************************************************************//
    //*******************************************************************************//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}


//MARK: TableView Delegate and Datasource Method
extension SearchVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.searchBar.text == "" ? 0 : self.arrKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrKeys.count > 0{
            let key = self.arrKeys[section]
            return self.arrSearchListData[key]?.count ?? 0
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell: ContactHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ContactHeaderCell") as! ContactHeaderCell
        if self.arrKeys.count > 0 {
            cell.lbl_Title.text = self.arrKeys[section]
        }
        else{
            cell.lbl_Title.text = nil
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ContactTableCell = tableView.dequeueReusableCell(withIdentifier: "ContactTableCell", for: indexPath) as! ContactTableCell
        
        cell.selectionStyle = .none
        
        let key = self.arrKeys[indexPath.section]
        
        cell.lbl_Underline.isHidden = false
        let objDetail = self.arrSearchListData[key]
        cell.listData = objDetail?[indexPath.row]
        cell.lbl_Name.textColor = UIColor.black
        cell.lbl_Mobile.textColor = UIColor.black
        cell.lbl_areaName.textColor = UIColor.darkGray
        cell.img_Phone.image = #imageLiteral(resourceName: "call-answer").tint(with: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        cell.lbl_Mobile.isUserInteractionEnabled = true
        cell.lbl_Mobile.addGestureRecognizer(tap)
        
        return cell
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
            return 10
        }
        return 0
    }
    
    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        
        let tap = sender.location(in: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: tap)
        
        let key = self.arrKeys[indexPath?.section ?? 0]
        let objDetail = self.arrSearchListData[key]
        let dic = objDetail?[indexPath?.row ?? 0]
        
        let strMobile = dic?.mobile
        makeCall(number: strMobile ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = self.arrKeys[indexPath.section]
        let objDetail = self.arrSearchListData[key]
        if let dic = objDetail?[indexPath.row] {
            let objMemberDetail = self.storyboard?.instantiateViewController(withIdentifier: "MemberDetailVC") as! MemberDetailVC
            objMemberDetail.dicMemberDetail = dic
            self.navigationController?.pushViewController(objMemberDetail, animated: true)
        }
    }
    
}

//************************************************************************************//
//************************************************************************************//

//=============================================================================================//
//=============================================================================================//
//=============================================================================================//
// MARK : Followers User Search
extension SearchVC: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        print(searchText)
        DispatchQueue.main.async {
            self.APICallForSearchContactsData(true, searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if searchBar.text == "" {
            self.showHidePopup(isShow: false, completion: { (isFinish) in
                
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.showHidePopup(isShow: false, completion: { (isFinish) in
            
        })
        //self.navigationController?.popViewController(animated: false)
    }
}
//===========================================================================================//
//===========================================================================================//
//===========================================================================================//








