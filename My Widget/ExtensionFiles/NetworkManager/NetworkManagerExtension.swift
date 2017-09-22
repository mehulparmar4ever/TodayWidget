//
//  NetworkManager.swift
//  Constants.kAppName.localized()
//
//  Created by Mehul Parmar on 08/06/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper

//MARK : - Errors
enum NetworkConnection {
  case available
  case notAvailable
}

//MARK : - Errors
enum API_Type {
    case GET
    case POST
    case DELETE
    case PUT
    case MULTIPART
}

class NetworkManagerExtension {
    let baseUrlDev_OLD : String = "https://hotelbids.com/" + "dev/" + "hb-app/" +  "v3/" + "user/"
    let baseUrlDev : String = "http://polls.apiblueprint.org/"
    
    //MARK : - Shared Manager
    let sharedManager = SessionManager()

    // MARK: - No Internet Connection
    func checkInternetConnection() -> NetworkConnection {
        
        if isNetworkAvailable() {
            return .available
        }
        return .notAvailable
    }
    
    func getHeaders(_ urlString: String) -> [String: String] {
        
        let headerDictionary = [String: String]()
        
//        if UserDetail.rememberToken != nil {
//            if (UserDetail.rememberToken?.length)! > 0 {
//                headerDictionary[Constants.KEY_remember_token] = "\(UserDetail.rememberToken!)"
//            }
//        }
        
        print("urlString: \(urlString)\nheaderDictionary : \(headerDictionary)")
        return headerDictionary
    }
    
    func printResponse(urlString: String, paramaters: [String: AnyObject]?, response: AnyObject) {
        
        let dictResponce = self.getValidatedData(response as AnyObject)
        
//        if dictResponce.boolValue {
            if let paramatersTemp = paramaters {
                if paramatersTemp.values.count > 0 {
                    let jsonParameters = JSON(paramatersTemp)
                    print("\n\n\nurlString : \(urlString) ,\n\n paramaters: \(jsonParameters) ,\n\n Response: \(String(describing: dictResponce))\n\n\n")
                }
                else {
                    print("\n\n\nurlString : \(urlString) ,\n\n Response: \(String(describing: dictResponce))\n\n\n")
                }
            }
            else {
                print("\n\n\nurlString : \(urlString) ,\n\n Response: \(String(describing: dictResponce))\n\n\n")
            }
//        } else {
//            print("urlString : \(urlString) ,\n Response: \(String(describing: dictResponce))")
//        }
    }
    
    func getValidatedData(_ response: AnyObject?) -> JSON {
        
        //Removing null and <null>, and replacing number or integer to string
        guard var dictResponse = response as? NSDictionary else{
            return JSON.null
        }
        
        dictResponse = (dictResponse.replacingNullsWithStrings() as NSDictionary).convertingNumbersToStrings()! as NSDictionary
        let jsonResponce = JSON(dictResponse)
        return jsonResponce
    }
    
    // MARK: - Get Method
    func Get(_ urlString: String, paramaters: [String: AnyObject]? = nil, success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        
        switch checkInternetConnection() {
        case .available:
            Alamofire.request(baseUrlDev.add(urlString: urlString), method: .get, parameters: paramaters, encoding: URLEncoding.default, headers: self.getHeaders(urlString)).responseJSON (completionHandler: { response in
                
                //Success
                if response.result.isSuccess {
                    if let value = response.result.value {
                        self.removeNull(value, success: { (responseObject) in
                            self.printResponse(urlString: urlString, paramaters: paramaters, response: responseObject as AnyObject)
                            success(responseObject)
                        }, failure: { (error) in
                            self.printResponse(urlString: urlString, paramaters: paramaters, response: error as AnyObject)
                            failure(error)
                        })
                    }
                }
                else {
                    self.checkError(API_Type.GET, urlString: urlString, response: response, success: { (responseObject) in
                        success(responseObject)
                    }, failure: { (error) in
                        failure(error)
                    })
                }
            })
            
        case .notAvailable:
            failure(JSON("Please check your internet connection."))
            print("No internet")
        }
    }
    
