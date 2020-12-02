import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum Route: String {
    //MARK:- USER
    case SignUp = ""
}
class APIManagerBase: NSObject {
    let baseURL = Constants.BaseURL
    let defaultRequestHeader = ["Content-Type": "application/json"]
    let defaultError = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request Failed."])
    
    func getAuthorizationHeader () -> Dictionary<String,String> {
        if let token = APIManager.sharedInstance.serverToken {
            return ["Authorization":"Bearer \(token)"]
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
        
        if let dictData = response.result.value as? NSDictionary {
            
            if let status = dictData["status"] as? Bool{
                if status{
                    let result = dictData["result"] as AnyObject
                    if let token = result["authorization"] as? String {Constants.accessToken = token}
                    if let pagesCount = dictData["pages_count"] as? Int ,let ordersCount = dictData["order_count"] as? Int {
                        Constants.pagesCount = pagesCount
                        Constants.ordersCount = ordersCount
                    }
                    else{
                        Constants.pagesCount = 0
                        Constants.ordersCount = 0
                    }
                    if let pagesCount = dictData["pages_count"] as? Int {
                        Constants.pagesCount = pagesCount
                    }
                    else{
                        Constants.pagesCount = 0
                    }
                    success(result)
                    return
                }
                else{
                    Utility.hideLoader()
                    if let error = (dictData["message"] as? String){
                        if error == "Token is Invalid"{
                            AppStateManager.sharedInstance.logoutUserAndChangeRootView()
                            return
                        }
                        Utility.main.showAlert(message: error, title: Strings.ERROR.text)
                    }
                    else{
                        Utility.main.showAlert(message: errorGenericMessage, title: Strings.ERROR.text)
                    }
                }
            }
        } else {
            //Failure
            Utility.hideLoader()
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
            Alamofire.request(route, method: .get, parameters: nil, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {
                    response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })}
        }
        else{
            Alamofire.request(route, method: .get, parameters: nil, encoding: URLEncoding()).responseJSON {
                response in
                
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? Array<AnyObject>{
                        success(arrayResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
            Alamofire.request(route, method: .get, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .get, parameters: nil, encoding: URLEncoding()).responseJSON {
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
            Alamofire.request(route, method: .get, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
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
            Alamofire.request(route, method: .get , parameters: nil, encoding: URLEncoding.default).responseJSON{
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
            Alamofire.request(route, method: .get, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .get , parameters: nil, encoding: URLEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
            Alamofire.request(route, method: .get, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .get , parameters: nil, encoding: URLEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
                               failure:@escaping DefaultAPIFailureClosure, withHeaders:Bool){
        
        if withHeaders {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? [AnyObject]{
                        success(arrayResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? [AnyObject]{
                        success(arrayResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func postDictionaryResponseWithURLEncoding(route: URL,parameters: Parameters,
                                               success:@escaping DefaultAPISuccessClosure,
                                               failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
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
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{
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
        }
    }
    
    func postBoolResponseWith(route: URL,parameters: Parameters,
                              success:@escaping DefaultBoolResultAPISuccesClosure,
                              failure:@escaping DefaultAPIFailureClosure, withHeader:Bool){
        
        if withHeader{
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
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
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{
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
            Alamofire.request(route, method: .post, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .post , parameters: nil, encoding: URLEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let stringResponse = response as? String{
                        success(stringResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        else{
            Alamofire.request(route, method: .post , parameters: nil, encoding: URLEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let intResponse = response as? Int{
                        success(intResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
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
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: URLEncoding.default).responseJSON{
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
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
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
            Alamofire.request(route, method: .delete, parameters: parameters, encoding: URLEncoding.default).responseJSON{
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
            Alamofire.request(route, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let dictionaryResponse = response as? Dictionary<String, AnyObject>{
                        success(dictionaryResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .put, parameters: parameters, encoding: URLEncoding.default).responseJSON{
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
            Alamofire.request(route, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? [AnyObject]{
                        success(arrayResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
                    }
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .put, parameters: parameters, encoding: URLEncoding.default).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    if let arrayResponse = response as? [AnyObject]{
                        success(arrayResponse)
                    }
                    else{
                        Utility.hideLoader()
                        Utility.main.showAlert(message: Strings.RESPONSE_ERROR.rawValue + "\(route)", title: Strings.ERROR.text)
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
