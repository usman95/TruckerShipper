//
//  AppDelegate.swift
//  TruckerShipper
//
//  Created by Mac Book on 29/11/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import LGSideMenuController
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MOLH.shared.activate(true)
        GMSServices.provideAPIKey(Constants.apiKey)
        GMSPlacesClient.provideAPIKey(Constants.apiKey)
        IQKeyboardManager.shared.enable = true
        self.setupPushNotifications(application: application)
        self.changeRootViewController()
        return true
    }
}
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if !AppStateManager.sharedInstance.isUserLoggedIn(){return}
        
        completionHandler([.alert, .badge, .sound])
//        let userInfo = notification.request.content.userInfo
        
//        let notificationTypeId  = userInfo["notificationTypeId"] as? String ?? ""
//        let type = userInfo["type"] as? String ?? ""
//        let dataId = userInfo["dataId"] as? String ?? ""
        
//        let payload = NotificationPayload(notificationTypeId_: notificationTypeId, type_: type, dataId_: dataId)
//        self.handlePresentedNotifications(payload: payload)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
//        let userInfo = response.notification.request.content.userInfo
        
//        let notificationTypeId  = userInfo["notificationTypeId"] as? String ?? ""
//        let type = userInfo["type"] as? String ?? ""
//        let dataId = userInfo["dataId"] as? String ?? ""
        
//        let payload = NotificationPayload(notificationTypeId_: notificationTypeId, type_: type, dataId_: dataId)
//        self.handleReceivedNotifications(payload: payload)
    }
}
//MARK:- Push notifications
extension AppDelegate{
    private func setupPushNotifications(application: UIApplication){
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        self.notificationCenter.delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                print(error?.localizedDescription ?? "")
                return
            }
        }
        application.registerForRemoteNotifications()
    }
}
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Constants.DeviceToken = fcmToken
    }
}
//MARK:- Application flow
extension AppDelegate{
    func changeRootViewController(){
        switch AppStateManager.sharedInstance.isUserLoggedIn(){
        case false:
            self.showLogin()
        case true:
            self.showHome()
        }
    }
    private func showLogin(){
        let controller = Login()
        let rootController = UINavigationController(rootViewController: controller)
        UIApplication.shared.windows.first?.rootViewController = rootController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    private func showHome(){
        let controller = Dashboard()
        let menuController = SideMenu()
        let navController = UINavigationController(rootViewController: controller)
        
        guard let window = self.window else {return}
        window.rootViewController = nil
        
        var rootController = LGSideMenuController()
        if MOLHLanguage.currentAppleLanguage() == "en"{
            rootController = LGSideMenuController(rootViewController: navController,
                                                  leftViewController: menuController,
                                                  rightViewController: nil)
            rootController.leftViewWidth = window.frame.width * 0.75
        }
        else{
            rootController = LGSideMenuController(rootViewController: navController,
                                                  leftViewController: nil,
                                                  rightViewController: menuController)
            rootController.rightViewWidth = window.frame.width * 0.75
        }
        
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}
