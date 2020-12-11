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
    
    var locationAttribute: [String:Any]?
    
    let sizePerTruckDropDown = DropDown()
    var arrSizePerTruck = [AttributeModel]()
    var selectedSizePerTruck: AttributeModel?
    
    let commodityDropDown = DropDown()
    var arrCommodity = [AttributeModel]()
    var selectedCommodity: AttributeModel?
    
    let cargoTypeDropDown = DropDown()
    var arrCargoType = [AttributeModel]()
    var selectedCargoType: AttributeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callAPIs()
        // Do any additional setup after loading the view.
    }

    @IBAction func onBtnSizerPerTruck(_ sender: UIButton) {
        self.sizePerTruckDropDown.show()
    }
    @IBAction func onBtnCommodity(_ sender: UIButton) {
        self.commodityDropDown.show()
    }
    @IBAction func onBtnCargoType(_ sender: UIButton) {
        self.cargoTypeDropDown.show()
    }
    @IBAction func onBtnCalculateRate(_ sender: UIButtonDeviceClass) {
        self.presentCalculatedRate()
    }
}
//MARK:- Helper methods
extension LoadDetails{
    private func callAPIs(){
        self.getSizePerTruck()
        self.getCommodity()
        self.getCargoType()
    }
    private func setSizePerTruckDropDown(){
        self.sizePerTruckDropDown.dataSource = self.arrSizePerTruck.map{$0.title ?? ""}
        self.sizePerTruckDropDown.anchorView = self.tfSizePerTruck
        self.sizePerTruckDropDown.cellHeight = self.tfSizePerTruck.frame.height
        self.sizePerTruckDropDown.width = self.tfSizePerTruck.frame.width
        self.sizePerTruckDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfSizePerTruck.text = item
            self.selectedSizePerTruck = self.arrSizePerTruck[index]
        }
    }
    private func setCommodityDropDown(){
        self.commodityDropDown.dataSource = self.arrCommodity.map{$0.title ?? ""}
        self.commodityDropDown.anchorView = self.tfCommodity
        self.commodityDropDown.cellHeight = self.tfCommodity.frame.height
        self.commodityDropDown.width = self.tfCommodity.frame.width
        self.commodityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfCommodity.text = item
            self.selectedCommodity = self.arrCommodity[index]
        }
    }
    private func setCargoTypeDropDown(){
        self.cargoTypeDropDown.dataSource = self.arrCargoType.map{$0.title ?? ""}
        self.cargoTypeDropDown.anchorView = self.tfCargoType
        self.cargoTypeDropDown.cellHeight = self.tfCargoType.frame.height
        self.cargoTypeDropDown.width = self.tfCargoType.frame.width
        self.cargoTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfCargoType.text = item
            self.selectedCargoType = self.arrCargoType[index]
        }
    }
    private func validate()->[String:Any]?{
        
        return nil
    }
    private func presentCalculatedRate(){
        let controller = CalculatedRate()
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true, completion: nil)
        
        controller.setSelectedPrice = { selectedPrice in
            super.pushToLoadRequest()
        }
    }
}
//MARK:- Services
extension LoadDetails{
    private func getSizePerTruck(){
        let skip = "0"
        let limit = "1000"

        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.Size(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let sizes = response["sizes"] as? [[String:Any]] else {return}
            self.arrSizePerTruck = Mapper<AttributeModel>().mapArray(JSONArray: sizes)
            self.setSizePerTruckDropDown()
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
            self.setCommodityDropDown()
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
            self.setCargoTypeDropDown()
        }) { (error) in
            print(error)
        }
    }
}
