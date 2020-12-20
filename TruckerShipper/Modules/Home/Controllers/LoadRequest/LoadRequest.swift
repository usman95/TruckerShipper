//
//  LoadRequest.swift
//  TruckerShipper
//
//  Created by Mac Book on 11/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import DropDown
import ObjectMapper

class LoadRequest: BaseController {
    
    @IBOutlet weak var lblPickUpCity: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffCity: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpAddress: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffAddress: UILabelDeviceClass!
    
    @IBOutlet weak var tfPickUpDetailsFullName: UITextFieldDeviceClass!
    @IBOutlet weak var tfPickUpDetailsPhoneNumber: UITextFieldDeviceClass!
    @IBOutlet weak var tfPickUpDetailsCity: UITextFieldDeviceClass!
    @IBOutlet weak var tfPickUpDetailsPickUpName: UITextFieldDeviceClass!
    @IBOutlet weak var tfPickUpDetailsLabourers: UITextFieldDeviceClass!
    
    @IBOutlet weak var tfDropOffDetailsFullName: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsPhoneNumber: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsCity: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsDropOffName: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsLabourers: UITextFieldDeviceClass!
    
    @IBOutlet weak var tfBookingDetailsCustomerName: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsBookingDate: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsRoute: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsModeOfTransport: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsTransitFreeDays: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsDnDPickUpDate: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsBookingType: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsCargoMode: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsCargoType: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsShippingLine: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsCommodity: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsRemarks: UITextFieldDeviceClass!
    
    @IBOutlet weak var btnCreatebooking: UIButtonDeviceClass!
    
    var loadDetails: [String:Any]?
    
    var arrCities = [AttributeModel]()
    
    var selectedPickUpDetailsCity: AttributeModel?
    var selectedDropOffDetailsCity: AttributeModel?
    
    var bookingDatePickerType = BookingDatePickerType.booking
    var selecteBookingDate: Date?
    var selectePickUpDate: Date?
    
    var arrRoutes = [String]()
    var selectedRoute: String?
    
    let bookingTypeDropDown = DropDown()
    var arrBookingType = [AttributeModel]()
    var selectedBookingType: AttributeModel?
    
    let shippingLineDropDown = DropDown()
    var arrShippingLine = [ShippingLineModel]()
    var selectedShippingLine: ShippingLineModel?
    
    var arrCommodity = [AttributeModel]()
    var selectedCommodity: AttributeModel?
    
    let cargoModeDropDown = DropDown()
    var arrCargoModes = [String]()
    var selectedCargoMode: String?
    
    var arrCargoType = [AttributeModel]()
    var selectedCargoType: AttributeModel?
    
    var arrTransportMode = [AttributeModel]()
    var selectedTransportMode: AttributeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        self.callAPIs()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTfBookingDate(_ sender: UITextField) {
        self.bookingDatePickerType = .booking
        self.setDate(date: self.selecteBookingDate ?? Date())
        self.getPickedDate(sender)
    }
    @IBAction func onTfDnDPickUpDate(_ sender: UITextField) {
        self.bookingDatePickerType = .pickUp
        self.setDate(date: self.selecteBookingDate ?? self.selectePickUpDate ?? Date())
        self.getPickedDate(sender)
    }
    
