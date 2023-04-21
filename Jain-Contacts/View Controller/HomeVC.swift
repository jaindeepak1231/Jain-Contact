//
//  HomeVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 21/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit
import ContactsUI
import AVFoundation
import InteractiveSideMenu

class HomeVC: UIViewController, AVAudioPlayerDelegate, Storyboardable, SideMenuItemContent {

    var isPlay = false
    var area_ID = ""
    var selecteIndex = 1
    var arr_TirthankarsListData = HomeData()
    private var currentListPage : Int = 0
    private var isLoadingList : Bool = false
    var arrTempData = NSMutableArray()
    var arrTirthankarsData = NSMutableArray()
    private var activityIndicator: LoadMoreActivityIndicator!
    
    var arrKeys = [String]()
    var arrFilter = [String]()
    var arrContactListData = [String : [HeadListData]]()
    
    var audioPlayer = AVAudioPlayer()
    
    var btn_height: CGFloat = 40.0
    var btn_Yposition: CGFloat = 6.0
    var home_Xposition: CGFloat = 8.0
    var btn_width: CGFloat = (screenWidth/2) - 12
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnContacts: UIButton!
    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn_Filter: UIButton!
    @IBOutlet weak var lbl_error: UILabel!
    @IBOutlet weak var btn_SideMenu: UIButton!
    @IBOutlet weak var view_Indicator: UIView!
    @IBOutlet weak var tbl_ViewforTirthankars: UITableView!
    @IBOutlet weak var collectForFilter: UICollectionView!
    @IBOutlet weak var activityIndicate: UIActivityIndicatorView!
    @IBOutlet weak var constraint_viewHeightforLoader: NSLayoutConstraint!
    @IBOutlet weak var constraint_viewWidth: NSLayoutConstraint!
    @IBOutlet weak var constant_collectionView_Height: NSLayoutConstraint!
    @IBOutlet weak var constant_HometblView_Height: NSLayoutConstraint!
    
