//
//  ServerCall.swift
//  ShreeMahavirCourier
//
//  Created by Gaurav Rami (gaurav.rami26@gmail.com) on 01/01/16.
//  Copyright © 2016 Versatile. All rights reserved.
//

import UIKit
import Alamofire
import Messages
import MessageUI
import MobileCoreServices
import SystemConfiguration


//
//MARK: - Network Reachability Manager - GLOBAL Variables
let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
var isInternetAvailable = false



//
//MARK: - URL Constants.....
//private let BASE_URL = "http://52.64.92.76/rest/index.php/Api_doctor/"
//let URL_LOGIN = BASE_URL + "login"
//let URL_FORGOT_PASSWORD = BASE_URL + "forget_password"
//let URL_PATIENT_REQUEST = BASE_URL + "get_appoinment"
//let URL_ACCEPT_REQUEST = BASE_URL + "accept_appoinment"
//let URL_REFERRAL_CATEGORY = BASE_URL + "get_category"
//let URL_REFERRAL_NEAR_BY = BASE_URL + "near_by_specialist"
//let URL_PATIENT_INFO = BASE_URL + "get_patient_info"
//let URL_END_APPOINTMENT = BASE_URL + "end_appoinment"


//
//MARK: - enum
@objc enum ServerCallName : Int {
    case serverCallNameGoogleAddressSearch = 101,
    serverCallNameGetAccessToken,
    serverCallNameLogin,
    serverCallNameEmailValidation,
    serverCallNameUserRegister,
    serverCallRecentVisitor,
    serverCallProfileUpdate
    
    

}

enum HTTP_METHOD {
    case GET,
    POST, PUT
}

//
//MARK: - PROTOCOL
@objc protocol ServerCallDelegate {
    //@objc optional func ServerCallSuccessWithData(_ resposeObject: Any?, name: ServerCallName, data: Data?)
    @objc func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName, data: Data?)
    @objc func ServerCallFailed(_ errorObject:String, name: ServerCallName)
}


//
//MARK: - ServerCall CLASS
class ServerCall: NSObject {
    var delegateObject : ServerCallDelegate!
    
    // Shared Object Creation
    static let sharedInstance = ServerCall()
    
    //MARK: - Request Methods.
    // Make API Request WITHOUT Header Parameters
    
    func isInternetAvailableCheck() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    //MARK: SERVICE WITH URL
    
    func ServieceWithURl(methodType: HTTPMethod, processView: UIViewController?, baseView: UIViewController?, proccesTitle: String?, api: String, Hendler complition:@escaping (_ JSON:NSDictionary?, _ Data: Data?) -> Void) {
    
        if isInternetAvailableCheck() {
            
            if processView != nil{
                //StartLoader()
            }
            
            let header = ["Content-Type" : "application/json"]
            
            let request = Alamofire.request(api, method: methodType, parameters: nil, headers: header)

            request.responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response : DataResponse<Any>) in

                if response.result.isSuccess {

                    if let dataDict = response.value as? NSDictionary {

                        complition(dataDict, response.data)
                        if processView != nil{
                            StopLoader()
                        }
                    }
                    else {

                        complition(nil, response.data)
                        if processView != nil{
                            StopLoader()
                        }
                    }
                }
                else if response.result.isFailure {

                    let errorDict = NSMutableDictionary()
                    errorDict["error"] =  response.result.error?.localizedDescription
                    complition(errorDict, nil)
                    StopLoader()
                }
                else {
                            
                    let errorDict = NSMutableDictionary()
                    errorDict["error"] =  "Opps! Something went wrong please try again later."
                    appDelegate.window?.rootViewController?.view.makeToast("Opps! Something went wrong please try again later.")
                    complition(errorDict, nil)
                    StopLoader()
                }
            })
        }
        else {
         
            let errorDict = NSMutableDictionary()
            errorDict["error"] =  "Internet is not available!!"
            appDelegate.window?.rootViewController?.view.makeToast("Internet is not available!!")
            complition(errorDict, nil)
            StopLoader()
        }
    }
    
    
    
    func ServieceWithURlandParameter(methodType: HTTPMethod, processView: UIViewController?, baseView: UIViewController?, params: [String : AnyObject], proccesTitle: String?, api: String, Hendler complition:@escaping (_ JSON:NSDictionary?, _ Data: Data?) -> Void) {
        
        if isInternetAvailableCheck() {
            
            if processView != nil{
                //StartLoader()
            }

            
            Alamofire.upload(multipartFormData: { multipartFormData in
                // The for loop is to append all parameters to multipart form data.
                for element in params.keys {
                    let strElement = String(element)
                    let strValueElement = params[strElement] as! String
                    multipartFormData.append(strValueElement.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: strElement)
                }
            },to: api,
              encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                                
                        if response.result.isSuccess {
                            if let dataDict = response.value as? NSDictionary {
                                complition(dataDict, response.data)
                                if processView != nil {
                                    StopLoader()
                                }
                            }
                            else {
                                complition(nil, response.data)
                                if processView != nil {
                                    StopLoader()
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    let errorDict = NSMutableDictionary()
                    errorDict["error"] =  encodingError.localizedDescription
                    complition(errorDict, nil)
                    StopLoader()
                }
            })
        }
        else{
            
            let errorDict = NSMutableDictionary()
            errorDict["error"] =  "Internet is not available!!"
            appDelegate.window?.rootViewController?.view.makeToast("Internet is not available!!")
            complition(errorDict, nil)
            StopLoader()
        }
    }
    
    
    
    //MARK:- Multi part request with parameters.
    func ServiceMultiPartWithUrlAndParameters(processView: UIViewController?, baseView: UIViewController?, parameters: [String : Any], proccesTitle: String?, api: String, fileParameterName: String, fileName:String, fileData : Data, mimeType : String, Hendler complition:@escaping (_ JSON: NSDictionary?, _ Data: Data?) -> Void)  {
        
        if isInternetAvailableCheck() {
            
            if processView != nil{
                //StartLoader()
            }
            
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    // The for loop is to append all parameters to multipart form data.
                    for element in parameters.keys{
                        let strElement = String(element)
                        let strValueElement = parameters[strElement] as! String
                        multipartFormData.append(strValueElement.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: strElement)
                    }
                    
                    // Append file to multipart form data.
                    multipartFormData.append(fileData, withName: fileParameterName, fileName: fileName, mimeType: mimeType)
            },
                to: api,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)

                            if response.result.isSuccess {
                                if let dataDict = response.value as? NSDictionary {
                                    complition(dataDict, response.data)
                                    if processView != nil {
                                        StopLoader()
                                    }
                                }
                                else {
                                    complition(nil, response.data)
                                    if processView != nil {
                                        StopLoader()
                                    }
                                }
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        let errorDict = NSMutableDictionary()
                        errorDict["error"] =  encodingError.localizedDescription
                        complition(errorDict, nil)
                        StopLoader()
                    }
            })
        }
        else {
            let errorDict = NSMutableDictionary()
            errorDict["error"] =  "Internet is not available!!"
            appDelegate.window?.rootViewController?.view.makeToast("Internet is not available!!")
            complition(errorDict, nil)
            StopLoader()
        }
    }
    //==================================================================================================//
    //**************************************************************************************************//
    
    
    
    /*
    func isInternetAvailabel() -> Bool {
        
        Alamofire.request("https://httpbin.org/get")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
    }
     */
}

