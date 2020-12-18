//
//  TripDetailTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage

class TripDetailTVC: UITableViewCell {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblDistanceInKM: UILabelDeviceClass!
    @IBOutlet weak var lblDate: UILabelDeviceClass!
    @IBOutlet weak var lblPickUp: UILabelDeviceClass!
    @IBOutlet weak var lblDropOff: UILabelDeviceClass!
    @IBOutlet weak var imgDriver: RoundedImage!
    @IBOutlet weak var lblDriverName: UILabelDeviceClass!
    @IBOutlet weak var lblVehicleName: UILabelDeviceClass!
    @IBOutlet weak var lblPhoneNumber: UILabelDeviceClass!
    @IBOutlet weak var btnCallDriver: UIButton!
    @IBOutlet weak var btnMessageDriver: UIButton!
    
    func setData(bookingDetail: BookingDetailtModel?, trip: TripsModel?){
        guard let selectedTrip:TripsModel = bookingDetail?.trips.filter({$0.id == trip?.id}).first else {return}
        
        let selectedInProgressMile = selectedTrip.tripMiles.filter{$0.status == MileType.inProgress.rawValue}.first
        let selectedCompletedMile = selectedTrip.tripMiles.filter{$0.status == MileType.completed.rawValue}.first
        let selectedPendingMile = selectedTrip.tripMiles.filter{$0.status == MileType.completed.rawValue}.first
        
        if selectedInProgressMile != nil{
            self.lblDistanceInKM.text = "\(selectedInProgressMile?.distance ?? 0) \(Strings.KM.text)"
            
            let mileStartDateString = selectedInProgressMile?.mileStartDate ?? "2020-12-14T14:24:59.741Z"
            let mileStartDate = Utility.main.stringDateFormatter(dateStr: mileStartDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd MMM")
            self.lblDate.text = mileStartDate
            
            self.lblPickUp.text = selectedInProgressMile?.pickUpAddress ?? ""
            self.lblDropOff.text = selectedInProgressMile?.dropOffAddress ?? ""
            
            let driverProfile = selectedInProgressMile?.driverId?.profileImageUrl ?? ""
            self.imgDriver.sd_setImage(with: URL(string: driverProfile), placeholderImage: UIImage(named: "profilePlaceHolder"))
            
            self.lblDriverName.text = "\(selectedInProgressMile?.driverId?.firstName ?? "") \(selectedInProgressMile?.driverId?.lastName ?? "")"
            self.lblVehicleName.text = ""
            self.lblPhoneNumber.text = selectedInProgressMile?.driverId?.contactNo ?? ""
            
            return
        }
        if selectedCompletedMile != nil{
            self.lblDistanceInKM.text = "\(selectedCompletedMile?.distance ?? 0) \(Strings.KM.text)"
            
            let mileStartDateString = selectedCompletedMile?.mileStartDate ?? "2020-12-14T14:24:59.741Z"
            let mileStartDate = Utility.main.stringDateFormatter(dateStr: mileStartDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd MMM")
            self.lblDate.text = mileStartDate
            
            self.lblPickUp.text = selectedCompletedMile?.pickUpAddress ?? ""
            self.lblDropOff.text = selectedCompletedMile?.dropOffAddress ?? ""
            
            let driverProfile = selectedCompletedMile?.driverId?.profileImageUrl ?? ""
            self.imgDriver.sd_setImage(with: URL(string: driverProfile), placeholderImage: UIImage(named: "profilePlaceHolder"))
            
            self.lblDriverName.text = "\(selectedCompletedMile?.driverId?.firstName ?? "") \(selectedInProgressMile?.driverId?.lastName ?? "")"
            self.lblVehicleName.text = ""
            self.lblPhoneNumber.text = selectedCompletedMile?.driverId?.contactNo ?? ""
            
            return
        }
        if selectedPendingMile != nil{
            self.lblDistanceInKM.text = "\(selectedPendingMile?.distance ?? 0) \(Strings.KM.text)"

            let mileStartDateString = selectedPendingMile?.mileStartDate ?? "2020-12-14T14:24:59.741Z"
            let mileStartDate = Utility.main.stringDateFormatter(dateStr: mileStartDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd MMM")
            self.lblDate.text = mileStartDate
            
            self.lblPickUp.text = selectedPendingMile?.pickUpAddress ?? ""
            self.lblDropOff.text = selectedPendingMile?.dropOffAddress ?? ""
            
            let driverProfile = selectedPendingMile?.driverId?.profileImageUrl ?? ""
            self.imgDriver.sd_setImage(with: URL(string: driverProfile), placeholderImage: UIImage(named: "profilePlaceHolder"))
            
            self.lblDriverName.text = "\(selectedPendingMile?.driverId?.firstName ?? "") \(selectedInProgressMile?.driverId?.lastName ?? "")"
            self.lblVehicleName.text = ""
            self.lblPhoneNumber.text = selectedPendingMile?.driverId?.contactNo ?? ""
        }
    }
}
