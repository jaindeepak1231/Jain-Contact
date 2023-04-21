//
//  Enum.swift
//  RedButton
//
//  Created by Zignuts Technolab on 27/03/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import Foundation


//MARK: Enum Push Type
enum optionsPushType {
    
    case none
    case fromLogin
    case fromProfile
    case fromEntrylog
    case fromEditVisitor
    case fromEditCourier
    case fromEditComplaint
    case fromStaffDetail
    case fromAddStaff
    case fromRecentVisitor
    case fromResident
    case fromStaff
    case fromFilter
    case fromMyLog
    case fromflatLog
    case fromInviteUser
    case fromNotification
    case fromCouriorNotification

}

enum APIName : String{
    
    case loginAPI = "loginAPI"
    case updateTabbar = "updateTabbar"
    case tokenExpire = "tokenExpire"
    case none = "N/A"
    case homeAPI = "homeAPI"
    case visitorAPI = "visitorAPI"
    case courierAPI = "courierAPI"
    case directoryAPI = "directoryAPI"
    case helpAPI = "helpAPI"
    case registerProfileUpdate = "registerProfileUpdate"
    case registerUser = "registerUser"
    case registerEmailValidation = "registerEmailValidation"
    case registerPhoneValidation = "registerPhoneValidation"
    case requestVisitorPhoneValidation = "requestVisitorPhoneValidation"
    case requestVisitorAddUser = "requestVisitorAddUser"
    case requestVisitorUpdateUser = "requestVisitorUpdateUser"
    case requestCourierAdd = "requestCourierAdd"
    case requestCourierUpdate = "requestCourierUpdate"
    case complaintCreate = "complaintCreate"
    case complaintUpdate = "complaintUpdate"
    case complaintList = "complaintList"
    case complaintResolved = "complaintResolved"
    case searchByMobile = "searchByMobile"
    case vehicleList = "vehicleList"
    case Addvehicle = "Addvehicle"
    case checkvehicle = "checkvehicle"
    case deletevehicle = "deletevehicle"
    case familyList = "familyList"
    case deleteTenant = "deleteTenant"
    case mylogAPI = "mylogAPI"
    case staffList = "staffList"
    case deletestaff = "deletestaff"
    case getstaff = "getstaff"
    case updateSetting = "updateSetting"
    case sos_notification = "sos_notification"
    case Deletecomplaint = "Deletecomplaint"
    case AcceptInvitation = "AcceptInvitation"
    case RejectInvitation = "RejectInvitation"
    case DetailInvitation = "DetailInvitation"
    case LogOut = "LogOut"
    //case courierAPI = "courierAPI"
}






//MARK:- Enum UserDefaults
enum eChangeParam : String
{
    case none = ""
    case keyF_name = "firstname"
    case keyL_name = "lastname"
    case keyEmail = "email"
    case keyMobile = "mobile"
    case keyGender = "gender"
    case keyProfile = "profile"
}



//MARK:- Enum Side Menu
enum SidemenuContent : String
{
    case none = ""
    case s_home = "Home"
    case s_profile = "Profile"
    case s_shareLink = "Share Link"
    case s_feedback = "Feedback / Suggestion"
    case s_login = "Login"
    case s_logout = "Logout"
}







//MARK:- Enum UserDefaults
enum eUserDefaultsKey : String
{
    case key_isLogin = "isLogin"
    case keyLoginUserID = "keyLoginUserID"
    case keyLoginID = "keyLoginSocialID"
    case keyisRewindPresented = "keyisRewindPresented"
    case keyisSuprelikePresented = "keyisSuprelikePresented"
    case keyUserPayCardDetail = "keyUserpaymentCardDetail"
}

enum keyLocalNotification : String
{
    case refreshViewController = "REFRESHVIEWCONTROLLERLIST"
    case updateUserSettings = "loc_noti_key_update_usersettings"
    case newCardMatch = "card_matched_local_notification"
    case planHasbeenUpgraded = "plan_upgrade_notiifcation"
    case push_ApproveReject = "push_ApproveReject"
    case push_superLike = "push_superLike"
    case push_match = "push_match"
    case push_Other = "push_Other"
    case push_unmatch = "push_unmatch"
}


enum GradientDirection {
    case Right
    case Left
    case Bottom
    case Top
    case TopLeftToBottomRight
    case TopRightToBottomLeft
    case BottomLeftToTopRight
    case BottomRightToTopLeft
}

enum NotificationType:String {
    case approve = "approve"
    case reject = "reject"
    case superlike = "superlike"
    case match = "match"
    case admin = "admin"
    case general = "general"
}

enum UserLoginType:String {
    case none = "none"
    case facebook = "facebook"
    case instagram = "instagram"
    case mobile = "phone"
}

enum eNotifications:String {
    case userLogin = "localNotiifcation_userloginwithupdateddata"
}
