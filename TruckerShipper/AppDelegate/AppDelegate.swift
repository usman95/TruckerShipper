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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MOLH.shared.activate(true)
        GMSServices.provideAPIKey(Constants.apiKey)
        GMSPlacesClient.provideAPIKey(Constants.apiKey)
        IQKeyboardManager.shared.enable = true
        self.changeRootViewController()
        return true
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
