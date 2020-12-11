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
    @IBOutlet weak var tfPickUpDetailsPickUp: UITextFieldDeviceClass!
    @IBOutlet weak var tfPickUpDetailsPickUpName: UITextFieldDeviceClass!
    @IBOutlet weak var tfPickUpDetailsLabourers: UITextFieldDeviceClass!
    
    @IBOutlet weak var tfDropOffDetailsFullName: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsPhoneNumber: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsCity: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsDropOff: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsDropOffName: UITextFieldDeviceClass!
    @IBOutlet weak var tfDropOffDetailsLabourers: UITextFieldDeviceClass!
    
    @IBOutlet weak var tfBookingDetailsCustomerName: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsBookingDate: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsRoute: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsModeOfTransport: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsTransitFreeDays: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsDnDPickUpDate: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsBookingType: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsCargoType: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsShippingLine: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsCommodity: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsPortOfLoading: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsPortOfDischarge: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsEmptyPickUpLocation: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsEmptyReturnLocation: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsRemarks: UITextFieldDeviceClass!
    
    @IBOutlet weak var viewPortOfLoading: UIView!
    @IBOutlet weak var viewPortOfDischarge: UIView!
    
    var loadDetails: [String:Any]?
    
    var arrCities = [AttributeModel]()
    
    var selectedPickUpDetailsCity: AttributeModel?
    var selectedDropOffDetailsDetailsCity: AttributeModel?
    
    var bookingDatePickerType = BookingDatePickerType.booking
    var selecteBookingDate: Date?
    var selectePickUpDate: Date?
    
    let routesDropDown = DropDown()
    var arrRoutes = [String]()
    var selectedRoute: String?
    
    let bookingTypeDropDown = DropDown()
    var arrBookingType = [AttributeModel]()
    var selectedBookingType: AttributeModel?
    
    let shippingLineDropDown = DropDown()
    var arrShippingLine = [AttributeModel]()
    var selectedShippingLine: AttributeModel?
    
    var arrCommodity = [AttributeModel]()
    var selectedCommodity: AttributeModel?
    
    var arrCargoType = [AttributeModel]()
    var selectedCargoType: AttributeModel?
    
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
    
    @IBAction func onBtnRoute(_ sender: UIButton) {
        self.routesDropDown.show()
    }
    @IBAction func onBtnBookingType(_ sender: UIButton) {
        self.bookingTypeDropDown.show()
    }
    @IBAction func onBtnShippingLine(_ sender: UIButton) {
        self.shippingLineDropDown.show()
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
                
                self.viewPortOfLoading.isHidden = true
                self.viewPortOfDischarge.isHidden = true
            default:
                self.tfBookingDetailsModeOfTransport.text = Strings.BY_TRAIN.text
            }
        }
    }
    private func callAPIs(){
        self.getRoutes()
        self.getBookingType()
        self.getShippingLine()
        self.getCommodity()
        self.getCargoType()
    }
    private func setSelectedCities(){
        let pickUpCity = self.tfPickUpDetailsCity.text ?? ""
        let dropOffCity = self.tfDropOffDetailsCity.text ?? ""
        
        self.selectedPickUpDetailsCity = self.arrCities.filter{$0.title == pickUpCity}.first
        self.selectedDropOffDetailsDetailsCity = self.arrCities.filter{$0.title == dropOffCity}.first
    }
    private func setRoutesDropDown(){
        self.routesDropDown.dataSource = self.arrRoutes
        self.routesDropDown.anchorView = self.tfBookingDetailsRoute
        self.routesDropDown.cellHeight = self.tfBookingDetailsRoute.frame.height
        self.routesDropDown.width = self.tfBookingDetailsRoute.frame.width
        self.routesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfBookingDetailsRoute.text = item.uppercased()
            self.selectedRoute = item
        }
    }
    private func setBookingTypeDropDown(){
        self.bookingTypeDropDown.dataSource = self.arrBookingType.map{$0.title ?? ""}
        self.bookingTypeDropDown.anchorView = self.tfBookingDetailsBookingType
        self.bookingTypeDropDown.cellHeight = self.tfBookingDetailsBookingType.frame.height
        self.bookingTypeDropDown.width = self.tfBookingDetailsBookingType.frame.width
        self.bookingTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfBookingDetailsBookingType.text = item
            self.selectedBookingType = self.arrBookingType[index]
        }
    }
    private func setShippingLineDropDown(){
        self.shippingLineDropDown.dataSource = self.arrShippingLine.map{$0.title ?? ""}
        self.shippingLineDropDown.anchorView = self.tfBookingDetailsShippingLine
        self.shippingLineDropDown.cellHeight = self.tfBookingDetailsShippingLine.frame.height
        self.shippingLineDropDown.width = self.tfBookingDetailsShippingLine.frame.width
        self.shippingLineDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfBookingDetailsShippingLine.text = item
            self.selectedShippingLine = self.arrShippingLine[index]
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
        APIManager.sharedInstance.usersAPIManager.Routes(success: { (responseObject) in
            guard let routes = responseObject as? [String] else {return}
            self.arrRoutes = routes
            self.setRoutesDropDown()
        }) { (error) in
            print(error)
        }
    }
    private func getBookingType(){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.BookingType(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let bookingTypes = response["bookingTypes"] as? [[String:Any]] else {return}
            self.arrBookingType = Mapper<AttributeModel>().mapArray(JSONArray: bookingTypes)
            self.setBookingTypeDropDown()
        }) { (error) in
            print(error)
        }
    }
    private func getShippingLine(){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.ShippingLine(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let bookingTypes = response["shippingLines"] as? [[String:Any]] else {return}
            self.arrShippingLine = Mapper<AttributeModel>().mapArray(JSONArray: bookingTypes)
            self.setShippingLineDropDown()
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
}
