//
//  Home.swift
//  TruckerDriver
//
//  Created by Mac Book on 13/11/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class Home: BaseController {
    
    @IBOutlet weak var lblPickUpTitle: UILabel!
    @IBOutlet weak var lblDropOffTitle: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnPickUpTick: UIButton!
    @IBOutlet weak var btnDropOffTick: UIButton!
    @IBOutlet weak var viewPickUpMarker: RoundedView!
    
    var locationPickerType = LocationPickerType.pickUp
    lazy var geocoder = CLGeocoder()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var pickUpLocation : CLLocationCoordinate2D?
    var dropOffLocation: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient!
    var pickUpCity: String?
    var dropOffCity: String?
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    var pickUpLocationMarker = GMSMarker()
    var dropOffLocationMarker = GMSMarker()
    var minDate: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 0, to: Date(), options: [])!//10
    }
    var maxDate: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 70, to: Date(), options: [])!
    }
    var selectedDate:Date?
    var flagShouldReverseGeoCode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnPickUpTick(_ sender: UIButton) {
        if self.btnPickUpTick.isSelected{return}
        self.btnPickUpTick.isSelected = true
        self.btnDropOffTick.isSelected = false
        self.locationPickerType = .pickUp
        self.showPicker()
    }
    @IBAction func onBtnDropOffTick(_ sender: UIButton) {
        if self.btnDropOffTick.isSelected{return}
        self.btnDropOffTick.isSelected = true
        self.btnPickUpTick.isSelected = false
        self.locationPickerType = .dropOff
        self.showPicker()
    }
    @IBAction func onBtnPickUpLocationPicker(_ sender: UIButton) {
        self.locationPickerType = .pickUp
        self.pickLocationFromPlacePicker()
    }
    @IBAction func onBtnDropOffLocationPicker(_ sender: UIButton) {
        self.locationPickerType = .dropOff
        self.pickLocationFromPlacePicker()
    }
    @IBAction func onBtnGoToMyLocation(_ sender: UIButton) {
        if self.currentLocation == nil{
            Utility.main.openSettings()
            return
        }
        if self.pickUpLocation != nil && self.dropOffLocation != nil{
            self.fitAllMarkersBounds()
        }
        else{
            self.zoomToSearchLocation(location: self.currentLocation ?? CLLocationCoordinate2D())
        }
    }
    @IBAction func onBtnNext(_ sender: UIButton) {
    }
}
//MARK:- Helper Methods
extension Home{
    private func setGMSMapView(){
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
    }
    private func setLocationManager(){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    private func zoomToSearchLocation(location: CLLocationCoordinate2D){
        CATransaction.begin()
        CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
        let fancy = GMSCameraPosition.camera(withLatitude: location.latitude,
                                             longitude: location.longitude,
                                             zoom: 18,
                                             bearing: 0,
                                             viewingAngle: 0)
        self.mapView.animate(to: fancy)
        CATransaction.commit()
    }
    private func hidePicker(){
        self.btnPickUpTick.isSelected = false
        self.btnDropOffTick.isSelected = false
        self.viewPickUpMarker.isHidden = true
    }
    private func showPicker(){
        self.viewPickUpMarker.isHidden = false
        switch self.locationPickerType{
        case .pickUp:
            self.btnPickUpTick.isSelected = true
            self.btnDropOffTick.isSelected = false
        case .dropOff:
            self.btnPickUpTick.isSelected = false
            self.btnDropOffTick.isSelected = true
        }
    }
    private func fitAllMarkersBounds() {
        var bounds = GMSCoordinateBounds()
        var markerList = [GMSMarker]()
        if let pathBounds = self.getPathBounds(){
            markerList = pathBounds
        }
        markerList.append(self.pickUpLocationMarker)
        markerList.append(self.dropOffLocationMarker)
        for marker in markerList {
            bounds = bounds.includingCoordinate(marker.position)
        }
        print(markerList)
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(160))
        self.mapView.animate(with: update)
    }
    private func getPathBounds()->[GMSMarker]?{
        if self.path.count() == 0{return nil}
        var arrPinPoints = [GMSMarker]()
        let pathTaken = self.path.count()
        
        if pathTaken > 0{
            for i in 0..<pathTaken{
                let point = path.coordinate(at: i)
                let position = CLLocationCoordinate2D(latitude: point.latitude , longitude: point.longitude)
                arrPinPoints.append(GMSMarker(position: position))
            }
        }
        return arrPinPoints
    }
    private func pickLocationFromPlacePicker(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    private func setPickedAddressFromPlacePickerVC(_ place:GMSPlace){
        switch self.locationPickerType{
        case .pickUp:
            self.lblPickUpTitle.text = place.name ?? "Pick-up Location"
            self.lblPickUp.text = place.formattedAddress ?? "Location Area - City"
            self.pickUpLocation = place.coordinate
            self.pickUpCity = place.addressComponents?.first?.name ?? ""
            self.hidePicker()
            self.zoomToSearchLocation(location: self.pickUpLocation ?? CLLocationCoordinate2D())
            self.addPickUpMarker()
            if let _ = self.dropOffLocation{
                self.hidePicker()
                self.getRoute()
            }
        case .dropOff:
            self.lblDropOffTitle.text = place.name ?? "Drop-off Location"
            self.lblDropOff.text = place.formattedAddress ?? "Location Area - City"
            self.dropOffLocation = place.coordinate
            self.dropOffCity = place.addressComponents?.first?.name ?? ""
            self.addDropOffMarker()
            self.hidePicker()
            self.getRoute()
        }
    }
}
//MARK:- Reverse Geocode Location
extension Home{
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        Utility.hideLoader()
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            switch self.locationPickerType{
            case .pickUp:
                self.lblPickUp.text = "Unable to Find Address for Location"
            case .dropOff:
                self.lblDropOff.text = "Unable to Find Address for Location"
            }
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                switch self.locationPickerType{
                case .pickUp:
                    self.lblPickUpTitle.text = placemark.name ?? "Pick-up Location"
                    self.lblPickUp.text = placemark.compactAddress
                    self.pickUpLocation = placemark.location?.coordinate ?? CLLocationCoordinate2D()
                    self.pickUpCity = placemark.locality
                    self.addPickUpMarker()
                    if let _ = self.dropOffLocation{
                        self.hidePicker()
                        self.fitAllMarkersBounds()
                        self.getRoute()
                    }
                case .dropOff:
                    self.lblDropOffTitle.text = placemark.name ?? "Drop-off Location"
                    self.lblDropOff.text = placemark.compactAddress
                    self.dropOffLocation = placemark.location?.coordinate ?? CLLocationCoordinate2D()
                    self.dropOffCity = placemark.locality
                    self.addDropOffMarker()
                    self.hidePicker()
                    self.getRoute()
                }
            } else {
                switch self.locationPickerType{
                case .pickUp:
                    self.lblPickUp.text = "No Matching Addresses Found"
                case .dropOff:
                    self.lblDropOff.text = "No Matching Addresses Found"
                }
            }
        }
    }
}
//MARK:- GMSMapViewDelegate
extension Home: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if self.viewPickUpMarker.isHidden{
            return
        }
        let center = CGPoint(x: self.mapView.center.x, y: self.mapView.frame.height/2.0)
        let coordinates = mapView.projection.coordinate(for: center)
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.reverseGeoCodeBy(location: location)
    }
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        self.zoomToSearchLocation(location: location)
    }
    private func reverseGeoCodeBy(location:CLLocation){
        Utility.showLoader()
        self.view.endEditing(true)
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
}
//MARK:- CLLocationManagerDelegate
extension Home: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.mapView.isMyLocationEnabled = true
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            self.mapView.isMyLocationEnabled = false
            self.currentLocation = nil
            print("You denied the permission, your location tracking won't work")
            break
        default:
            print("Unknown Status")
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentlocation = locations.first else {return}
        self.currentLocation = currentlocation.coordinate
        if self.pickUpLocation == nil{
            self.pickUpLocation = currentlocation.coordinate
            self.zoomToSearchLocation(location: self.pickUpLocation ?? CLLocationCoordinate2D())
            guard let pickUp = self.pickUpLocation else {return}
            let location = CLLocation(latitude: pickUp.latitude, longitude: pickUp.longitude)
            self.reverseGeoCodeBy(location: location)
            self.flagShouldReverseGeoCode = true
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}
//MARK:- Polyline
extension Home{
    private func getRoute(){
        let origin = "\(self.pickUpLocation?.latitude ?? 0.0),\(self.pickUpLocation?.longitude ?? 0.0)"
        let destination = "\(self.dropOffLocation?.latitude ?? 0.0),\(self.dropOffLocation?.longitude ?? 0.0)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Constants.apiKey)"
        Alamofire.request(url).responseJSON { response in
            do {
                let json = try JSON(data: response.data ?? Data())
                let routes = json["routes"].arrayValue
                self.drawRoute(routesArray: routes)
            } catch {
                print("Hm, something is wrong here. Try connecting to the wifi.")
            }
        }
    }
    private func drawRoute(routesArray: [JSON]) {
        self.resetPolyline()
        if !routesArray.isEmpty{
            let routeDict = routesArray[0]
            let routeOverviewPolyline = routeDict["overview_polyline"].dictionary
            let points = routeOverviewPolyline?["points"]?.stringValue
            self.path = GMSPath.init(fromEncodedPath: points ?? "")!
            self.polyline.path = path
            self.polyline.strokeColor = Global.APP_COLOR
            self.polyline.strokeWidth = 3.0
            self.polyline.map = self.mapView
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
            self.fitAllMarkersBounds()
        }
    }
    @objc private func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.lightGray
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.resetPolyline()
        }
    }
    private func resetPolyline(){
        self.i = 0
        self.animationPath = GMSMutablePath()
        self.animationPolyline.map = nil
    }
    private func getDistance()->String?{
        if self.path.count() == 0{return nil}
        var distance = 0.0
        let pathTaken = self.path.count()
        let p1 = path.coordinate(at: 0)
        var point1 = CLLocation(latitude: p1.latitude , longitude: p1.longitude)
        if pathTaken > 0{
            for i in 1..<pathTaken{
                let p2 = path.coordinate(at: i)
                let point2 = CLLocation(latitude: p2.latitude , longitude: p2.longitude)
                let dist = Double(point1.distance(from: point2))
                distance = distance + dist
                point1 = point2
            }
        }
        let distanceInKM = "\(distance/1000.0)"
        print(distanceInKM)
        return distanceInKM
    }
}
//MARK:- Add marker
extension Home{
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
        self.fitAllMarkersBounds()
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
        self.fitAllMarkersBounds()
    }
}
extension Home: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: {
            self.setPickedAddressFromPlacePickerVC(place)
        })
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        Utility.main.showToast(message: "Error: "+error.localizedDescription)
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
}
