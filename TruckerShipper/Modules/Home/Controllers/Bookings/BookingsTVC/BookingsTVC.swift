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
    @IBOutlet weak var btnViewTrips: UIButtonDeviceClass!
    @IBOutlet weak var btnAddDocuments: UIButtonDeviceClass!
    
    func setData(data: BookingModel){
        self.lblDistanceInKM.text = "\(data.totalDistance) \(Strings.KM.text)"
        
//        let totalDuration = data.totalDuration ?? ""
//        self.lblDuration.text = totalDuration.isEmpty ? "-" : totalDuration
        self.lblDuration.text = (data.status ?? "").uppercased()
        
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
        
        let bookingStatus = data.status ?? ""
        
        switch bookingStatus {
        case BookingType.pending.rawValue:
            self.btnViewTrips.isHidden = true
            self.btnAddDocuments.isHidden = true
        case BookingType.inProgress.rawValue:
            self.btnAddDocuments.isHidden = data.documents.isEmpty
            self.btnViewTrips.isHidden = false
        case BookingType.accepted.rawValue:
            self.btnAddDocuments.isHidden = data.documents.isEmpty
            self.btnViewTrips.isHidden = false
        case BookingType.completed.rawValue:
            self.btnViewTrips.isHidden = true
            self.btnAddDocuments.isHidden = true
        case BookingType.rejected.rawValue:
            self.btnViewTrips.isHidden = true
            self.btnAddDocuments.isHidden = true
        default:
            self.btnViewTrips.isHidden = true
            self.btnAddDocuments.isHidden = true
        }
    }
    func setData(bookingDetails: BookingDetailtModel?, trip: TripsModel?){
        let tripID = trip?.tripNumber ?? ""
        self.lblDistanceInKM.text = tripID
        
        guard let selectedTrip:TripsModel = bookingDetails?.trips.filter({$0.id == trip?.id}).first else {return}
        if selectedTrip.tripMiles.isEmpty{
            self.lblDuration.text = Strings.NO_MILES_ADDED.text.uppercased()
        }
        else{
            let lastMile = selectedTrip.tripMiles.last?.status ?? ""
            if lastMile == MileType.completed.rawValue{
                self.lblDuration.text = MileType.completed.rawValue.uppercased()
            }
            else{
                self.lblDuration.text = MileType.inProgress.rawValue.uppercased()
            }
        }
        
        let pickUpDateString = bookingDetails?.pickUpDate ?? "2020-12-14T14:24:59.741Z"
        let pickUpTime = Utility.main.stringDateFormatter(dateStr: pickUpDateString, dateFormat: Constants.serverDateFormat, formatteddate: "hh:mm a")
        let pickUpDate = Utility.main.stringDateFormatter(dateStr: pickUpDateString, dateFormat: Constants.serverDateFormat, formatteddate: "d/MMM/yy")
        
        self.lblPickUpTime.text = pickUpTime
        self.lblPickUpDate.text = pickUpDate
        
        let bookingDateString = bookingDetails?.bookingDate ?? "2020-12-14T14:24:59.741Z"
        let bookingTime = Utility.main.stringDateFormatter(dateStr: bookingDateString, dateFormat: Constants.serverDateFormat, formatteddate: "hh:mm a")
        let bookingDate = Utility.main.stringDateFormatter(dateStr: bookingDateString, dateFormat: Constants.serverDateFormat, formatteddate: "d/MMM/yy")
        
        self.lblDropOffTime.text = bookingTime
        self.lblDropOffDate.text = bookingDate
        
        self.lblPickUpAddress.text = bookingDetails?.pickup?.address ?? ""
        self.lblDropOffAddress.text = bookingDetails?.dropOff?.address ?? ""
        
        self.btnViewTrips.isHidden = true
        self.btnAddDocuments.isHidden = true
    }
}
