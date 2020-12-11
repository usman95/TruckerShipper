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
    @IBOutlet weak var tfBookingDetailsEmptyDropOffLocation: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsBookingDate: UITextFieldDeviceClass!
    @IBOutlet weak var tfBookingDetailsRemarks: UITextFieldDeviceClass!
    
    var loadDetails: [String:Any]?
    
    var arrCities = [AttributeModel]()
    
    var selectedPickUpDetailsCity: AttributeModel?
    var selectedDropOffDetailsDetailsCity: AttributeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        // Do any additional setup after loading the view.
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
        }
    }
    private func callAPIs(){
        self.getCities()
    }
    private func setSelectedCities(){
        let pickUpCity = self.tfPickUpDetailsCity.text ?? ""
        let dropOffCity = self.tfDropOffDetailsCity.text ?? ""
        
        self.selectedPickUpDetailsCity = self.arrCities.filter{$0.title == pickUpCity}.first
        self.selectedDropOffDetailsDetailsCity = self.arrCities.filter{$0.title == dropOffCity}.first
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
}
