//
//  DashboardTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 17/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class DashboardTVC: UITableViewCell {

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
    
    func setData(data: BookingsCountModel?){
        let shipperImageURL = AppStateManager.sharedInstance.loggedInUser.user?.profileImageUrl ?? ""
        self.imgShipper.sd_setImage(with: URL(string: shipperImageURL), placeholderImage: UIImage(named: "profilePlaceHolder"))
        
        let firstName = AppStateManager.sharedInstance.loggedInUser.user?.firstName ?? ""
        let lastName = AppStateManager.sharedInstance.loggedInUser.user?.lastName ?? ""
        
        self.lblShipperName.text = "\(firstName) \(lastName)"
        
        self.lblShipperType.text = AppStateManager.sharedInstance.loggedInUser.user?.shipperType ?? ""
        
        let totalBookingsV1 = (data?.pending ?? 0) + (data?.accepted ?? 0) + (data?.rejected ?? 0)
        let totalBookingsV2 = (data?.inProgress ?? 0) + (data?.cancelled ?? 0)
        let totalBookings = totalBookingsV1 + totalBookingsV2
        
        self.lblTotalBookings.text = "\(totalBookings)"
        self.lblBookingsInProgress.text = "\(data?.inProgress ?? 0)"
        self.lblCompletedBookings.text = "\(data?.completed ?? 0)"
        self.lblCancelled.text = "\(data?.cancelled ?? 0)"
    }
    
}