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

    @IBOutlet weak var tfWeightPerTruck: UITextFieldDeviceClass!
    @IBOutlet weak var tfSizePerTruck: UITextFieldDeviceClass!
    @IBOutlet weak var tfCommodity: UITextFieldDeviceClass!
    @IBOutlet weak var tfCargoType: UITextFieldDeviceClass!
    @IBOutlet weak var tfQuantity: UITextFieldDeviceClass!
    @IBOutlet weak var btnCalculateRate: UIButtonDeviceClass!
    
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
        self.callAPIs()
        // Do any additional setup after loading the view.
    }

    @IBAction func onBtnSizerPerTruck(_ sender: UIButton) {
        self.sizePerTruckDropDown.show()
    }
    @IBAction func onBtnCommodity(_ sender: UIButton) {
        let controller = SearchCommodity()
        controller.arrCommodity = self.arrCommodity
        self.navigationController?.pushViewController(controller, animated: true)
        
        controller.setSelectedCommodity = { commodity in
            self.selectedCommodity = commodity
            self.tfCommodity.text = commodity?.title ?? ""
        }
    }
    @IBAction func onBtnCargoType(_ sender: UIButton) {
        self.cargoTypeDropDown.show()
    }
    @IBAction func onBtnCalculateRate(_ sender: UIButtonDeviceClass) {
        self.getBookingEstimate()
    }
}
//MARK:- Helper methods
extension LoadDetails{
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
        }
        if showDropDown{
            self.cargoTypeDropDown.show()
        }
    }
    private func presentCalculatedRate(priceEstimates: PriceEstimates?){
        let controller = CalculatedRate()
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
        let weight = self.tfWeightPerTruck.text ?? ""
        let sizeId = self.selectedSizePerTruck?.id ?? ""
        let commodityId = self.selectedCommodity?.id ?? ""
        let cargoTypeId = self.selectedCargoType?.id ?? ""
        let quantityOfTrucks = self.tfQuantity.text ?? ""
        
        if !Validation.isValidNumber(weight){
            Utility.main.showToast(message: Strings.PLEASE_ENTER_WEIGHT_PER_TRUCK.text)
            self.btnCalculateRate.shake()
            return nil
        }
        if self.selectedSizePerTruck == nil{
            Utility.main.showToast(message: Strings.PLEASE_SELECT_SIZE_PER_TRUCK.text)
            self.btnCalculateRate.shake()
            return nil
        }
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
        if !Validation.isValidNumber(quantityOfTrucks){
            Utility.main.showToast(message: Strings.PLEASE_ENTER_QUANTITY.text)
            self.btnCalculateRate.shake()
            return nil
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