    // MARK: - POST Method
    func POST(_ urlString: String, paramaters: [String: AnyObject]? = nil, success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
   
        switch checkInternetConnection() {
        case .available:
            sharedManager.request(baseUrlDev.add(urlString: urlString), method: .post, parameters: paramaters, encoding: JSONEncoding.default, headers: self.getHeaders(urlString)).validate().responseJSON(completionHandler: { response in
                
                //Success
                if response.result.isSuccess {
                    if let value = response.result.value {
                        self.removeNull(value, success: { (responseObject) in
                            self.printResponse(urlString: urlString, paramaters: paramaters, response: responseObject as AnyObject)
                            success(responseObject)
                        }, failure: { (error) in
                            self.printResponse(urlString: urlString, paramaters: paramaters, response: error as AnyObject)
                            failure(error)
                        })
                    }
                } //Failure
                else {
                    self.checkError(API_Type.POST, urlString: urlString, response: response, success: { (responseObject) in
                        success(responseObject)
                    }, failure: { (error) in
                        failure(error)
                    })
                }
            })
            
        case .notAvailable:
            failure(JSON("Please check your internet connection."))
            print("No internet")
        }
    }
    
    /*
    // MARK: - Delete Method
    func Delete(_ urlString: String, paramaters: [String: AnyObject]? = nil, showLoader: Bool? = nil, success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        
        switch checkInternetConnection() {
        case .available:
            if let showLoader = showLoader {
                if showLoader {
                    DispatchQueue.main.async(execute: {
                        if !UIApplication.shared.isIgnoringInteractionEvents {
                            UIApplication.shared.beginIgnoringInteractionEvents()
                        }
                        SVProgressHUD.show(withStatus: AppAlertMsg.kPleaseWait)
                    })
                }
            }
            
            sharedManager.request(baseUrlDev.add(urlString: urlString), method: .delete, parameters: paramaters, encoding: JSONEncoding.default, headers: self.getHeaders(urlString)).validate().responseJSON(completionHandler: { response in
                
                DispatchQueue.main.async {
                    if UIApplication.shared.isIgnoringInteractionEvents {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }

                    if let showLoader = showLoader {
                        if showLoader {
                            if SVProgressHUD.isVisible() {
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
                
                //Success
                if response.result.isSuccess {
                    if let value = response.result.value {
                        
                        let dictResponce = self.isValidated(value as AnyObject)
                        
                        //Print response using below method
                        self.printResponse(urlString: urlString, paramaters: paramaters, response: (value as AnyObject))
                        
                        if dictResponce.0 == true {
                            success(dictResponce.1)
                        }
                        else {
                            failure(dictResponce.1)
                        }
                    }
                } else {
                    //Check response error using status code
                    if let strErrorReasonCode : Int = response.response?.statusCode {
                        if let data = response.data {
                            let jsonResponce = JSON(data: data)
                            
                            if strErrorReasonCode == 500 {
                                print("\n\n\n\n server error :\(AppAlertMsg.kErrorMsg) \n\n URL:\(urlString) \n\n paramaters:\(JSON(paramaters as Any))\n\n\n\n")
                                UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kErrorMsg, duration: 3.0, position: "bottom" as AnyObject)
                                failure(jsonResponce)
                                return
                            }

                            if let dictionary : NSDictionary = jsonResponce.dictionaryObject as NSDictionary? {
                                let responce : ResponseDataModel = ModelManager.sharedInstance.getResponseDataModel(dictionary)
                                let authentication_Errors = 401
                                let authentication_Errors_Range = 400..<500
                                let Alamofire_Error = -1005
                                
                                if authentication_Errors == strErrorReasonCode {
                                    print("\n\n\n\nauthentication_Errors (jsonResponce)\n\n\n\n")
                                    self.isUnAuthotized()
                                    failure(jsonResponce)
                                }
                                else if authentication_Errors_Range.contains(strErrorReasonCode) {
                                    print("\n\n\n\nauthentication_Errors_Range :\(strErrorReasonCode) \n\nmessage: \(responce.message) \n\nparamaters: \(String(describing: paramaters)) \n\nresponse: \(jsonResponce)\n\n\n\n")
                                    CustomAlert().ShowAlert(responce.message)
                                    failure(jsonResponce)
                                }
                                else if authentication_Errors_Range.contains(Alamofire_Error) {
                                    self.Delete(urlString, paramaters: paramaters, showLoader: showLoader, success: { (responseObject) in
                                        if response.result.isSuccess {
                                            if let value = response.result.value {
                                                let dictResponce = self.isValidated(value as AnyObject)
                                                if dictResponce.0 == true {
                                                    success(dictResponce.1)
                                                }
                                                else {
                                                    failure(dictResponce.1)
                                                }
                                            }
                                        }
                                    }, failure: {_ in
                                        failure(jsonResponce)
                                    })
                                }
                            }
                            else {
                                print("\n\n\n\n server error :\(AppAlertMsg.kErrorMsg) \n\n URL:\(urlString) \n\n paramaters:\(JSON(paramaters as Any))\n\n\n\n")
                                UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kErrorMsg, duration: 3.0, position: "bottom" as AnyObject)
                                failure(jsonResponce)
                            }
                        }
                    }
                    else {
                        failure(nil)
                    }
                }
            })
            
        case .notAvailable:
            if let _ = showLoader {
                UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kNoInternet, duration: 3.0, position: "bottom" as AnyObject)
            }
            failure(JSON(AppAlertMsg.kNoInternet))
            print("No internet")
        }
    }

    // MARK: - Delete Method
    func Put(_ urlString: String, paramaters: [String: AnyObject]? = nil, showLoader: Bool? = nil, success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        
        switch checkInternetConnection() {
        case .available:
            if let showLoader = showLoader {
                if showLoader {
                    DispatchQueue.main.async(execute: {
                        if !UIApplication.shared.isIgnoringInteractionEvents {
                            UIApplication.shared.beginIgnoringInteractionEvents()
                        }
                        SVProgressHUD.show(withStatus: AppAlertMsg.kPleaseWait)
                    })
                }
            }
            
            sharedManager.request(baseUrlDev.add(urlString: urlString), method: .put, parameters: paramaters, encoding: JSONEncoding.default, headers: self.getHeaders(urlString)).validate().responseJSON(completionHandler: { response in
                
                DispatchQueue.main.async {
                    if UIApplication.shared.isIgnoringInteractionEvents {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    
                    if let showLoader = showLoader {
                        if showLoader {
                            if SVProgressHUD.isVisible() {
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
                
                //Success
                if response.result.isSuccess {
                    if let value = response.result.value {
                        
                        let dictResponce = self.isValidated(value as AnyObject)
                        
                        //Print response using below method
                        self.printResponse(urlString: urlString, paramaters: paramaters, response: (value as AnyObject))
                        
                        if dictResponce.0 == true {
                            success(dictResponce.1)
                        }
                        else {
                            failure(dictResponce.1)
                        }
                    }
                } else {
                    //Check response error using status code
                    if let strErrorReasonCode : Int = response.response?.statusCode {
                        if let data = response.data {
                            let jsonResponce = JSON(data: data)
                            if strErrorReasonCode == 500 {
                                print("\n\n\n\n server error :\(AppAlertMsg.kErrorMsg) \n\n URL:\(urlString) \n\n paramaters:\(JSON(paramaters as Any))\n\n\n\n")
                                UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kErrorMsg, duration: 3.0, position: "bottom" as AnyObject)
                                failure(jsonResponce)
                                return
                            }

                            if let dictionary : NSDictionary = jsonResponce.dictionaryObject as NSDictionary? {
                                let responce : ResponseDataModel = ModelManager.sharedInstance.getResponseDataModel(dictionary)
                                let authentication_Errors = 401
                                let authentication_Errors_Range = 400..<500
                                let Alamofire_Error = -1005
                                
                                if authentication_Errors == strErrorReasonCode {
                                    print("\n\n\n\nauthentication_Errors (jsonResponce)\n\n\n\n")
                                    self.isUnAuthotized()
                                    failure(jsonResponce)
                                }
                                else if authentication_Errors_Range.contains(strErrorReasonCode) {
                                    print("\n\n\n\nauthentication_Errors_Range :\(strErrorReasonCode) \n\nmessage: \(responce.message) \n\nparamaters: \(String(describing: paramaters)) \n\nresponse: \(jsonResponce)\n\n\n\n")
                                    CustomAlert().ShowAlert(responce.message)
                                    failure(jsonResponce)
                                }
                                else if authentication_Errors_Range.contains(Alamofire_Error) {
                                    self.Put(urlString, paramaters: paramaters, showLoader: showLoader, success: { (responseObject) in
                                        if response.result.isSuccess {
                                            if let value = response.result.value {
                                                let dictResponce = self.isValidated(value as AnyObject)
                                                if dictResponce.0 == true {
                                                    success(dictResponce.1)
                                                }
                                                else {
                                                    failure(dictResponce.1)
                                                }
                                            }
                                        }
                                    }, failure: {_ in
                                        failure(jsonResponce)
                                    })
                                }
                            }
                            else {
                                print("\n\n\n\n server error :\(AppAlertMsg.kErrorMsg) \n\n URL:\(urlString) \n\n paramaters:\(JSON(paramaters as Any))\n\n\n\n")
                                UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kErrorMsg, duration: 3.0, position: "bottom" as AnyObject)
                                failure(jsonResponce)
                            }
                        }
                    }
                    else {
                        failure(nil)
                    }
                }
            })
            
        case .notAvailable:
            if let _ = showLoader {
                UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kNoInternet, duration: 3.0, position: "bottom" as AnyObject)
            }
            failure(JSON(AppAlertMsg.kNoInternet))
            print("No internet")
        }
    }

    func PostMultiPart_uploadFiles(_ urlString: String, parameterDictionary: [String : String]?, arrParameterDictionaryWithFile : [[String: Data]], success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        
        // Upload
        switch checkInternetConnection() {
        case .available:
            
            sharedManager.upload(multipartFormData: { multipartFormData in
                
                for (_, parameterDictionaryWithFile) in arrParameterDictionaryWithFile.enumerated() {
                    // Image
                    for (key, Data) in parameterDictionaryWithFile {
                        
                        if(key == "file") {
                            multipartFormData.append(Data, withName: key, fileName: "video.mp4", mimeType: "video/mp4")
                        }
                        else {
                            multipartFormData.append(Data, withName: key, fileName: "image.png", mimeType: "image/png")
                        }
                    }
                }
                
                for (key , value) in parameterDictionary! {
                    multipartFormData.append(value.EncodingText(), withName: key)
                }
                }, to: baseUrlDev.add(urlString: urlString), headers: self.getHeaders(urlString), encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                            SVProgressHUD.showProgress(Float(Progress.fractionCompleted), status: AppAlertMsg.KUploadingImages)
                            if !UIApplication.shared.isIgnoringInteractionEvents {
                                UIApplication.shared.beginIgnoringInteractionEvents()
                            }
                        })
                        
                        upload.responseJSON { response in
                            if UIApplication.shared.isIgnoringInteractionEvents {
                                UIApplication.shared.endIgnoringInteractionEvents()
                            }
                            
                            if SVProgressHUD.isVisible() {
                                SVProgressHUD.dismiss()
                            }
                            
                            // Print server log
//                            let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
//                            print(dataString)
                            
                            //Success
                            if response.result.isSuccess {
                                if let value = response.result.value {
                                    
                                    let dictResponce = self.isValidated(value as AnyObject)

                                    //Print response using below method
                                    self.printResponse(urlString: urlString, paramaters: parameterDictionary! as [String : AnyObject], response: (value as AnyObject))
                                   
                                    if dictResponce.0 == true {
                                        success(dictResponce.1)
                                    }
                                    else {
                                        failure(dictResponce.1)
                                    }
                                }
                            } else {
                                //Check response error using status code
                                if let strErrorReasonCode : Int = response.response?.statusCode {
                                    
                                    if let data = response.data {
                                        let jsonResponce = JSON(data: data)
                                        if strErrorReasonCode == 500 {
                                            print("\n\n\n\n server error :\(AppAlertMsg.kErrorMsg) \n\n URL:\(urlString) \n\n paramaters:\(JSON(parameterDictionary as Any))\n\n\n\n")
                                            UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kErrorMsg, duration: 3.0, position: "bottom" as AnyObject)
                                            failure(jsonResponce)
                                            return
                                        }

                                        if let dictionary : NSDictionary = jsonResponce.dictionaryObject as NSDictionary? {
                                            let responce : ResponseDataModel = ModelManager.sharedInstance.getResponseDataModel(dictionary)
                                            let authentication_Errors = 401
                                            let authentication_Errors_Range = 400..<500
                                            let Alamofire_Error = -1005
                                            
                                            if authentication_Errors == strErrorReasonCode {
                                                print("\n\n\n\nauthentication_Errors :\(strErrorReasonCode) \n\nmessage: \(responce.message) \n\nparamaters: \(String(describing: parameterDictionary)) \n\nresponse: \(jsonResponce)\n\n\n\n")
                                                self.isUnAuthotized()
                                                failure(jsonResponce)
                                            }
                                            else if authentication_Errors_Range.contains(strErrorReasonCode) {
                                                print("\n\n\n\nauthentication_Errors_Range :\(strErrorReasonCode) \n\nmessage: \(responce.message) \n\nparamaters: \(String(describing: parameterDictionary)) \n\nresponse: \(jsonResponce)\n\n\n\n")
                                                CustomAlert().ShowAlert(responce.message)
                                                failure(jsonResponce)
                                            }
                                            else if authentication_Errors_Range.contains(Alamofire_Error) {
                                                self.PostMultiPart_uploadFiles(urlString, parameterDictionary: parameterDictionary, arrParameterDictionaryWithFile: arrParameterDictionaryWithFile, success: { (responseObject) in
                                                    if response.result.isSuccess {
                                                        if let value = response.result.value {
                                                            let dictResponce = self.isValidated(value as AnyObject)
                                                            if dictResponce.0 == true {
                                                                success(dictResponce.1)
                                                            }
                                                            else {
                                                                failure(dictResponce.1)
                                                            }
                                                        }
                                                    }
                                                }, failure: {_ in
                                                    failure(jsonResponce)
                                                })
                                            }

                                        }
                                        else {
                                            failure(jsonResponce)
                                        }
                                    }
                                }
                                else {
                                    failure(nil)
                                }
                            }
                        }
                        
                    case .failure(let encodingError):
                        //self.delegate?.showFailAlert()
                        print(encodingError)
                        break
                    }
            })
            
        case .notAvailable:
            UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kNoInternet, duration: 3.0, position: "bottom" as AnyObject)
            failure(JSON(AppAlertMsg.kNoInternet))
            print("No internet")
        }
    }
    */
    
