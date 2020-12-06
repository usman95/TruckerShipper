import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class UsersAPIManager: APIManagerBase {
    //MARK:- Roles
    func Roles(success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Roles.rawValue)!
        self.getArrayResponseWith(route: route, success: success, failure: failure, withHeader: false)
    }
    //MARK:- ShipperTypes
    func ShipperTypes(success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.ShipperTypes.rawValue)!
        self.getArrayResponseWith(route: route, success: success, failure: failure, withHeader: false)
    }
    //MARK:- SignUp
    func SignUp(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.SignUp.rawValue)!
        self.postDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: false)
    }
    //MARK:- Login
    func Login(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Login.rawValue)!
        self.postDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: false)
    }
    //MARK:- ForgotPassword
    func ForgotPassword(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.ForgotPassword.rawValue)!
        self.postDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: false)
    }
    //MARK:- UpdateProfile
    func UpdateProfile(id: String, params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.UpdateProfile.rawValue+id)!
        self.putDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: true)
    }
}
