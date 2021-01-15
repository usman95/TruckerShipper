//
//  LoadDetails.swift
//  TruckerShipper
//
//  Created by Mac Book on 11/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class LoadDetails: BaseController {

    @IBOutlet weak var lblPickUpTitle: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffTitle: UILabelDeviceClass!
    @IBOutlet weak var lblPickUp: UILabelDeviceClass!
    @IBOutlet weak var lblDropOff: UILabelDeviceClass!
    @IBOutlet weak var lblKilometers: UILabelDeviceClass!
    @IBOutlet weak var lblTimeDuration: UILabelDeviceClass!
    
    @IBOutlet weak var tfWeightPerTruck: UITextFieldDeviceClass!
    @IBOutlet weak var tfSizePerTruck: UITextFieldDeviceClass!
    @IBOutlet weak var tfCommodity: UITextFieldDeviceClass!
    @IBOutlet weak var tfCargoType: UITextFieldDeviceClass!
    @IBOutlet weak var tfQuantity: UITextFieldDeviceClass!
    @IBOutlet weak var btnCalculateRate: UIButtonDeviceClass!
    
    @IBOutlet weak var lblCargoItemRateId: UILabelDeviceClass!
    
    @IBOutlet weak var viewCargoType: UIView!
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var viewQuantityOfContainer: UIView!
    
    var locationAttribute: [String:Any]?
    
    let sizePerTruckDropDown = DropDown()
    var arrSizePerTruck = [AttributeModel]()
    var selectedSizePerTruck: AttributeModel?
    
    var arrCommodity = [AttributeModel]()
    var selectedCommodity: AttributeModel?
    
    let cargoTypeDropDown = DropDown()
    var arrCargoType = [AttributeModel]()
    var selectedCargoType: AttributeModel?
    
    var estimateParams:[String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        self.callAPIs()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnCommodity(_ sender: UIButton) {
        let controller = SearchCommodity()
        controller.arrCommodity = self.arrCommodity
        self.navigationController?.pushViewController(controller, animated: true)
        
        controller.setSelectedCommodity = { commodity in
            self.selectedCommodity = commodity
            self.tfCommodity.text = commodity?.title ?? ""
            
            switch (self.selectedCommodity?.rateId?.type ?? ""){
            case CargoItemRateTypes.ton.rawValue:
                self.lblCargoItemRateId.text = Strings.TON.text
                self.tfWeightPerTruck.placeholder = Strings.WEIGHT_PER_TRANSPORT_UNIT.text
            case CargoItemRateTypes.bag.rawValue:
                self.lblCargoItemRateId.text = Strings.BAG.text
                self.tfWeightPerTruck.placeholder = Strings.QUANTITY_PER_TRANSPORT_UNIT.text
            default:
                break
            }
        }
    }
    @IBAction func onBtnCargoType(_ sender: UIButton) {
        self.cargoTypeDropDown.show()
    }
    @IBAction func onBtnSizerPerTruck(_ sender: UIButton) {
        self.setSizePerTruckDropDown(showDropDown: true)
    }
    @IBAction func onBtnCalculateRate(_ sender: UIButtonDeviceClass) {
        self.getBookingEstimate()
    }
}
//MARK:- Helper methods
extension LoadDetails{
    private func setData(){
        guard let data = self.locationAttribute else {return}
        guard let pickUp = data["pickup"] as? [String:Any] else {return}
        guard let dropOff = data["dropOff"] as? [String:Any] else {return}
        
        self.lblPickUpTitle.text = pickUp["city"] as? String ?? ""
        self.lblDropOffTitle.text = dropOff["city"] as? String ?? ""
        self.lblPickUp.text = pickUp["address"] as? String ?? ""
        self.lblDropOff.text = dropOff["address"] as? String ?? ""
        self.lblKilometers.text = "\(data["totalDistance"] as? Int ?? 0)"
        self.lblTimeDuration.text = data["totalDuration"] as? String ?? ""
    }
    private func callAPIs(){
        self.getSizePerTruck(showDropDown: false)
        self.getCommodity()
        self.getCargoType(showDropDown: false)
    }
    private func setSizePerTruckDropDown(showDropDown: Bool){
        self.sizePerTruckDropDown.dataSource = self.arrSizePerTruck.map{$0.title ?? ""}
        self.sizePerTruckDropDown.anchorView = self.tfSizePerTruck
        self.sizePerTruckDropDown.cellHeight = self.tfSizePerTruck.frame.height
        self.sizePerTruckDropDown.width = self.tfSizePerTruck.frame.width
        self.sizePerTruckDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfSizePerTruck.text = item
            self.selectedSizePerTruck = self.arrSizePerTruck[index]
        }
        if showDropDown{
            self.sizePerTruckDropDown.show()
        }
    }
    private func setCargoTypeDropDown(showDropDown: Bool){
        self.cargoTypeDropDown.dataSource = self.arrCargoType.map{$0.title ?? ""}
        self.cargoTypeDropDown.anchorView = self.tfCargoType
        self.cargoTypeDropDown.cellHeight = self.tfCargoType.frame.height
        self.cargoTypeDropDown.width = self.tfCargoType.frame.width
        self.cargoTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfCargoType.text = item
            self.selectedCargoType = self.arrCargoType[index]
            
            switch (self.selectedCargoType?.title ?? "").lowercased(){
            case CargoTypes.containerized.rawValue:
                self.viewSize.isHidden = false
                self.viewQuantityOfContainer.isHidden = false
                
                self.tfQuantity.placeholder = Strings.TOTAL_QUANTITY_PER_CONTAINER.text
            case CargoTypes.nonContainerized.rawValue:
                self.viewSize.isHidden = true
                self.viewQuantityOfContainer.isHidden = true
                
                self.tfQuantity.placeholder = Strings.TOTAL_QUANTITY.text
            default:
                break
            }
        }
        if showDropDown{
            self.cargoTypeDropDown.show()
        }
    }
    private func presentCalculatedRate(priceEstimates: PriceEstimates?){
        
        guard let data = priceEstimates else {return}
        if data.truck == 0 && data.train == 0 {
            Utility.main.showToast(message: Strings.CANT_NOT_ESTIMATE_A_PRICE_PLEASE_CONTACT_SUPPORT.text)
            return
        }
        
        let controller = CalculatedRate()
        controller.selectedCargoType = self.selectedCargoType
        controller.priceEstimates = priceEstimates
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true, completion: nil)
        
        controller.setSelectedPrice = { (modeOfTransport,selectedPrice) in
            
            var loadDetails = self.estimateParams ?? [:]
            loadDetails["modeOfTransport"] = modeOfTransport.rawValue
            loadDetails["selectedPrice"] = selectedPrice
            super.pushToLoadRequest(loadDetails: loadDetails, selectedContract: nil)
        }
    }
    private func validate()->[String:Any]?{
        let commodityId = self.selectedCommodity?.id ?? ""
        let weight = self.tfWeightPerTruck.text ?? ""
        let sizeId = self.selectedSizePerTruck?.id ?? ""
        let cargoTypeId = self.selectedCargoType?.id ?? ""
        let quantityOfTrucks = self.tfQuantity.text ?? ""
        
        if self.selectedCommodity == nil{
            Utility.main.showToast(message: Strings.PLEASE_SELECT_COMMODITY.text)
            self.btnCalculateRate.shake()
            return nil
        }
        if self.selectedCargoType == nil{
            Utility.main.showToast(message: Strings.PLEASE_SELECT_CARGO_TYPE.text)
            self.btnCalculateRate.shake()
            return nil
        }
        if self.selectedCargoType?.title == CargoTypes.containerized.rawValue{
            if self.selectedSizePerTruck == nil{
                Utility.main.showToast(message: Strings.PLEASE_SELECT_SIZE_PER_TRUCK.text)
                self.btnCalculateRate.shake()
                return nil
            }
        }
        if !Validation.isValidNumber(weight){
            switch (self.selectedCargoType?.title ?? "").lowercased(){
            case CargoTypes.containerized.rawValue:
                Utility.main.showToast(message: Strings.PLEASE_ENTER_WEIGHT_PER_TRUCK.text)
            case CargoTypes.nonContainerized.rawValue:
                Utility.main.showToast(message: Strings.PLEASE_ENTER_QUANTITY_PER_TRUCK.text)
            default:
                break
            }
            
            self.btnCalculateRate.shake()
            return nil
        }
        if self.selectedCargoType?.title == CargoTypes.containerized.rawValue{
            if !Validation.isValidNumber(quantityOfTrucks){
                Utility.main.showToast(message: Strings.PLEASE_ENTER_QUANTITY.text)
                self.btnCalculateRate.shake()
                return nil
            }
        }
        
        var params = self.locationAttribute ?? [:]
        
        params["weight"] = Int(weight) ?? 0
        params["sizeId"] = sizeId
        params["commodityId"] = commodityId
        params["cargoTypeId"] = cargoTypeId
        params["quantityOfTrucks"] = Int(quantityOfTrucks) ?? 0

        return params
    }
}
//MARK:- Services
extension LoadDetails{
    private func getSizePerTruck(showDropDown: Bool){
        let skip = "0"
        let limit = "1000"

        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.Size(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let sizes = response["sizes"] as? [[String:Any]] else {return}
            self.arrSizePerTruck = Mapper<AttributeModel>().mapArray(JSONArray: sizes)
            self.setSizePerTruckDropDown(showDropDown: showDropDown)
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

        }) { (error) in
            print(error)
        }
    }
    private func getCargoType(showDropDown: Bool){
        let skip = "0"
        let limit = "1000"

        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.CargoType(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let cargoTypes = response["cargoTypes"] as? [[String:Any]] else {return}
            self.arrCargoType = Mapper<AttributeModel>().mapArray(JSONArray: cargoTypes)
            self.setCargoTypeDropDown(showDropDown: showDropDown)
        }) { (error) in
            print(error)
        }
    }
    private func getBookingEstimate(){
        guard let params = self.validate() else {return}
        self.estimateParams = params
        
        APIManager.sharedInstance.shipperAPIManager.BookingEstimate(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            
            let truckPrice = response["truckPrice"] as? Int ?? 0
            let trainPrice = response["trainPrice"] as? Int ?? 0
            
            let priceEstimates = PriceEstimates(truck: truckPrice, train: trainPrice)
            self.presentCalculatedRate(priceEstimates: priceEstimates)
        }) { (error) in
            print(error)
        }
    }
}