    func removeNull(_ value: Any, success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        //Removing null and <null>, and replacing number or integer to string
        
        if var dictResponse = value as? NSDictionary {
            dictResponse = (dictResponse.replacingNullsWithStrings() as NSDictionary).convertingNumbersToStrings()! as NSDictionary
            let jsonResponce = JSON(dictResponse)
            success(jsonResponce)
        }
        else if var arrResponse = value as? NSArray {
            arrResponse = (arrResponse.replacingNullsWithStrings() as NSArray).convertingNumbersToStrings()! as NSArray
            let jsonResponce = JSON(arrResponse)
            success(jsonResponce)
        }
        else {
            failure(JSON("No dict, no array found"))
        }
    }
    
    func checkError (_ type:API_Type, urlString: String, paramaters: [String: AnyObject]? = nil, response: DataResponse<Any>, showLoader: Bool? = nil,success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        //Check response error using status code
        if let strErrorReasonCode : Int = response.response?.statusCode {
            
            if let data = response.data {
                guard let jsonResponce = try? JSON(data: data) else {
                    print("\n\n\n\n error :\(AppAlertMsg.kErrorMsg) \n\n URL:\(urlString) \n\n paramaters:\(JSON(paramaters as Any))\n\n\n\n")
                    failure("error")
                    return
                }

                if strErrorReasonCode == 500 {
                    print("\n\n\n\n server error :\(AppAlertMsg.kErrorMsg) \n\n URL:\(urlString) \n\n paramaters:\(JSON(paramaters as Any))\n\n\n\n")
//                    UIApplication.shared.keyWindow?.makeToast(message: AppAlertMsg.kErrorMsg, duration: 3.0, position: "bottom" as AnyObject)
                    failure(jsonResponce)
                    return
                }
                
                //let responce : ResponseDataModel = ModelManager.sharedInstance.getResponseDataModel(dictionary)
                let authentication_Errors = 401
                let authentication_Errors_Range = 400..<500
                let Alamofire_Error = -1005
                
                if authentication_Errors == strErrorReasonCode {
                    print("\n\n\n\nauthentication_Errors :\(strErrorReasonCode) \n\n paramaters: \(String(describing: paramaters)) \n\nresponse: \(jsonResponce)\n\n\n\n")
                    self.isUnAuthotized()
                    failure(jsonResponce)
                }
                else if authentication_Errors_Range.contains(strErrorReasonCode) {
                    print("\n\n\n\nauthentication_Errors_Range :\(strErrorReasonCode) \n\n paramaters: \(String(describing: paramaters)) \n\nresponse: \(jsonResponce)\n\n\n\n")
                    //                                    CustomAlert().ShowAlert(responce.message)
                    failure(jsonResponce)
                }
                else if authentication_Errors_Range.contains(Alamofire_Error) {
                    
                    switch type {
                    case .GET:
                        break
                        
                    case .POST:
                        self.POST(urlString, paramaters: paramaters, success: { (responseObject) in
                            if response.result.isSuccess {
                                if let value = response.result.value {
                                    self.removeNull(value, success: { (responseObject) in
                                        success(responseObject)
                                    }, failure: { (error) in
                                        failure(error)
                                    })
                                }
                            }
                        }, failure: {_ in
                            failure(jsonResponce)
                        })
                        break
                        
                    case .PUT:
                        break
                        
                    case .DELETE:
                        break
                        
                    case .MULTIPART:
                        break
                    }
                }
            }
        }
        else {
            failure(nil)
        }
    }
    
    
    // MARK: - Check Status
    /*
    func isValidated(_ response: AnyObject?) -> (Bool, JSON) {
        
        //Removing null and <null>, and replacing number or integer to string
        guard var dictResponse = response as? NSDictionary else{
            return (false,nil)
        }

        dictResponse = (dictResponse.replacingNullsWithStrings() as NSDictionary).convertingNumbersToStrings()! as NSDictionary
        let jsonResponce = JSON(dictResponse)
//        let responseModel : ResponseDataModel = ModelManager.sharedInstance.getResponseDataModel(dictResponse)
        
        /* //
         HTTP Status Code
         
         200 –   Success/OK
         4xx –   Authentication Errors
         5xx –   Service  Errors
         */ //
        
        
//        guard let statusCodeInt = responseModel.code.toInt() else {
//            print("code is not proper")
//            return (false,jsonResponce)
//        }
        