    let underLineAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.patternDot.rawValue,
        NSAttributedString.Key.font : UIFont(name: FontQuicksand_Bold, size: 18) ?? UIFont.systemFont(ofSize: 18)]
    
    let noneUnderlineAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor.lightGray,
         NSAttributedString.Key.underlineStyle : NSUnderlineStyle.patternDot.rawValue,
         NSAttributedString.Key.font : UIFont(name: FontQuicksand_Regular, size: 18) ?? UIFont.systemFont(ofSize: 18)]
    
    
    //<<==========-=====override function=====-==========>>//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.selecteIndex = 1
        self.currentListPage = 0
        self.lbl_error.text = ""
        self.btn_Filter.isHidden = true
        self.btnSearch.isHidden = true
        self.view_Indicator.isHidden = true
        
        self.btnHome.backgroundColor = .clear
        self.btnContacts.backgroundColor = .clear
        self.btnHome.setTitleColor(.white, for: UIControl.State.normal)
        self.btnContacts.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        self.view_Indicator.cornerRadius = 20
        self.view_Indicator.frame = CGRect.init(x: home_Xposition, y: btn_Yposition, width: btn_width, height: btn_height)
        
        //self.btn_SideMenu.setImage(UIImage.init(named: "Menu")?.tint(with: UIColor.black), for: UIControl.State.normal)
        
        //self.btn_Filter.setImage(UIImage.init(named: "filter")?.tint(with: UIColor.black), for: UIControl.State.normal)
        
        //self.btnSearch.setImage(UIImage.init(named: "search")?.tint(with: UIColor.black), for: UIControl.State.normal)
        
        let attributeString = NSMutableAttributedString(string: "Home", attributes: underLineAttributes)
        self.btnHome.setAttributedTitle(attributeString, for: .normal)
        
        
        //add Default Data
        self.arrTirthankarsData.removeAllObjects()
        self.arrTirthankarsData.addObjects(from: [dic1, dic2, dic3, dic4, dic5, dic6, dic7, dic8, dic9, dic10, dic11, dic12, dic13, dic14, dic15, dic16, dic17, dic18, dic19, dic20, dic21, dic22, dic23, dic24])
        let dic: NSDictionary = ["result" : self.arrTirthankarsData]
        
        let strJson = json(from: dic)
        if let data = strJson?.data(using: String.Encoding.utf8) {
            do {
                let arrData = try JSONDecoder().decode(HomeData.self, from: data)
                self.arr_TirthankarsListData = arrData
                let getHeight = (arrData.result?.count ?? 0)*64
                self.constant_HometblView_Height.constant = CGFloat(getHeight)
                self.tbl_ViewforTirthankars.reloadData()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        //*************************************************************//
        //*************************************************************//
        
        
        //Register Cell
        self.tbl_View.register(UINib.init(nibName: "ContactHeaderCell", bundle: nil), forCellReuseIdentifier: "ContactHeaderCell")
        
        self.tbl_View.register(UINib.init(nibName: "ContactTableCell", bundle: nil), forCellReuseIdentifier: "ContactTableCell")
        
        self.tbl_ViewforTirthankars.register(UINib.init(nibName: "JainTirthankarTableCell", bundle: nil), forCellReuseIdentifier: "JainTirthankarTableCell")
        //***********************************************//
        
        //Register Collection Cell
        let nib = UINib(nibName: "FilterCollectionCell", bundle: nil)
        self.collectForFilter.register(nib, forCellWithReuseIdentifier: "FilterCollectionCell")
        //***********************//
        
        //self.APICallForGetContactsData(true)
        self.tbl_View.pullTorefresh(#selector(PullToRefreshCall), tintcolor: UIColor.white, self)
        
        activityIndicator = LoadMoreActivityIndicator(tableView: self.tbl_View, spacingFromLastCell: -10, spacingFromLastCellWhenLoadMoreActionStart: 10)
        //********************//
        
        //------------------------------------------------------------------------------//
        guard Bundle.main.url(forResource: "Namokar Maha Mantra", withExtension: "mp3") != nil else { return }

        let path = Bundle.main.path(forResource: "Namokar Maha Mantra.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
        } catch {
            // couldn't load file :(
        }
        //*******************************************************************************//
        self.constraint_viewWidth.constant = UIScreen.main.bounds.width
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //==========================//
    func StartactivityLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.constraint_viewHeightforLoader.constant = 90
        }) { (finish) in
            self.activityIndicate.startAnimating()
        }
    }
    
    func StopactivityLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.constraint_viewHeightforLoader.constant = 52
        }) { (finish) in
            self.activityIndicate.stopAnimating()
        }
    }
    //**************************//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if _userDefault.bool(forKey: "first_time") == true {
            _userDefault.set(false, forKey: "first_time")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.openJaiJinendra()
            }
        }
    }
    
    func openJaiJinendra() {
        if let parent = appDelegate.window?.rootViewController {
            let objFilter = Story_Main.instantiateViewController(withIdentifier: "JaiJinendraVC") as? JaiJinendraVC
            parent.addChild(objFilter!)
            parent.view.addSubview((objFilter?.view)!)
            objFilter?.didMove(toParent: parent)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayer.stop()
        self.isPlay = false
        self.btnPlay.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
    }
    
    
    //Puul refresh action
    @objc func PullToRefreshCall(){
        self.currentListPage = 0
        self.APICallForGetContactsData(false, self.currentListPage)
    }
    
    //MARK:- API Call
    @objc func APICallForGetContactsData(_ animate: Bool = false, _ page: Int = 0) {

        if animate {
            StartactivityLoading()
        }
        
        if self.currentListPage == 0 {
            self.arrTempData.removeAllObjects()
        }
        
        let strURL = "\(k_BaseURL)getHead&area_id=\(self.area_ID)&start=\(page)"
        
        print("Api for Get Head List:---->>\(strURL)")
        
        ServerCall.sharedInstance.ServieceWithURl(methodType: .get, processView: self, baseView: self, proccesTitle: MSG_PleaseWait, api: strURL) { (JSON, data) in
            
            DispatchQueue.main.async {
                
                self.tbl_View.closeEndPullRefresh()
                NotificationCenter.default.post(name: NSNotification.Name.init("HIDELOADMORE"), object: nil)
                
                if (JSON?["success"] as? String) != nil {
                    if let arr = (JSON?["result"] as? NSArray) {
                        if self.currentListPage == 0 {
                            self.arrTempData.removeAllObjects()
                            self.arrTempData = (JSON?["result"] as? NSArray)?.mutableCopy() as! NSMutableArray
                        }
                        else {
                            for itm in arr {
                                self.arrTempData.add(itm)
                            }
                            print(self.arrTempData.count)
                        }
                        
                        //Create Json Decodeble
                        let dic: NSDictionary = ["result" : self.arrTempData]
                        let strJson = json(from: dic)
                        if let data = strJson?.data(using: String.Encoding.utf8) {
                            do {
                                let arrData = try JSONDecoder().decode(HeadData.self, from: data)
                                if let data = arrData.result {
                                    self.arrContactListData = Dictionary.init(grouping: data, by: { (contactdata) -> String in
                                        
                                        let strAreaName = contactdata.area_name ?? ""
                                        
                                        return strAreaName
                                    })
                                }
                                //self.tbl_View.reloadData()
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        }
                        self.lbl_error.text = ""
                        //*************************************************************//
                        //*************************************************************//
                    }

                    self.arrKeys = self.arrContactListData.keys.sorted{ $0.description.compare($1.description) == .orderedAscending}

                    self.tbl_View.reloadData()

                    if ((10 * page) + 10) >= self.arrContactListData.map({$0.value.count}).reduce(0, +){
                        self.isLoadingList = false
                    }else{
                        self.isLoadingList = true
                    }
                    self.lbl_error.text = ""
                }
                else {
                    self.currentListPage = page
                    if self.arrFilter.count > 0 {
                        self.arrKeys.removeAll()
                        self.arrContactListData.removeAll()
                        self.lbl_error.text = "\(filter_No_Result)\(self.arrFilter.first ?? "")"
                    }
                    self.tbl_View.reloadData()
                }
                self.StopactivityLoading()
            }
        }
    }
    //*******************************************************************************//
    //*******************************************************************************//

    
    //MARK: AVAudioPlayer Delegate Method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.isPlay = false
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- UIButton Action
    @IBAction func btnPlay_Action(_ sender: UIButton) {
        if isPlay {
            isPlay = false
            audioPlayer.pause()
            self.btnPlay.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
        }
        else {
            isPlay = true
            audioPlayer.play()
            self.btnPlay.setImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
        }
    }
    

    @IBAction func btnHome_Action(_ sender: UIButton) {
        self.selecteIndex = 1
        self.btnSearch.isHidden = true
        self.btn_Filter.isHidden = true
        let attributeString = NSMutableAttributedString(string: "Home", attributes: underLineAttributes)
        self.btnHome.setAttributedTitle(attributeString, for: .normal)
        
        let attributeStrin = NSMutableAttributedString(string: "Contacts", attributes: noneUnderlineAttributes)
        self.btnContacts.setAttributedTitle(attributeStrin, for: .normal)
        
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view_Indicator.frame = CGRect.init(x: self.home_Xposition, y: self.btn_Yposition, width: self.btn_width, height: self.btn_height)
        }) { (success) in
        }
        
        
        
        self.btnHome.setBackgroundImage(UIImage.init(named: "Home-trans."), for: .normal)
        self.btnContacts.setBackgroundImage(UIImage.init(named: "family-list"), for: .normal)
    }
    
    @IBAction func btnContacts_Action(_ sender: UIButton) {

        audioPlayer.stop()
        self.isPlay = false
        self.selecteIndex = 2
        self.tbl_View.reloadData()
        self.btnSearch.isHidden = false
        self.btn_Filter.isHidden = false
        self.btnPlay.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)

        let attributeString = NSMutableAttributedString(string: "Home", attributes: noneUnderlineAttributes)
        self.btnHome.setAttributedTitle(attributeString, for: .normal)
        
        let attributeStrin = NSMutableAttributedString(string: "Contacts", attributes: underLineAttributes)
        self.btnContacts.setAttributedTitle(attributeStrin, for: .normal)
        
        self.scrollView.setContentOffset(CGPoint.init(x: UIScreen.main.bounds.width, y: 0), animated: true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view_Indicator.frame = CGRect.init(x: self.btn_width + 16, y: self.btn_Yposition, width: self.btn_width, height: self.btn_height)
        }) { (success) in
        }
        
        
        
        self.btnHome.setBackgroundImage(UIImage.init(named: "family-list"), for: .normal)
        self.btnContacts.setBackgroundImage(UIImage.init(named: "Home-trans."), for: .normal)
        
        if self.arrKeys.count == 0 {
            self.currentListPage = 0
            self.APICallForGetContactsData(true, 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if appDelegate.is_gotArea == false {
                appDelegate.getAllArea()
            }
        }
    }
    
    @IBAction func btnFilter_Action(_ sender: UIButton) {
        if let parent = appDelegate.window?.rootViewController {
            let objFilter = self.storyboard?.instantiateViewController(withIdentifier: "AreaVC") as? AreaVC
            objFilter?.delegate = self
            objFilter?.areID = self.area_ID
            parent.addChild(objFilter!)
            parent.view.addSubview((objFilter?.view)!)
            objFilter?.didMove(toParent: parent)
        }
    }
    
    @IBAction func btnSearch_Action(_ sender: UIButton) {
        if let parent = appDelegate.window?.rootViewController {
            let objSearch = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
            parent.addChild(objSearch!)
            parent.view.addSubview((objSearch?.view)!)
            objSearch?.didMove(toParent: parent)
        }
    }
    
    @IBAction func btnSideMenu_Action(_ sender: UIButton) {
        showSideMenu()
    }
}





