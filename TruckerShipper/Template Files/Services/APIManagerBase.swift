import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum Route: String {
    //MARK:- USER
    case Roles = "/public/roles"
    case ShipperTypes = "/public/shipper-types"
    case SignUp = "/auth/sign-up"
    case Login = "/auth/shipper/login"
    case Logout = "/api/user/logout"
    case ForgotPassword = "/auth/forget-pass"
    case UpdateProfile = "/api/user/"
    case UploadProfile = "/upload/profile-pic"
    case UpdatePassword = "/password"
    
    //MARK:- ATTRIBUTES
    case Country = "/api/country"
    case City = "/api/city/"
    case Size = "/api/size"
    case Commodity = "/api/commodity"
    case CargoType = "/api/cargo-type"
    case Weight = "/api/weight"
    case Routes = "/public/booking-routes"
    case BookingType = "/api/booking-type"
    case ShippingLine = "/api/shipping-line"
    case Locations = "/api/location"
    case CargoMode = "/public/cargo-modes"
    case TransportMode = "/api/transport-mode"
    case GetProfile = "/auth/me"
    case PrivacyPolicy = "/public/system/privacy"
    case TermsAndCondition = "/public/system/terms"
    
    //MARK:- ALL
    case ShipperContracts = "/api/shipper-contract"
    case BookingEstimate = "/api/booking-estimate"
    case Bookings = "/api/booking/"
    case UploadDocument = "/upload-document"
    case BookingsCount = "/api/stats/shipper"
    case Trip = "/api/trip/"
    case Notifications = "/api/notification/"
    case BookingSearch = "/api/booking-search"
    case BookingStatus = "/status"
    case Report = "/api/report/booking"
    case CheckCity = "/api/check-city"
}
class APIManagerBase: NSObject {
    let baseURL = Constants.BaseURL
    let defaultRequestHeader = ["Content-Type": "application/json"]
    let defaultError = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request Failed."])
    