    @IBAction func onBtnBookingType(_ sender: UIButton) {
        if self.arrBookingType.isEmpty{
            self.getBookingType(showDropDown: true)
            return
        }
        self.bookingTypeDropDown.show()
    }
    @IBAction func onBtnShippingLine(_ sender: UIButton) {
        if self.arrShippingLine.isEmpty{
            self.getShippingLine(showDropDown: true)
            return
        }
        self.shippingLineDropDown.show()
    }
    @IBAction func onBtnCargoMode(_ sender: UIButton) {
        if self.arrCargoType.isEmpty{
            self.getCargoMode(showDropDown: true)
            return
        }
        self.cargoModeDropDown.show()
    }
    @IBAction func onBtnCreateBooking(_ sender: UIButtonDeviceClass) {
        self.createBooking()
    }
}
//MARK:- Helper methods
extension LoadRequest{
    private func setData(){
        if let loadDetails = self.loadDetails{
            loadDetails.printJson()
            if let pickup = loadDetails["pickup"] as? [String:Any]{
                let city = pickup["city"] as? String ?? ""
                let address = pickup["address"] as? String ?? ""
                
                self.lblPickUpCity.text = city
                self.lblPickUpAddress.text = address
                
                self.tfPickUpDetailsCity.text = city
            }
            if let dropOff = loadDetails["dropOff"] as? [String:Any]{
                let city = dropOff["city"] as? String ?? ""
                let address = dropOff["address"] as? String ?? ""
                
                self.lblDropOffCity.text = city
                self.lblDropOffAddress.text = address
                
                self.tfDropOffDetailsCity.text = city
            }
            
            self.getCities()
            
            let name = "\(AppStateManager.sharedInstance.loggedInUser.user?.firstName ?? "") \(AppStateManager.sharedInstance.loggedInUser.user?.lastName ?? "")"
            self.tfBookingDetailsCustomerName.text = name
            
            let modeOfTransport = loadDetails["modeOfTransport"] as? String ?? ""
            switch modeOfTransport {
            case ModeOfTransportType.truck.rawValue:
                self.tfBookingDetailsModeOfTransport.text = Strings.BY_TRUCK.text
            default:
                self.tfBookingDetailsModeOfTransport.text = Strings.BY_TRAIN.text
            }
        }
    }
    private func callAPIs(){
        self.getRoutes()
        self.getBookingType(showDropDown: false)
        self.getShippingLine(showDropDown: false)
        self.getCommodity()
        self.getCargoMode(showDropDown: false)
        self.getCargoType()
        self.getTransportMode()
    }
    private func setSelectedCities(){
        let pickUpCity = self.tfPickUpDetailsCity.text ?? ""
        let dropOffCity = self.tfDropOffDetailsCity.text ?? ""
        
        self.selectedPickUpDetailsCity = self.arrCities.filter{$0.title == pickUpCity}.first
        self.selectedDropOffDetailsCity = self.arrCities.filter{$0.title == dropOffCity}.first
    }
    private func setSelectedRoute(){
        let pickUpCity = self.tfPickUpDetailsCity.text ?? ""
        if pickUpCity == Strings.KARACHI.text{
            self.selectedRoute = self.arrRoutes.filter{$0 == "up"}.first
        }
        else{
            self.selectedRoute = self.arrRoutes.filter{$0 == "down"}.first
        }
        self.tfBookingDetailsRoute.text = self.selectedRoute?.uppercased()
    }
    private func setBookingTypeDropDown(showDropDown: Bool){
        self.bookingTypeDropDown.dataSource = self.arrBookingType.map{$0.title ?? ""}
        self.bookingTypeDropDown.anchorView = self.tfBookingDetailsBookingType
        self.bookingTypeDropDown.cellHeight = self.tfBookingDetailsBookingType.frame.height
        self.bookingTypeDropDown.width = self.tfBookingDetailsBookingType.frame.width
        self.bookingTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfBookingDetailsBookingType.text = item
            self.selectedBookingType = self.arrBookingType[index]
        }
        if showDropDown{
            self.bookingTypeDropDown.show()
        }
    }
    private func setShippingLineDropDown(showDropDown: Bool){
        self.shippingLineDropDown.dataSource = self.arrShippingLine.map{$0.title ?? ""}
        self.shippingLineDropDown.anchorView = self.tfBookingDetailsShippingLine
        self.shippingLineDropDown.cellHeight = self.tfBookingDetailsShippingLine.frame.height
        self.shippingLineDropDown.width = self.tfBookingDetailsShippingLine.frame.width
        self.shippingLineDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfBookingDetailsShippingLine.text = item
            self.selectedShippingLine = self.arrShippingLine[index]
        }
        if showDropDown{
            self.shippingLineDropDown.show()
        }
    }
    private func setCargoModeDropDown(showDropDown: Bool){
        self.cargoModeDropDown.dataSource = self.arrCargoModes
        self.cargoModeDropDown.anchorView = self.tfBookingDetailsCargoMode
        self.cargoModeDropDown.cellHeight = self.tfBookingDetailsCargoMode.frame.height
        self.cargoModeDropDown.width = self.tfBookingDetailsBookingType.frame.width
        self.cargoModeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfBookingDetailsCargoMode.text = item
            self.selectedCargoMode = self.arrCargoModes[index]
        }
        if showDropDown{
            self.shippingLineDropDown.show()
        }
    }
    private func setSelectedCargoType(){
        if let loadDetails = self.loadDetails{
            let cargoTypeId = loadDetails["cargoTypeId"] as? String ?? ""
            
            self.selectedCargoType = self.arrCargoType.filter{$0.id == cargoTypeId}.first
            self.tfBookingDetailsCargoType.text = self.selectedCargoType?.title ?? ""
        }
    }
    private func setSelectedCommodity(){
        if let loadDetails = self.loadDetails{
            let commodityId = loadDetails["commodityId"] as? String ?? ""
            
            self.selectedCommodity = self.arrCommodity.filter{$0.id == commodityId}.first
            self.tfBookingDetailsCommodity.text = self.selectedCommodity?.title ?? ""
        }
    }
    private func setSelectedTransportMode(){
        let modeOfTransport = self.loadDetails?["modeOfTransport"] as? String ?? ""
        
        self.selectedTransportMode = self.arrTransportMode.filter{$0.title?.lowercased() == modeOfTransport}.first
    }
    private func validate()->[String:Any]?{
        if let loadDetails = self.loadDetails{
            
            var pickup = [String:Any]()
            
            if let pickupLoadDetails = loadDetails["pickup"] as? [String:Any]{
                let fullName = self.tfPickUpDetailsFullName.text ?? ""
                let phoneNumber = self.tfPickUpDetailsPhoneNumber.text ?? ""
                let origin = self.tfPickUpDetailsCity.text ?? ""
                let originName = self.tfPickUpDetailsPickUpName.text ?? ""
                let address = self.lblPickUpAddress.text ?? ""
                let labourers = self.tfPickUpDetailsLabourers.text ?? ""
                let cityId = self.selectedPickUpDetailsCity?.id ?? ""
                let coordinates = pickupLoadDetails["coordinates"] as? [Double] ?? [Double]()
                
                pickup["fullName"] = fullName
                pickup["phoneNumber"] = phoneNumber
                pickup["origin"] = origin
                pickup["originName"] = originName
                pickup["address"] = address
                pickup["labourers"] = labourers
                pickup["cityId"] = cityId
                pickup["coordinates"] = coordinates
            }
            
            var dropOff = [String:Any]()
            
            if let dropOffLoadDetails = loadDetails["dropOff"] as? [String:Any]{
                let fullName = self.tfDropOffDetailsFullName.text ?? ""
                let phoneNumber = self.tfDropOffDetailsPhoneNumber.text ?? ""
                let destination = self.tfDropOffDetailsCity.text ?? ""
                let destinationName = self.tfDropOffDetailsDropOffName.text ?? ""
                let address = self.lblDropOffAddress.text ?? ""
                let labourers = self.tfDropOffDetailsLabourers.text ?? ""
                let cityId = self.selectedDropOffDetailsCity?.id ?? ""
                let coordinates = dropOffLoadDetails["coordinates"] as? [Double] ?? [Double]()
                
                dropOff["fullName"] = fullName
                dropOff["phoneNumber"] = phoneNumber
                dropOff["destination"] = destination
                dropOff["destinationName"] = destinationName
                dropOff["address"] = address
                dropOff["labourers"] = labourers
                dropOff["cityId"] = cityId
                dropOff["coordinates"] = coordinates
            }
            
            var params = [String:Any]()
            
            let weight = loadDetails["weight"] as? Int ?? 0
            let sizeId = loadDetails["sizeId"] as? String ?? ""
            let commodityId =  loadDetails["commodityId"] as? String ?? ""
            let cargoTypeId = loadDetails["cargoTypeId"] as? String ?? ""
            let transportModeId = self.selectedTransportMode?.id ?? ""
            let route = self.selectedRoute ?? ""
            let bookingTypeId = self.selectedBookingType?.id ?? ""
            let quantityOfTrucks = loadDetails["quantityOfTrucks"] as? Int ?? 0
            let transitFreeDays = Int(self.tfBookingDetailsTransitFreeDays.text ?? "") ?? 0
            let pickUpDate = Utility.main.dateFormatter(date: self.selectePickUpDate ?? self.selecteBookingDate ?? Date(), dateFormat: "yyyy-MM-dd HH:mm:ss.SSS'Z'")
            let bookingDate = Utility.main.dateFormatter(date: self.selecteBookingDate ?? Date(), dateFormat: "yyyy-MM-dd HH:mm:ss.SSS'Z'")
            let shippingLine = self.selectedShippingLine?.id ?? ""
            
            let comments = "\(self.tfBookingDetailsRemarks.text ?? "")"
            if !comments.isEmpty{
                let remark:[String:Any] = ["comments":comments]
                let remarks = [remark]
                params["remarks"] = remarks
            }
            
            let totalDistance = loadDetails["totalDistance"] as? Int ?? 0
            let totalDuration = loadDetails["totalDuration"] as? String ?? ""
            let cargoMode = self.selectedCargoMode ?? ""
            
            params["pickup"] = pickup
            params["dropOff"] = dropOff
            params["weight"] = weight
            params["sizeId"] = sizeId
            params["commodityId"] = commodityId
            params["cargoTypeId"] = cargoTypeId
            params["transportModeId"] = transportModeId
            params["route"] = route
            params["bookingTypeId"] = bookingTypeId
            params["quantityOfTrucks"] = quantityOfTrucks
            params["transitFreeDays"] = transitFreeDays
            params["pickUpDate"] = pickUpDate
            params["bookingDate"] = bookingDate
            params["shippingLine"] = shippingLine
            params["totalDistance"] = totalDistance
            params["totalDuration"] = totalDuration
            params["cargoMode"] = cargoMode
            
            return params
        }
        else{
            return nil
        }
    }
}
//MARK:- Date Picker
extension LoadRequest{
    private func getPickedDate(_ sender: UITextField){
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        
        switch self.bookingDatePickerType{
        case .booking:
            datePickerView.minimumDate = Date()
            datePickerView.date = self.selecteBookingDate ?? Date()
        case .pickUp:
            datePickerView.minimumDate = self.selecteBookingDate ?? Date()
            datePickerView.date = self.selectePickUpDate ?? Date()
        }
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        self.setDate(date: sender.date)
    }
    private func setDate(date:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        switch self.bookingDatePickerType{
        case .booking:
            self.selecteBookingDate = date
            self.selectePickUpDate = nil
            
            self.tfBookingDetailsBookingDate.text = dateFormatter.string(from: date)
            self.tfBookingDetailsDnDPickUpDate.text = nil
        case .pickUp:
            self.selectePickUpDate = date
            
            self.tfBookingDetailsDnDPickUpDate.text = dateFormatter.string(from: date)
        }
    }
}
//MARK:- Services
extension LoadRequest{
    private func getCities(){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.City(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let cities = response["cities"] as? [[String:Any]] else {return}
            self.arrCities = Mapper<AttributeModel>().mapArray(JSONArray: cities)
            self.setSelectedCities()
        }) { (error) in
            print(error)
        }
    }
    private func getRoutes(){
        APIManager.sharedInstance.attributesAPIManager.Routes(success: { (responseObject) in
            guard let routes = responseObject as? [String] else {return}
            self.arrRoutes = routes
            self.setSelectedRoute()
        }) { (error) in
            print(error)
        }
    }
    private func getBookingType(showDropDown: Bool){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.BookingType(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let bookingTypes = response["bookingTypes"] as? [[String:Any]] else {return}
            self.arrBookingType = Mapper<AttributeModel>().mapArray(JSONArray: bookingTypes)
            self.setBookingTypeDropDown(showDropDown: showDropDown)
        }) { (error) in
            print(error)
        }
    }
    private func getShippingLine(showDropDown: Bool){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.ShippingLine(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let bookingTypes = response["shippingLines"] as? [[String:Any]] else {return}
            self.arrShippingLine = Mapper<ShippingLineModel>().mapArray(JSONArray: bookingTypes)
            self.setShippingLineDropDown(showDropDown: showDropDown)
        }) { (error) in
            print(error)
        }
    }
    private func getCommodity(){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.Commodity(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let commodities = response["commodities"] as? [[String:Any]] else {return}
            self.arrCommodity = Mapper<AttributeModel>().mapArray(JSONArray: commodities)
            self.setSelectedCommodity()
        }) { (error) in
            print(error)
        }
    }
    private func getCargoMode(showDropDown: Bool){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.CargoMode(params: params, success: { (responseObject) in
            guard let routes = responseObject as? [String] else {return}
            self.arrCargoModes = routes
            self.setCargoModeDropDown(showDropDown: showDropDown)
        }) { (error) in
            print(error)
        }
    }
    private func getCargoType(){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.CargoType(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let cargoTypes = response["cargoTypes"] as? [[String:Any]] else {return}
            self.arrCargoType = Mapper<AttributeModel>().mapArray(JSONArray: cargoTypes)
            self.setSelectedCargoType()
        }) { (error) in
            print(error)
        }
    }
    private func getTransportMode(){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.TransportMode(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let transportModes = response["transportModes"] as? [[String:Any]] else {return}
            self.arrTransportMode = Mapper<AttributeModel>().mapArray(JSONArray: transportModes)
            self.setSelectedTransportMode()
        }) { (error) in
            print(error)
        }
    }
    private func createBooking(){
        guard let params = self.validate() else {return}
        params.printJson()
        APIManager.sharedInstance.shipperAPIManager.Bookings(params: params, success: { (responseObject) in
            Utility.main.showAlert(message: Constants.apiMessage, title: Strings.CONFIRMATION.text) {
                AppDelegate.shared.changeRootViewController()
            }
        }) { (error) in
            print(error)
        }
    }
}
