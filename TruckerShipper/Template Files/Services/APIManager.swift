import Foundation
import UIKit

typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultArrayResultAPISuccessClosure = (Array<AnyObject>) -> Void
typealias DefaultStringResultAPISuccesClosure = (String) -> Void
typealias DefaultIntResultAPISuccesClosure = (Int) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void
typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultImageResultClosure = (UIImage) -> Void
// download closures
typealias DefaultDownloadSuccessClosure = (Data) -> Void
typealias DefaultDownloadProgressClosure = (Double, Int) -> Void
typealias DefaultDownloadFailureClosure = (NSError, Data, Bool) -> Void

protocol APIErrorHandler {
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromERror(error:NSError)
}

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    var serverToken: String? {
        get{
            if AppStateManager.sharedInstance.isUserLoggedIn(){
                return AppStateManager.sharedInstance.loggedInUser.authToken
            }
            return Constants.accessToken
        }
    }
    
    let usersAPIManager = UsersAPIManager()
    let attributesAPIManager = AttributesAPIManager()
    let shipperAPIManager = ShipperAPIManager()
}
