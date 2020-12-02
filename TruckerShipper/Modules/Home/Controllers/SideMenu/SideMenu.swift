//
//  SideMenu.swift
//  TruckerDriver
//
//  Created by Mac Book on 13/11/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit
import LGSideMenuController

class SideMenu: UIViewController {
    
    @IBOutlet weak var segmentLocalization: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSegmentLocalization(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            MOLH.setLanguageTo(LocalizationType.EN.rawValue)
            MOLH.reset(transition: .curveEaseIn, duration: 1)
            AppDelegate.shared.changeRootViewController()
        default:
            MOLH.setLanguageTo(LocalizationType.UR.rawValue)
            MOLH.reset(transition: .curveEaseIn, duration: 1)
            AppDelegate.shared.changeRootViewController()
        }
    }
    @IBAction func onBtnOption(_ sender: UIButton) {
        if MOLHLanguage.currentAppleLanguage() == "en"{
            self.sideMenuController?.hideLeftViewAnimated()
        }
        else{
            self.sideMenuController?.hideRightViewAnimated()
        }
        switch sender.tag {
        case 0:
            self.pushToNotifications()
        case 1:
            self.pushToTripExpenses()
        default:
            AppStateManager.sharedInstance.logoutUser()
        }
    }
    
}
//MARK:- Helper Methods
extension SideMenu{
    private func setUI(){
        if MOLHLanguage.currentAppleLanguage() == LocalizationType.EN.rawValue{
            self.segmentLocalization.selectedSegmentIndex = 0
        }
        else{
            self.segmentLocalization.selectedSegmentIndex = 1
        }
    }
}
//MARK:- Application flow
extension SideMenu{
    private func pushToNotifications(){
        let controller = Notifications()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToTripExpenses(){
        let controller = TripExpenses()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }    
}
