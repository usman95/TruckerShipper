
import Foundation
import UIKit

struct Global{
    static let LOGGED_IN_USER                = AppStateManager.sharedInstance.loggedInUser
    static var APP_MANAGER                   = AppStateManager.sharedInstance
    static var APP_REALM                     = APP_MANAGER.realm
    static let APP_COLOR                     = UIColor(red:0/255, green:71/255, blue:158/255, alpha:1.0)
    static let APP_COLOR_DARK                = UIColor(red:185/255, green:13/255, blue:12/255, alpha:1.0)
}

struct Constants {
    //MARK:- Base URL
    static let BaseURL                     = "http://13.212.49.143:3000"
    static let SocketBaseURL               = ""
    static let APP_DELEGATE                = UIApplication.shared.delegate as! AppDelegate
    static let UIWINDOW                    = UIApplication.shared.delegate!.window!
    static let USER_DEFAULTS               = UserDefaults.standard
    static let SINGLETON                   = Singleton.sharedInstance
    static let DEFAULTS_USER_KEY           = "User"
    static var DeviceType                  = "ios"
    static var DeviceToken                 = "No certificates"
    static let serverDateFormat            = "yyyy-MM-dd HH:mm:ss.SSS"
    static let serverDateFormat1           = "yyyy-MM-dd HH:mm:ss"
    static let PAGINATION_PAGE_SIZE        = 100
    static let VERIFY_CODE_TIME_LIMIT      = 5*60
    static var adminPhone                  = "123456"
    static let apiKey                      = "AIzaSyCJBDZYHuEOl08YzAOTkOPfq0TQ3mO0MgA"
    static var accessToken                 = ""
    static var GoogleSignInClientID        = "821622832147-00elb5glohhc0njcl57bksf4b9kftomc.apps.googleusercontent.com"
    static var BugseeToken                 = "5e97ab5a-d533-443d-be90-5d4fea92b66e"
    static var iTunesURL                   = "http://itunes.apple.com/us/lookup?bundleId="
    static var currency                    = "$"
    static var localCurrency               = "USD"
    static let oneSignalAppID              = "4ac1ff96-ec01-4a69-8abc-414b5884d79f"
    static let gmailSignInClientID         = "857012175771-er4drafle21fh2eh6mn37saode9299jv.apps.googleusercontent.com"
    static var pagesCount                 = 0
    static var ordersCount                = 0
    static let stripeDefaultPublishableKey = "pk_test_51HLEsID30KhvE5IwlgHuVtRB6rtqIBpfVRhOdaPAnLNs1Fa4I2nDEYjgxXY99WtISfwX3E9ylqJ2uh1kFIgcEQuw00FBv96gDW"
}
