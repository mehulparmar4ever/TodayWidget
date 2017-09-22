//
//  Constant.swift
//  hotelBids
//
//  Created by Mehul on 20/01/16.
//  Copyright © 2017 Sooryen Innovation labs Studio. All rights reserved.
//

import Foundation
import UIKit
import Reachability

struct Screen {
    static let STATUS_BAR_HEIGHT        =   20.0
    static let NAVIGATION_BAR_HEIGHT    =   44.0
    
    static let width                = UIScreen.main.bounds.size.width
    static let height               = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(Screen.width, Screen.height)
    static let SCREEN_MIN_LENGTH    = min(Screen.width, Screen.height)
    
    static let isIphone4            = UIDevice.current.userInterfaceIdiom == .phone && Screen.SCREEN_MAX_LENGTH < 568.0
    static let isIphone5            = UIDevice.current.userInterfaceIdiom == .phone && Screen.SCREEN_MAX_LENGTH == 568.0
    static let isIphone6            = UIDevice.current.userInterfaceIdiom == .phone && Screen.SCREEN_MAX_LENGTH == 667.0
    static let isIphone6Plus        = UIDevice.current.userInterfaceIdiom == .phone && Screen.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && Screen.SCREEN_MAX_LENGTH == 1024.0
}

//MARK:
//MARK: App related constants, key and url
//MARK:

struct Constants {
    
    static let urlImageStatic_old           = "https://s3-us-west-1.amazonaws.com/hotelbidstestbucket/hotelbidstestbucket/"
    static let urlImageStatic           = "https://hotelbids.com/"
    
    // OLD CODE
    let craftedByURL:String     = "https://www.SIL.com"
    let itunesAppDownloadURL    = "https://itunes.apple.com/us/app"

    //Hotel Bids constants
    static let kAppName                 = "HotelBids"
    static let kAppIdentifier           = "com.hotelbids.app"
    
    static let KEY_Authorization        = "Authorization"
    static let KEY_remember_token       = "remember-token"
    
    static let hbDeviceToken            = "MyDeviceToken"
    static let hbUserStatus             = "UserStatus"
    static let hbEmptyDeviceToken       = "EmptyDeviceToken"
    static let hbUserData               = "UserData"
    
    static let hbUserCountry            = "userCountry"
    
    static let mainStoryboard: UIStoryboard =   UIStoryboard(name: "Main", bundle: nil)
    
    //User Default constant
    static let KEY_Xapi                             = "Xapi"
    static let KEY_Language                         = "language"
    static let KEY_USER_ID                          = "userid"
    static let KEY_AccessToken                      = "Accesstoken"
    static let KEY_DEVICE_TOKEN                     = "Device_Token"
    
    static let KEY_LOGIN_STATUS                     = "LogInStatus"
    static let KEY_NOTIFICATION_TYPE                = "Notification"
    static let KEY_UserModel                        = "userModel"
    static let KEY_Notification_STATUS              = "Notification Status"
    
    static let dateFormat                           = "yyyy-MM-dd HH:mm:ss"
    static let dateFormat_AM_PM                     = "yyyy-MM-dd h:mm a"
    static let dateFormat_Date_only                 = "yyyy-MM-dd"
    static let dateFormat_Time_only                 = "h:mm a"
}

//MARK:
//MARK: App alert title & validation messages
//MARK:

struct AppAlertMsg {
    //Validation alert that used in this app
    
    //Alert title
    static let kPleaseWait = "Please wait"
    static let kOk = "OK"
    static let kYes = "Yes"
    static let kNo = "No"
    static let kCancel = "Cancel"
    static let kErrorMsg = "Something went wrong, please try again later"
    
}
