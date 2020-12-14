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
    @IBOutlet weak var lblDuration: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpTime: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpDate: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffTime: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffDate: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpAddress: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffAddress: UILabelDeviceClass!
    
    func setData(data: BookingModel){
        self.lblDistanceInKM.text = "\(data.totalDistance) \(Strings.KM.text)"
        
        let totalDuration = data.totalDuration ?? ""
        self.lblDuration.text = totalDuration.isEmpty ? "-" : totalDuration
        
        let pickUpDateString = data.pickUpDate ?? "2020-12-14T14:24:59.741Z"
        let pickUpTime = Utility.main.stringDateFormatter(dateStr: pickUpDateString, dateFormat: Constants.serverDateFormat, formatteddate: "hh:mm a")
        let pickUpDate = Utility.main.stringDateFormatter(dateStr: pickUpDateString, dateFormat: Constants.serverDateFormat, formatteddate: "d/MMM/yy")
        
        self.lblPickUpTime.text = pickUpTime
        self.lblPickUpDate.text = pickUpDate
        
        let bookingDateString = data.bookingDate ?? "2020-12-14T14:24:59.741Z"
        let bookingTime = Utility.main.stringDateFormatter(dateStr: bookingDateString, dateFormat: Constants.serverDateFormat, formatteddate: "hh:mm a")
        let bookingDate = Utility.main.stringDateFormatter(dateStr: bookingDateString, dateFormat: Constants.serverDateFormat, formatteddate: "d/MMM/yy")
        
        self.lblDropOffTime.text = bookingTime
        self.lblDropOffDate.text = bookingDate
        
        self.lblPickUpAddress.text = data.pickup?.address ?? ""
        self.lblDropOffAddress.text = data.dropOff?.address ?? ""
    }
}
