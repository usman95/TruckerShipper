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
    @IBOutlet weak var viewMyContracts: UIView!
    
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
        if MOLHLanguage.currentAppleLanguage() == LocalizationType.EN.rawValue{
            self.sideMenuController?.hideLeftViewAnimated()
        }
        else{
            self.sideMenuController?.hideRightViewAnimated()
        }
        switch sender.tag {
        case 0:
            self.pushToMyBookings()
        case 1:
            self.pushToShipmentTracking()
        case 2:
            self.pushToNotifications()
        case 3:
            self.pushToReports()
        case 4:
            self.pushToMyContracts()
        case 5:
            self.pushToMyAccount()
        case 6:
            self.pushToChangePassword()
        case 7:
            AppStateManager.sharedInstance.logoutUser()
        default:
            break
        }
    }
    @IBAction func onBtnPrivacyAndTerms(_ sender: UIButton) {
        if MOLHLanguage.currentAppleLanguage() == LocalizationType.EN.rawValue{
            self.sideMenuController?.hideLeftViewAnimated()
        }
        else{
            self.sideMenuController?.hideRightViewAnimated()
        }
        switch sender.tag {
        case 0:
            self.pushToPrivacyPolicy()
        default:
            self.pushToTermsAndConditions()
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
    func setShipperTypeUI(){
        let shipperType = AppStateManager.sharedInstance.loggedInUser.user?.shipperType ?? ""
        switch shipperType{
        case ShipperType.WalkIn.rawValue:
            self.viewMyContracts.isHidden = true
        default:
            self.viewMyContracts.isHidden = false
        }
    }
}
//MARK:- Application flow
extension SideMenu{
    private func pushToMyBookings(){
        let controller = Bookings()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToShipmentTracking(){
        let controller = SearchForAnything()
        controller.searchType = .shipmentTracking
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToNotifications(){
        let controller = Notifications()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToReports(){
        let controller = Reports()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToMyContracts(){
        let controller = MyContracts()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToMyAccount(){
        let controller = MyAccount()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToChangePassword(){
        let controller = ChangePassword()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToPrivacyPolicy(){
        let controller = CMS()
        controller.cmsType = .privacyPolicy
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
    private func pushToTermsAndConditions(){
        let controller = CMS()
        controller.cmsType = .termsAndCondition
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
    }
}
