//
//  TripDetailTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
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
    
    var pickUpLocation : CLLocationCoordinate2D?
    var dropOffLocation: CLLocationCoordinate2D?
    
    var pickUpLocationMarker = GMSMarker()
    var dropOffLocationMarker = GMSMarker()
    
}
extension TripDetailTVC{
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
            
            let pickUpLocation = CLLocationCoordinate2D(latitude: selectedInProgressMile?.pickUpLocation.first?.value ?? 0.0, longitude: selectedInProgressMile?.pickUpLocation.last?.value ?? 0.0)
            self.pickUpLocation = pickUpLocation
            
            let dropOffLocation = CLLocationCoordinate2D(latitude: selectedInProgressMile?.dropOffLocation.first?.value ?? 0.0, longitude: selectedInProgressMile?.dropOffLocation.last?.value ?? 0.0)
            self.dropOffLocation = dropOffLocation
            
            self.addPickUpMarker()
            self.addDropOffMarker()
            self.fitAllMarkersBounds()
            
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
            
            let pickUpLocation = CLLocationCoordinate2D(latitude: selectedCompletedMile?.pickUpLocation.first?.value ?? 0.0, longitude: selectedCompletedMile?.pickUpLocation.last?.value ?? 0.0)
            self.pickUpLocation = pickUpLocation
            
            let dropOffLocation = CLLocationCoordinate2D(latitude: selectedCompletedMile?.dropOffLocation.first?.value ?? 0.0, longitude: selectedCompletedMile?.dropOffLocation.last?.value ?? 0.0)
            self.dropOffLocation = dropOffLocation
            
            self.addPickUpMarker()
            self.addDropOffMarker()
            self.fitAllMarkersBounds()
            
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
            
            let pickUpLocation = CLLocationCoordinate2D(latitude: selectedPendingMile?.pickUpLocation.first?.value ?? 0.0, longitude: selectedPendingMile?.pickUpLocation.last?.value ?? 0.0)
            self.pickUpLocation = pickUpLocation
            
            let dropOffLocation = CLLocationCoordinate2D(latitude: selectedPendingMile?.dropOffLocation.first?.value ?? 0.0, longitude: selectedPendingMile?.dropOffLocation.last?.value ?? 0.0)
            self.dropOffLocation = dropOffLocation
            
            self.addPickUpMarker()
            self.addDropOffMarker()
            self.fitAllMarkersBounds()

        }
    }
    private func addPickUpMarker(){
        var markerIcon: UIImageView?
        let pickUpPin = UIImage(named: "location_p")!.withRenderingMode(.alwaysOriginal)
        let markerView = UIImageView(image: pickUpPin)
        markerIcon = markerView
        markerIcon?.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        self.pickUpLocationMarker.map = nil
        self.pickUpLocationMarker = GMSMarker(position: self.pickUpLocation ?? CLLocationCoordinate2D())
        self.pickUpLocationMarker.iconView = markerIcon
        self.pickUpLocationMarker.tracksViewChanges = true
        self.pickUpLocationMarker.map = self.mapView
    }
    private func addDropOffMarker(){
        var markerIcon: UIImageView?
        let dropOffPin = UIImage(named: "location_d")!.withRenderingMode(.alwaysOriginal)
        let markerView = UIImageView(image: dropOffPin)
        markerIcon = markerView
        markerIcon?.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        self.dropOffLocationMarker.map = nil
        self.dropOffLocationMarker = GMSMarker(position: self.dropOffLocation ?? CLLocationCoordinate2D())
        self.dropOffLocationMarker.iconView = markerIcon
        self.dropOffLocationMarker.tracksViewChanges = true
        self.dropOffLocationMarker.map = self.mapView
    }
    private func fitAllMarkersBounds() {
        DispatchQueue.main.async {
            var bounds = GMSCoordinateBounds()
            var markerList = [GMSMarker]()
            markerList.append(self.pickUpLocationMarker)
            markerList.append(self.dropOffLocationMarker)
            for marker in markerList {
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(52))
            self.mapView.animate(with: update)
        }
    }
}
