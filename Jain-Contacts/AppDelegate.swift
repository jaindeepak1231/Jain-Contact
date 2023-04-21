//
//  AppDelegate.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 17/11/18.
//  Copyright © 2018 Deepak Jain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var is_gotArea = false
    var isLoading = false
    var vieww_BGforLoader = UIView()
    var arrAreaList = [AreaListData]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        sleep(2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.getAllArea()
        }
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(enterForground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            //self.apiCallForGetNewVersion()
        }
        
        
        _userDefault.set(true, forKey: "first_time")
        //printFonts()
        
        return true
    }
    
    
    
    
    func getAllArea() {
        
        let strURL = "\(k_BaseURL)getAllAreas"
        
        print("Api for Get All area List:---->>\(strURL)")
        
        ServerCall.sharedInstance.ServieceWithURl(methodType: .get, processView: self.window?.rootViewController, baseView: self.window?.rootViewController, proccesTitle: MSG_PleaseWait, api: strURL) { (JSON, data) in
            
            DispatchQueue.main.async {
                
                if (JSON?["success"] as? String) != nil {

                    if let data = data {
                        
                        do {
                            let arrData = try JSONDecoder().decode(AreaData.self, from: data)
                            if let data = arrData.result {
                                self.is_gotArea = true
                                    self.arrAreaList = data
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                    
                }
                else {
                    self.is_gotArea = false
                }
            }
        }
    }
    
    
    func apiCallForGetNewVersion() {
        if let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String {
            let strURL = "http://itunes.apple.com/lookup?bundleId=\(identifier)"
            
            print("Api for Get New Version:---->>\(strURL)")
            
            ServerCall.sharedInstance.ServieceWithURl(methodType: .get, processView: nil, baseView: nil, proccesTitle: MSG_PleaseWait, api: strURL) { (JSON, data) in
                
                print(JSON ?? 0)
                
                if let arrResult = JSON?["results"] as? NSArray {
                    if let dicResult = arrResult.firstObject as? NSDictionary {
                        let newVersion = dicResult["version"] as? String ?? ""
                        
                        let flotNewVersion = (newVersion as NSString).doubleValue
                        let flotCurrentVersion = (currentVersion as NSString).doubleValue
                        
                        if flotCurrentVersion < flotNewVersion {
                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                            let objUpdate = storyboard.instantiateViewController(withIdentifier: "UpdateVersionVC") as! UpdateVersionVC
                            objUpdate.strNewVersion = newVersion
                            self.window?.rootViewController?.present(objUpdate, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
//    @objc internal func enterForground() {
//        loadingGroup?.show(self.view)
//        loadingGroup?.startLoading()
//        //loadingGroup?.startLoading()
//    }
//
    @objc internal func enterBackground() {
        loadingGroup?.stopLoading()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

