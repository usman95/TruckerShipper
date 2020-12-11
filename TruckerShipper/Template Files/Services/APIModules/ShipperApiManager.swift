import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ShipperAPIManager: APIManagerBase {
    //MARK:- Country
    func ShipperContracts(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.ShipperContracts.rawValue, params: params)! as URL
        self.getArrayResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
}
