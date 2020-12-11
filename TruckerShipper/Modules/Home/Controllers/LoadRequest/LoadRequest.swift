//
//  LoadRequest.swift
//  TruckerShipper
//
//  Created by Mac Book on 11/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class LoadRequest: BaseController {

    @IBOutlet weak var lblPickUpCity: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffCity: UILabelDeviceClass!
    @IBOutlet weak var lblPickUpAddress: UILabelDeviceClass!
    @IBOutlet weak var lblDropOffAddress: UILabelDeviceClass!
    
    var loadDetails: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper methods
extension LoadRequest{
    private func setData(){
        
        
    }
}
/*
 {
   "dropOff" : {
     "coordinates" : [
       33.5989881,
       73.136052699999993
     ],
     "address" : "Islamabad Expressway, Islamabad, Islamabad Capital Territory, Pakistan"
   },
   "cargoTypeId" : "5fa6c903127fd23dac552b7e",
   "quantityOfTrucks" : "12",
   "weightId" : "5fcad82e1fda40cde8b098bd",
   "commodityId" : "5fa6c903127fd23dac552b7e",
   "pickup" : {
     "coordinates" : [
       24.860734300000001,
       67.001136399999993
     ],
     "address" : "Karachi, Karachi City, Sindh, Pakistan"
   },
   "sizeId" : "5fa6c903127fd23dac552be2"
 }
*/
