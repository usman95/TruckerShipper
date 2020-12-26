//
//  TrackLocation.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import GoogleMaps
import SocketIO

class TrackLocation: BaseController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var inProgressMile: TripMilesModel?
    
    var currentDriverLocation: CLLocationCoordinate2D?
    var dropOffLocation: CLLocationCoordinate2D?
    
    var driverLocationMarker: GMSMarker?
    var dropOffLocationMarker: GMSMarker?
    
    var lastUpdatedDriverLocation: String?
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectSocket()
        self.addOrMoveDriverMarker(bearing: nil)
        self.addDropOffMarker()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disconnectSocket()
    }
    
}
//MARK:- Helper method
extension TrackLocation{
    private func zoomToSearchLocation(location: CLLocationCoordinate2D){
        CATransaction.begin()
        CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
        let fancy = GMSCameraPosition.camera(withLatitude: location.latitude,
                                             longitude: location.longitude,
                                             zoom: 20,
                                             bearing: 0,
                                             viewingAngle: 0)
        self.mapView.animate(to: fancy)
        CATransaction.commit()
    }
    private func fitAllMarkersBounds() {
        var bounds = GMSCoordinateBounds()
        var markerList = [GMSMarker]()
        markerList.append(self.driverLocationMarker ?? GMSMarker())
        markerList.append(self.dropOffLocationMarker ?? GMSMarker())
        for marker in markerList {
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(160))
        self.mapView.animate(with: update)
    }
    private func getDriverAddress(){
        let driverLocation = CLLocation(latitude: self.currentDriverLocation?.latitude ?? 0.0, longitude: self.currentDriverLocation?.longitude ?? 0.0)
        self.reverseGeoCodeBy(location: driverLocation)
    }
}
//MARK:- Reverse Geocode Location
extension TrackLocation{
    private func reverseGeoCodeBy(location:CLLocation){
        Utility.showLoader()
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        Utility.hideLoader()
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.driverLocationMarker?.title = placemark.compactAddress
                
            } else {
                self.driverLocationMarker?.title = "\(self.currentDriverLocation?.latitude ?? 0.0),\(self.currentDriverLocation?.longitude ?? 0.0)"
            }
        }
        
        let lastUpdatedDriverLocationDateString = self.lastUpdatedDriverLocation ?? ""
        switch lastUpdatedDriverLocationDateString.isEmpty {
        case true:
            self.driverLocationMarker?.snippet = "-"
        default:
            let lastUpdatedDriverLocationDate = Utility.main.stringDateFormatter(dateStr: lastUpdatedDriverLocationDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd MMM yy h:mm a")
            self.driverLocationMarker?.snippet = lastUpdatedDriverLocationDate
        }
        
        self.mapView.selectedMarker = self.driverLocationMarker
    }
}
//MARK:- Add marker
extension TrackLocation{
    private func addOrMoveDriverMarker(bearing: Double?){
        if self.driverLocationMarker == nil{
            let latitude = self.inProgressMile?.lastLocation?.lat ?? 0.0
            let longitude = self.inProgressMile?.lastLocation?.lng ?? 0.0
            self.currentDriverLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            var markerIcon: UIImageView?
            let pickUpPin = UIImage(named: "TruckMapPin")!.withRenderingMode(.alwaysOriginal)
            let markerView = UIImageView(image: pickUpPin)
            markerIcon = markerView
            markerIcon?.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
            self.driverLocationMarker?.map = nil
            self.driverLocationMarker = GMSMarker(position: self.currentDriverLocation ?? CLLocationCoordinate2D())
            self.driverLocationMarker?.iconView = markerIcon
            self.driverLocationMarker?.tracksViewChanges = true
            self.driverLocationMarker?.map = self.mapView
            
            self.fitAllMarkersBounds()
        }
        else{
//            self.driverLocationMarker?.rotation = bearing ?? 0.0
            self.driverLocationMarker?.position = self.currentDriverLocation ?? CLLocationCoordinate2D()
            self.zoomToSearchLocation(location: self.currentDriverLocation ?? CLLocationCoordinate2D())
        }
    }
    private func addDropOffMarker(){
        let latitude = self.inProgressMile?.dropOffLocation.first?.value ?? 0.0
        let longitude = self.inProgressMile?.dropOffLocation.last?.value ?? 0.0
        self.dropOffLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var markerIcon: UIImageView?
        let dropOffPin = UIImage(named: "location_d")!.withRenderingMode(.alwaysOriginal)
        let markerView = UIImageView(image: dropOffPin)
        markerIcon = markerView
        markerIcon?.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        self.dropOffLocationMarker?.map = nil
        self.dropOffLocationMarker = GMSMarker(position: self.dropOffLocation ?? CLLocationCoordinate2D())
        self.dropOffLocationMarker?.iconView = markerIcon
        self.dropOffLocationMarker?.tracksViewChanges = true
        self.dropOffLocationMarker?.map = self.mapView
        self.fitAllMarkersBounds()
    }
}
//MARK:- Add marker
extension TrackLocation: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.mapView.selectedMarker = nil
        self.getDriverAddress()
        return true
    }
}
//MARK:- Socket
extension TrackLocation{
    open class SocketConnection {
        public static let default_ = SocketConnection()
        let manager: SocketManager
        
        private init() {
            let token = AppStateManager.sharedInstance.loggedInUser.authToken ?? ""
            let param:[String:Any] = ["token":token]
            let route = Constants.SocketBaseURL
            let socketURL: URL = Utility.URLforRoute(route: route, params: param)! as URL
            manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
            manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(param), .secure(false))
        }
    }
    private func connectSocket(){
        let socket = SocketConnection.default_.manager.defaultSocket
        if socket.status != .connected{
            socket.connect()
        }
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("received-location-to-shipper-\(Constants.inProgressMileNumber)") {data, ack in
            guard let driverLocation = data.first as? [String:Any] else {return}
            let latitude = driverLocation["lat"] as? Double ?? 0.0
            let longitude = driverLocation["lng"] as? Double ?? 0.0
            let bearing = driverLocation["bearing"] as? Double ?? 0.0
            let date = driverLocation["updateAt"] as? String ?? ""
            
            self.currentDriverLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.lastUpdatedDriverLocation = date
            self.addOrMoveDriverMarker(bearing: bearing)
        }
        socket.on("received-finished-ride-shipper-\(Constants.inProgressMileNumber)") {data, ack in
            guard let mileFinished = data.first as? [String:Any] else {return}
            let message = mileFinished["message"] as? String ?? ""
            Utility.main.showAlert(message: message, title: Strings.CONFIRMATION.text) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    private func disconnectSocket(){
        let socket = SocketConnection.default_.manager.defaultSocket
        socket.removeAllHandlers()
        socket.disconnect()
    }
}
