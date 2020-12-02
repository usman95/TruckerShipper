//
//  BaseController.swift
//  The Court Lawyer
//
//  Created by Ahmed Shahid on 5/3/18.
//  Copyright © 2018 Ahmed Shahid. All rights reserved.
//

import Foundation
import UIKit
import LGSideMenuController

class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    @IBAction func onBtnSideMenu(_ sender: UIButton) {
        if MOLHLanguage.currentAppleLanguage() == "en"{
            self.sideMenuController?.showLeftViewAnimated()
        }
        else{
            self.sideMenuController?.showRightViewAnimated()
        }
    }
    @IBAction func onBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- Helper Methods
extension BaseController{
    func setNavigationBar(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        
        //        let currentClassName = Utility.main.topViewController()?.className
        guard let navControllerCount = self.navigationController?.viewControllers.count else {return}
        if navControllerCount > 1 {
            self.sideMenuController?.isLeftViewSwipeGestureEnabled = false
        }
        else{
            self.sideMenuController?.isLeftViewSwipeGestureEnabled = true
        }
    }
}
//MARK:- Application flow
extension BaseController{
    func pushToForgotPassword(){
        let controller = ForgotPassword()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToSignUp(){
        let controller = SignUp()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension BaseController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
            navigationController?.popViewController(animated: true)
        }
        return false
    }
}