//MARK: TableView Delegate and Datasource Method
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func loadMoreItemsForList(){
        self.currentListPage += 10
        APICallForGetContactsData(false, self.currentListPage)
    }
    
    //MARK:- load more
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        self.activityIndicator.scrollViewDidScroll(scrollView: scrollView, loadMoreAction: {

            DispatchQueue.global(qos: .utility).async {
                
                if !self.isLoadingList {
                    self.isLoadingList = true
                    self.loadMoreItemsForList()
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name.init("HIDELOADMORE"), object: nil, queue: nil, using: { (noti) in
                        
                        sleep(1)
                        DispatchQueue.main.async { [weak self] in
                            self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                        }
                    })
                }else {
                    sleep(2)
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                    }
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.selecteIndex == 1 {
            return 1
        }
        return self.arrKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selecteIndex == 1 {
            return self.arr_TirthankarsListData.result?.count ?? 0
        }
        else {
            if self.arrKeys.count > 0{
                let key = self.arrKeys[section]
                return self.arrContactListData[key]?.count ?? 0
            }
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.selecteIndex == 1 {
            return 0
        }
        else {
            if self.arrFilter.count > 0 {
                return 0
            }
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.selecteIndex == 1 {
            return UIView()
        }
        
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
        
        if self.selecteIndex == 1 {
            
            let cell: JainTirthankarTableCell = tbl_ViewforTirthankars.dequeueReusableCell(withIdentifier: "JainTirthankarTableCell", for: indexPath) as! JainTirthankarTableCell
            
            cell.selectionStyle = .none

            let objDetail = self.arr_TirthankarsListData.result?[indexPath.row]
            let inx = indexPath.row + 1
            let name = "\(inx). \(objDetail?.name ?? "")"
            cell.lbl_Name.text = name

            return cell
            
        }
        else {
            
            let cell: ContactTableCell = tbl_View.dequeueReusableCell(withIdentifier: "ContactTableCell", for: indexPath) as! ContactTableCell
            
            cell.selectionStyle = .none
            
            let key = self.arrKeys[indexPath.section]
            
            cell.lbl_Underline.isHidden = true
            let objDetail = self.arrContactListData[key]
            cell.listData = objDetail?[indexPath.row]
            cell.img_Phone.image = #imageLiteral(resourceName: "call-answer").tint(with: UIColor.white)
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
            cell.lbl_Mobile.isUserInteractionEnabled = true
            cell.lbl_Mobile.addGestureRecognizer(tap)
            
            return cell
            
        }
        
        
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
        
        let tap = sender.location(in: self.tbl_View)
        let indexPath = self.tbl_View.indexPathForRow(at: tap)
        
        let key = self.arrKeys[indexPath?.section ?? 0]
        let objDetail = self.arrContactListData[key]
        let dic = objDetail?[indexPath?.row ?? 0]
        
        let strMobile = dic?.mobile
        makeCall(number: strMobile ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selecteIndex == 1 {
            
            var Successor = ""
            var Predecessor = ""
            if indexPath.row == 0 {
                Predecessor = ""
                Successor = self.arr_TirthankarsListData.result?[indexPath.row + 1].name ?? ""
            }
            else if indexPath.row == 23 {
                Successor = ""
                Predecessor = self.arr_TirthankarsListData.result?[indexPath.row - 1].name ?? ""
            }
            else {
                Predecessor = self.arr_TirthankarsListData.result?[indexPath.row - 1].name ?? ""
                Successor = self.arr_TirthankarsListData.result?[indexPath.row + 1].name ?? ""
            }
            
            let objDetal = self.storyboard?.instantiateViewController(withIdentifier: "TrithankarDetailVC") as! TrithankarDetailVC
            objDetal.strSuccessor = Successor
            objDetal.strPredecessor = Predecessor
            objDetal.strIndex = indexPath.row + 1
            objDetal.dicDetail = (self.arr_TirthankarsListData.result?[indexPath.row])!
            self.navigationController?.pushViewController(objDetal, animated: true)

        }
        else {
            let key = self.arrKeys[indexPath.section]
            let objDetail = self.arrContactListData[key]
            if let dic = objDetail?[indexPath.row] {
                
                let objMemberDetail = self.storyboard?.instantiateViewController(withIdentifier: "MemberDetailVC") as! MemberDetailVC
                objMemberDetail.dicMemberDetail = dic
                self.navigationController?.pushViewController(objMemberDetail, animated: true)
            }
        }
    }
    
}

//************************************************************************************//
//************************************************************************************//


//MARK: Collection View Delegate and Datasource Method
extension  HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrFilter.count > 0 {
            return self.arrFilter.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionCell", for: indexPath as IndexPath) as! FilterCollectionCell
        
        cell.backgroundColor = UIColor.clear
        //cell.view_BG.backgroundColor = #colorLiteral(red: 0, green: 0.7791629434, blue: 0.9159522653, alpha: 1)
        cell.view_BG.layer.borderColor = #colorLiteral(red: 0, green: 0.7791629434, blue: 0.9159522653, alpha: 1)
        cell.view_BG.layer.borderWidth = 2
        cell.view_BG.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor.clear
        cell.layer.cornerRadius = 17.5
        cell.view_BG.cornerRadius = 17.5

        cell.constraint_height.constant = 25
        cell.constraint_leading.constant = 16
        cell.btnDeleteFilter.setImage(#imageLiteral(resourceName: "close_white"), for: .normal)
        cell.lbl_filterTitle.text = self.arrFilter[indexPath.row]
        
        cell.btnDeleteFilter.tag = indexPath.row
        cell.btnDeleteFilter.addTarget(self, action: #selector(removeSelectedFilter(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var widt: CGFloat = 0
        var rect: CGRect = collectionView.frame
        
        rect.size = (self.arrFilter[indexPath.row].size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "System-Medium" , size: 16) ?? UIFont.systemFont(ofSize: 16)]))
            
        widt = rect.width + 55
        
        return CGSize.init(width: widt, height: 35)
    }
    
    @objc func removeSelectedFilter(_ sender: UIButton) {
        let btn = (sender as AnyObject).convert(CGPoint.zero, to: collectForFilter)
        let indexpa = collectForFilter.indexPathForItem(at: btn)
        
        if indexpa != nil {
            self.arrFilter.removeAll()
        }

        if self.arrFilter.count == 0 {
            self.area_ID = ""
            self.arrKeys.removeAll()
            self.arrContactListData.removeAll()
            self.tbl_View.reloadData()
            self.constant_collectionView_Height.constant = 0
        }
        self.collectForFilter.reloadData()
        self.currentListPage = 0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.APICallForGetContactsData(true, 0)
        }
    }
}
//************************************************************************************//
//************************************************************************************//

extension HomeVC : isBackDelegate {
    func backtoBackScreenFromFilter(areaID: String, areaNAME: String) {
        self.area_ID = areaID
        self.arrKeys.removeAll()
        self.arrFilter.removeAll()
        self.tbl_View.reloadData()
        self.arrFilter.append(areaNAME)
        self.constant_collectionView_Height.constant = self.arrFilter.count == 0 ? 0 : 45
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            self.collectForFilter.reloadData()
        }
        self.currentListPage = 0
        self.APICallForGetContactsData(true, self.currentListPage)
    }
}

//************************************************************************************//
//************************************************************************************//