//MARK:- GLOBAL Method. Out of ServerCall Class.
func isInternetAvailabel() -> Bool {
    reachabilityManager?.startListening()
    reachabilityManager?.listener = { status in
        print("Network Status Changed: \(status)")
        isInternetAvailable = true
        switch status {
        case .notReachable:
            //Show error state
            isInternetAvailable = false
            break
        case .reachable(.ethernetOrWiFi):
            break
        case .reachable(.wwan):
            break
        case .unknown:
            //Hide error state
            break
        }
    }
    return isInternetAvailable
}





//class KVMailServiece: NSObject {
//    
//    private override init() {}
//    static let shared = KVMailServiece()
//    
//    func composeMail(to email: String, with viewcontrollr: UIViewController){
//        
//        
//        if !MFMailComposeViewController.canSendMail() {
//            //  appDelegate.window?.rootViewController?.view.makeToast("Mail services are not available!", duration: 1.5, position: ToastPosition.bottom)
//            //ShowNotification("", "This device is unable to sent a mail!")
//            return
//        }
//        
//        let composeVC = MFMailComposeViewController()
//        composeVC.mailComposeDelegate = self
//        
//        // Configure the fields of the interface.
//        composeVC.setToRecipients([email])
//        composeVC.modalPresentationStyle = .overCurrentContext
//        composeVC.modalTransitionStyle = .crossDissolve
//        
//        // Present the view controller modally.
//        viewcontrollr.present(composeVC, animated: true, completion: nil)
//        
//    }
//    
//    
//}

//extension KVMailServiece: MFMailComposeViewControllerDelegate{
//    
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        
//        switch result {
//        case .cancelled:
//            // appDelegate.window?.rootViewController?.view.makeToast("Mail canceled!", duration: 1.8, position: ToastPosition.bottom)
//            //ShowNotification("", "Mail canceled!")
//        case .failed:
//            //  appDelegate.window?.rootViewController?.view.makeToast("Mail failed!", duration: 1.8, position: ToastPosition.bottom)
//            //ShowNotification("", "Mail failed!")
//        case .saved:
//            // appDelegate.window?.rootViewController?.view.makeToast("Mail saved!", duration: 1.8, position: ToastPosition.bottom)
//            //ShowNotification("", "Mail saved!")
//        case .sent:
//            // appDelegate.window?.rootViewController?.view.makeToast("Mail sent!", duration: 1.8, position: ToastPosition.bottom)
//            //ShowNotification("", "Mail sent!")
//        }
//        controller.dismiss(animated: true, completion: nil)
//    }
//    
//}


