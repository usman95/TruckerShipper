//
//  DashboardHeader.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import SDWebImage

class DashboardHeader: UIView {

    @IBOutlet weak var imgShipper: RoundedImage!
    @IBOutlet weak var lblShipperName: UILabelDeviceClass!
    @IBOutlet weak var lblShipperType: UILabelDeviceClass!
    @IBOutlet weak var tfSearchAnything: UITextFieldDeviceClass!
    @IBOutlet weak var lblTotalBookings: UILabelDeviceClass!
    @IBOutlet weak var lblBookingsInProgress: UILabelDeviceClass!
    @IBOutlet weak var lblCompletedBookings: UILabelDeviceClass!
    @IBOutlet weak var lblCancelled: UILabelDeviceClass!
    @IBOutlet weak var btnTotalBookings: UIButton!
    @IBOutlet weak var btnBookingsInProgress: UIButton!
    @IBOutlet weak var btnCompletedBookings: UIButton!
    @IBOutlet weak var btnCancelled: UIButton!
    
    
    class func instanceFromNib() -> UIView{
        return UINib(nibName: "DashboardHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    func setData(){
        let shipperImageURL = AppStateManager.sharedInstance.loggedInUser.user?.profileImageUrl ?? ""
        self.imgShipper.sd_setImage(with: URL(string: shipperImageURL), placeholderImage: UIImage(named: "profilePlaceHolder"))
        
        let firstName = AppStateManager.sharedInstance.loggedInUser.user?.firstName ?? ""
        let lastName = AppStateManager.sharedInstance.loggedInUser.user?.lastName ?? ""
        
        self.lblShipperName.text = "\(firstName) \(lastName)"
        
        self.lblShipperType.text = AppStateManager.sharedInstance.loggedInUser.user?.shipperType ?? ""
    }
}