    func getAuthorizationHeader () -> [String:String] {
        if let token = APIManager.sharedInstance.serverToken {
            if !AppStateManager.sharedInstance.isUserLoggedIn(){
                return ["device-id":Constants.DeviceToken]
            }
            return ["auth-token":"\(token)"]
        }
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    func URLforRoute(route: String,params:[String: Any]) -> NSURL? {
        if let components: NSURLComponents  = NSURLComponents(string: (Constants.BaseURL+route)){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params {
                queryItems.append(NSURLQueryItem(name:key,value: "\(value)"))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            return components.url as NSURL?
        }
        return nil
    }
    func POSTURLforRoute(route:String) -> URL?{
        
        if let components: NSURLComponents = NSURLComponents(string: (Constants.BaseURL+route)){
            return components.url! as URL
        }
        return nil
    }
}
//MARK:- Response Handle
extension APIManagerBase{
    fileprivate func responseResult(_ response:DataResponse<Any>,
                                    success: @escaping (_ response: AnyObject) -> Void,
                                    failure: @escaping (_ error: NSError) -> Void) {
        let errorGenericMessage = Strings.ERROR_GENERIC_MESSAGE.text
        
        Utility.hideLoader()
        
        if let dictData = response.result.value as? NSDictionary {
            
            if let status = dictData["success"] as? Bool{
                if status{
                    if let message = dictData["message"] as? String {Constants.apiMessage = message}
                    
                    let result = dictData["data"] as AnyObject
                    success(result)
                    return
                }
                else{
                    if let errorMessage = (dictData["message"] as? String){
                        if errorMessage == "The token has expired, please login again!"{
                            AppStateManager.sharedInstance.logoutUserAndChangeRootView()
                        }
                        else{
                            let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                            let error = NSError(domain: "Domain", code: 0, userInfo: userInfo);
                            failure(error)
                            Utility.main.showAlert(message: errorMessage, title: Strings.ERROR.text)
                        }
                    }
                    else{
                        Utility.main.showAlert(message: errorGenericMessage, title: Strings.ERROR.text)
                    }
                }
            }
        } else {
            //Failure
            let errorMessage: String = Strings.UNKNOWN_ERROR.text+"\(response.response?.url?.absoluteString ?? "")"
            let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
            let error = NSError(domain: "Domain", code: 0, userInfo: userInfo);
            failure(error)
            Utility.main.showAlert(message: errorGenericMessage, title: Strings.ERROR.text)
        }
    }
}

//MARK:- Get APIs
extension APIManagerBase{
    
    func getArrayResponseWith(route: URL,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure,
                              withHeader: Bool){
        if withHeader{
            Alamofire.request(route, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {
                    response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        success(Array<AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })}
        }
        else{
            Alamofire.request(route, method: .get, parameters: nil, encoding: JSONEncoding()).responseJSON {
                response in
                
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        success(Array<AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func getDictionaryResponseWith(route: URL,
                                   success:@escaping DefaultAPISuccessClosure,
                                   failure:@escaping DefaultAPIFailureClosure, withHeader: Bool){
        if withHeader{
            Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .get, parameters: nil, encoding: JSONEncoding()).responseJSON {
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func getBoolResponseWith(route: URL,
                             success:@escaping DefaultBoolResultAPISuccesClosure,
                             failure:@escaping DefaultAPIFailureClosure, withHeader: Bool){
        if withHeader{
            Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let boolResponse = response as? Bool{
                        success(boolResponse)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .get , parameters: nil, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let boolResponse = response as? Bool{
                        success(boolResponse)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func getStringResponseWith(route: URL,
                               success:@escaping DefaultStringResultAPISuccesClosure,
                               failure:@escaping DefaultAPIFailureClosure, withHeader: Bool){
        if withHeader{
            Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        success(String())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .get , parameters: nil, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        success(String())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func getIntResponseWith(route: URL,
                            success:@escaping DefaultIntResultAPISuccesClosure,
                            failure:@escaping DefaultAPIFailureClosure, withHeader: Bool){
        if withHeader{
            Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        success(Int())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .get , parameters: nil, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        success(Int())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
}
//MARK:- Post APIs
extension APIManagerBase{
    
    func postArrayResponseWith(route: URL,parameters: Parameters,
                               success:@escaping DefaultArrayResultAPISuccessClosure,
                               failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        success(Array<AnyObject>())
                    }
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        success(Array<AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func postDictionaryResponseWith(route: URL,parameters: Parameters,
                                    success:@escaping DefaultAPISuccessClosure,
                                    failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func postDictionaryResponseWithJSONEncoding(route: URL,parameters: Parameters,
                                               success:@escaping DefaultAPISuccessClosure,
                                               failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func postMultipartDictionaryResponseWith(route: URL,parameters: Parameters,
                                             success:@escaping DefaultAPISuccessClosure,
                                             failure:@escaping DefaultAPIFailureClosure , withHeader: Bool){
        if withHeader{
            Alamofire.upload(multipartFormData:{ multipartFormData in
                for (key , value) in parameters {
                    if let data:Data = value as? Data {
                        multipartFormData.append(data, withName: key, fileName: "\(data.getExtension)", mimeType: "\(data.mimeType)")
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            },
                             usingThreshold:UInt64.init(),
                             to: route,
                             method:.post,
                             headers: getAuthorizationHeader(),
                             encodingCompletion: { result in
                                switch result {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        self.responseResult(response, success: {result in
                                            if let dictionaryResponse = result as? Dictionary<String, AnyObject>{
                                                success(dictionaryResponse)
                                            }
                                            else{
                                                Utility.hideLoader()
                                                Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                                            }
                                        }, failure: {error in
                                            
                                            failure(error)
                                        })
                                    }
                                case .failure(let encodingError):
                                    failure(encodingError as NSError)
                                }
            }
                
            )
            
            
        }else{
            Alamofire.upload (
                multipartFormData: { multipartFormData in
                    for (key , value) in parameters {
                        if let data:Data = value as? Data {
                            multipartFormData.append(data, withName: key, fileName: "\(data.getExtension)", mimeType: "\(data.mimeType)")
                        } else {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                        }
                    }
                    
            },
                to: route,
                encodingCompletion: { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.responseResult(response, success: {result in
                                if let dictionaryResponse = result as? Dictionary<String, AnyObject>{
                                    success(dictionaryResponse)
                                }
                                else{
                                    success(Dictionary<String, AnyObject>())
                                }
                            }, failure: {error in
                                
                                failure(error)
                            })
                        }
                    case .failure(let encodingError):
                        failure(encodingError as NSError)
                    }
            }
            )
        }
    }
    
    func postBoolResponseWith(route: URL,parameters: Parameters,
                              success:@escaping DefaultBoolResultAPISuccesClosure,
                              failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let boolResponse = response as? Bool{
                        success(boolResponse)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let boolResponse = response as? Bool{
                        success(boolResponse)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func postStringResponseWith(route: URL,
                                success:@escaping DefaultStringResultAPISuccesClosure,
                                failure:@escaping DefaultAPIFailureClosure, withHeader: Bool){
        if withHeader{
            Alamofire.request(route, method: .post, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        success(String())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .post , parameters: nil, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        success(String())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func postIntResponseWith(route: URL,parameters: Parameters,
                             success:@escaping DefaultIntResultAPISuccesClosure,
                             failure:@escaping DefaultAPIFailureClosure, withHeader: Bool){
        if withHeader{
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        success(Int())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .post , parameters: nil, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        success(Int())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
}
extension APIManagerBase{
    func deleteDictionaryResponseWith(route: URL,parameters: Parameters,
                                      success:@escaping DefaultAPISuccessClosure,
                                      failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func deleteBoolResponseWith(route: URL,parameters: Parameters,
                                success:@escaping DefaultBoolResultAPISuccesClosure,
                                failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let boolResponse = response as? Bool{
                        success(boolResponse)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let boolResponse = response as? Bool{
                        success(boolResponse)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
}
//MARK:- Put APIs
extension APIManagerBase{
    
    func putDictionaryResponseWith(route: URL,parameters: Parameters,
                                   success:@escaping DefaultAPISuccessClosure,
                                   failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        success(Dictionary<String, AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func putArrayResponseWith(route: URL,parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        success(Array<AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        success(Array<AnyObject>())
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func putMultipartDictionaryResponseWith(route: URL,parameters: Parameters,
                                            success:@escaping DefaultAPISuccessClosure,
                                            failure:@escaping DefaultAPIFailureClosure , withHeader: Bool){
        if withHeader{
            Alamofire.upload(multipartFormData:{ multipartFormData in
                for (key , value) in parameters {
                    if let data:Data = value as? Data {
                        multipartFormData.append(data, withName: key, fileName: "\(data.getExtension)", mimeType: "\(data.mimeType)")
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            },
                             usingThreshold:UInt64.init(),
                             to: route,
                             method:.put,
                             headers: getAuthorizationHeader(),
                             encodingCompletion: { result in
                                switch result {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        self.responseResult(response, success: {result in
                                            if let dictionaryResponse = result as? Dictionary<String, AnyObject>{
                                                success(dictionaryResponse)
                                            }
                                            else{
                                                success(Dictionary<String, AnyObject>())
                                            }
                                        }, failure: {error in
                                            
                                            failure(error)
                                        })
                                    }
                                case .failure(let encodingError):
                                    failure(encodingError as NSError)
                                }
            }
                
            )
            
            
        }else{
            Alamofire.upload (
                multipartFormData: { multipartFormData in
                    for (key , value) in parameters {
                        if let data:Data = value as? Data {
                            multipartFormData.append(data, withName: key, fileName: "\(data.getExtension)", mimeType: "\(data.mimeType)")
                        } else {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                        }
                    }
                    
            },
                to: route,
                encodingCompletion: { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.responseResult(response, success: {result in
                                if let dictionaryResponse = result as? Dictionary<String, AnyObject>{
                                    success(dictionaryResponse)
                                }
                                else{
                                    success(Dictionary<String, AnyObject>())
                                }
                            }, failure: {error in
                                
                                failure(error)
                            })
                        }
                    case .failure(let encodingError):
                        failure(encodingError as NSError)
                    }
            }
            )
        }
    }
}

public extension Data {
    var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x25:
                return "application/pdf";
            case 0xD0:
                return "application/vnd";
            case 0x46:
                return "text/plain";
            default:
                print("mimeType for \(c[0]) in available");
                return "application/octet-stream";
            }
        }
    }
    var getExtension: String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "_IMG.jpeg";
            case 0x89:
                return "_IMG.png";
            case 0x47:
                return "_IMG.gif";
            case 0x49, 0x4D:
                return "_IMG.tiff";
            case 0x25:
                return "_FILE.pdf";
            case 0xD0:
                return "_FILE.vnd";
            case 0x46:
                return "_FILE.txt";
            default:
                print("mimeType for \(c[0]) in available");
                return "_video.mp4";
            }
        }
    }
}
