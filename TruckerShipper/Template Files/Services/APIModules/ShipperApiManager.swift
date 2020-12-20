import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ShipperAPIManager: APIManagerBase {
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
    //MARK:- UploadDocument
    func UploadDocument(id: String, params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Bookings.rawValue+id+Route.UploadDocument.rawValue)! as URL
        self.postMultipartDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: true)
    }
    //MARK:- BookingDetails
    func BookingDetails(id: String, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Bookings.rawValue+id)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- TripDetails
    func TripDetails(id: String, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Trip.rawValue+id)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- BookingsCount
    func BookingsCount(success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        let route: URL = POSTURLforRoute(route: Route.BookingsCount.rawValue)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Notifications
    func Notifications(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Notifications.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- DeleteNotification
    func DeleteNotification(id: String, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Notifications.rawValue+id)! as URL
        self.deleteDictionaryResponseWith(route: route, parameters: [:], success: success, failure: failure, withHeader: true)
    }
    //MARK:- BookingSearch
    func BookingSearch(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.BookingSearch.rawValue, params: params)! as URL
        self.getArrayResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- BookingStatus
    func BookingStatus(id: String, params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Bookings.rawValue+id+Route.BookingStatus.rawValue)! as URL
        self.putDictionaryResponseWith(route: route, parameters: params, success: success, failure: failure, withHeader: true)
    }
    //MARK:- ShipperContracts
    func ShipperContracts(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.ShipperContracts.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Report
    func Report(params: Parameters, success: @escaping DefaultStringResultAPISuccesClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Report.rawValue, params: params)! as URL
        self.getStringResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
}
