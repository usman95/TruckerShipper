import Foundation
import UIKit
import RealmSwift

class AppStateManager: NSObject {
    
    static let sharedInstance = AppStateManager()
    var loggedInUser: UserModel!
    var realm: Realm!
    
    override init() {
        super.init()
        if(!(realm != nil)){
            realm = try! Realm()
        }
        loggedInUser = realm.objects(UserModel.self).first
    }
    
    func isUserLoggedIn() -> Bool{
        if (self.loggedInUser) != nil {
            if self.loggedInUser.isInvalidated {
                return false
            }
            return true
        }
        return false
    }
    func loginUser(user:UserModel) {
        try! Global.APP_REALM?.write(){
            AppStateManager.sharedInstance.loggedInUser = user
            Global.APP_REALM?.add(user, update: .all)
        }
        AppDelegate.shared.changeRootViewController()
    }
    func logoutUser(){
        Utility.main.showAlert(message: Strings.ASK_LOGOUT.text, title: Strings.CONFIRMATION.text, YES: Strings.YES.text, NO: Strings.NO.text) { (Yes, No) in
            if (Yes != nil){
                Utility.main.topViewController()?.dismiss(animated: true, completion: {
                    self.processLogoutUser()
                })
            }
            else{
                Utility.main.topViewController()?.dismiss(animated: true, completion: nil)
            }
        }
    }
    func logoutGuestUser(){
        Utility.main.showAlert(message: Strings.ASK_GUEST_LOGOUT.text, title: Strings.CONFIRMATION.text, YES: Strings.LOGIN.text, NO: Strings.CANCEL.text) { (Yes, No) in
            if (Yes != nil){
                Utility.main.topViewController()?.dismiss(animated: true, completion: {
                    self.logoutUserAndChangeRootView()
                })
            }
            else{
                Utility.main.topViewController()?.dismiss(animated: true, completion: nil)
            }
        }
    }
    func logoutUserOnly(){
        try! Global.APP_REALM?.write() {
            Global.APP_REALM?.deleteAll()
            self.loggedInUser = nil
        }
    }
    func logoutUserAndChangeRootView(){
        try! Global.APP_REALM?.write() {
            Global.APP_REALM?.deleteAll()
            self.loggedInUser = nil
        }
        AppDelegate.shared.changeRootViewController()
    }
    func saveUser(user:UserModel) {
        try! Global.APP_REALM?.write(){
            AppStateManager.sharedInstance.loggedInUser = user
            Global.APP_REALM?.add(user, update: .all)
        }
    }
}
extension AppStateManager{
    func guestLogin(guest:UserModel){
        try! Global.APP_REALM?.write(){
            AppStateManager.sharedInstance.loggedInUser = guest
            Global.APP_REALM?.add(guest, update: .all)
        }
        AppDelegate.shared.changeRootViewController()
    }
    func isGuestLoggedIn()->Bool{
        if self.loggedInUser != nil {
            if self.loggedInUser.isGuest {
                return true
            }
        }
        return false
    }
}
extension AppStateManager{
    private func processLogoutUser(){
//        APIManager.sharedInstance.usersAPIManager.Logout(params: [:], success: { (responseObject) in
//            print(responseObject)
//            Utility.hideLoader()
            try! Global.APP_REALM?.write() {
                Global.APP_REALM?.delete(self.loggedInUser)
                self.loggedInUser = nil
            }
            AppDelegate.shared.changeRootViewController()
//        }) { (error) in
//            Utility.hideLoader()
//            print(error)
//        }
    }
}
extension AppStateManager{
    func getAppleCredentials()->Dictionary<String, Any>?{
        if let apple_credentials = UserDefaults().object(forKey: "apple_credentials") as? Dictionary<String, Any> {
            return apple_credentials
        }
        return nil
    }
    func setAppleCredentials(apple_credentials: Dictionary<String, Any>){
        let userDefaults = UserDefaults.standard
        userDefaults.set(apple_credentials, forKey: "apple_credentials")
    }
}
