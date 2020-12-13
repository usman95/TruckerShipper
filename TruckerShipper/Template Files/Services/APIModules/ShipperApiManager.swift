import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ShipperAPIManager: APIManagerBase {
    //MARK:- ShipperContracts
    func ShipperContracts(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.ShipperContracts.rawValue, params: params)! as URL
        self.getArrayResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- BookingEstimate
    func BookingEstimate(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.BookingEstimate.rawValue)! as URL
        self.postDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Bookings
    func Bookings(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Bookings.rawValue)! as URL
        self.postDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: true)
    }
    //MARK:- AllBookings
    func AllBookings(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Bookings.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
}
