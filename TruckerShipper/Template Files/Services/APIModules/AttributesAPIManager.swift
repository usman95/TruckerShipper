import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class AttributesAPIManager: APIManagerBase {
    //MARK:- Country
    func Country(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Country.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- City
    func City(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.City.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Size
    func Size(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Size.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Commodity
    func Commodity(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Commodity.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- CargoType
    func CargoType(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.CargoType.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Weight
    func Weight(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Weight.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- BookingType
    func BookingType(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.BookingType.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- ShippingLine
    func ShippingLine(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.ShippingLine.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Locations
    func Locations(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.Locations.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- Routes
    func Routes(success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.Routes.rawValue)!
        self.getArrayResponseWith(route: route, success: success, failure: failure, withHeader: false)
    }
    //MARK:- CargoMode
    func CargoMode(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.CargoMode.rawValue, params: params)! as URL
        self.getArrayResponseWith(route: route, success: success, failure: failure, withHeader: false)
    }
    //MARK:- TransportMode
    func TransportMode(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = URLforRoute(route: Route.TransportMode.rawValue, params: params)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: true)
    }
    //MARK:- PrivacyPolicy
    func PrivacyPolicy(success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.PrivacyPolicy.rawValue)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: false)
    }
    //MARK:- TermsAndCondition
    func TermsAndCondition(success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure){
        Utility.showLoader()
        let route: URL = POSTURLforRoute(route: Route.TermsAndCondition.rawValue)! as URL
        self.getDictionaryResponseWith(route: route, success: success, failure: failure, withHeader: false)
    }
}
