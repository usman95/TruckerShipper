//
//  BookingsTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 14/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class BookingsTVC: UITableViewCell {

    @IBOutlet weak var lblDistanceInKM: UILabelDeviceClass!
    @IBOutlet weak var lblTimeInHours: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpTime: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpDate: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffTime: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffDate: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpAddress: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffAddress: UILabelDeviceClass!
    
    func setData(data: BookingModel){
        self.lblDistanceInKM.text = "\(data.totalDistance) \(Strings.KM.text)"
//        self.lblTimeInHours.text = data
//        self.lblPickUpTime.text = data
//        self.lblPickUpDate.text = data
//        self.lblDropOffTime.text = data
//        self.lblDropOffDate.text = data
//        self.lblPickUpAddress.text = data
//        self.lblDropOffAddress.text = data
    }
}
