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
    func pushToLoadRequest(loadDetails: [String:Any]){
        let controller = LoadRequest()
        controller.loadDetails = loadDetails
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToHome(){
        let controller = Home()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToBookingDocuments(booking: BookingModel){
        let controller = BookingDocuments()
        controller.booking = booking
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToTrips(booking: BookingModel?){
        let controller = Trips()
        controller.booking = booking
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToWebView(fileURLString: String?){
        let controller = WebView()
        controller.fileURLString = fileURLString
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToTripDetails(bookingDetail: BookingDetailtModel?, trip: TripsModel?){
        let controller = TripDetail()
        controller.bookingDetail = bookingDetail
        controller.trip = trip
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToTrackLocation(inProgressMile: TripMilesModel?){
        let controller = TrackLocation()
        controller.inProgressMile = inProgressMile
        Constants.inProgressMileNumber = inProgressMile?.tripMileNumber ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func pushToMyContracts(){
        let controller = MyContracts()
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return}
        topNavigationController.pushViewController(controller, animated: true)
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
