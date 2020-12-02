import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class UsersAPIManager: APIManagerBase {
    //MARK:- SignUp
    func SignUp(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.SignUp.rawValue)!
        self.postDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: false)
    }
}