        let success_Range = 200..<300
        let authentication_Errors = 401
        let authentication_Errors_Range = 400..<500
        let service_Errors_Range = 500..<600
        
        if success_Range.contains(statusCodeInt) {
            // all okey
            return (true, jsonResponce)
        }
        else if authentication_Errors == statusCodeInt {
            print("service_Errors_Range :\(statusCodeInt)")
            self.isUnAuthotized()
            return (false,jsonResponce)
        }
        else if authentication_Errors_Range.contains(statusCodeInt) {
            print("authentication_Errors_Range :\(statusCodeInt)")
            CustomAlert().ShowAlert(responseModel.message)
            return (false,jsonResponce)
        }
        else if service_Errors_Range.contains(statusCodeInt) {
            print("service_Errors_Range :\(statusCodeInt)")
            CustomAlert().ShowAlert(responseModel.message)
            return (false,jsonResponce)
        }
        else {
            return (false,nil)
        }
    }*/
    
    func isUnAuthotized() {
        /*
        // we have to logout, bcos session expired , or user unauthorized
        CustomAlert().ShowAlert(isCancelButton: false, strMessage: AppAlertMsg.kUnAuthotized) { (isYESClicked) in
            if isYESClicked {
                //Delete all data from  user default
                //Set sign in as Home screen
                print("set to Login view controller ")
                
                UserStatus = UserType.Fresh.rawValue
                
                let deviceTokenTemp = DeviceToken
                if let bundle = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundle)
                }
                DeviceToken = deviceTokenTemp
                
//                Constants.appDelegate.logoutSuccess()
            }
        }*/
    }
}

extension String {
    func add(urlString: String) -> URL {
        return URL(string: self + urlString)!
    }

    func EncodingText() -> Data {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
}
