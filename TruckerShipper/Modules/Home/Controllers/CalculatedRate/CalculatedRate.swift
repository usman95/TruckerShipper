//
//  CalculatedRate.swift
//  TruckerShipper
//
//  Created by Mac Book on 11/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class CalculatedRate: BaseController {

    @IBOutlet weak var viewByTruck: UIView!
    @IBOutlet weak var viewByTrain: UIView!
    @IBOutlet weak var lblByTruck: UILabel!
    @IBOutlet weak var lblByTrain: UILabel!
    
    var setSelectedPrice: ((String?)->Void)?
    var selectedPrice: String?
    
    @IBAction func onBtnByTruckOrTrain(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.setViewByTruck()
        default:
            self.setViewByTrain()
        }
    }
    @IBAction func onBtnDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onBtnContinue(_ sender: UIButtonDeviceClass) {
        self.dismiss(animated: true) {
            self.setSelectedPrice?(self.selectedPrice)
        }
    }
}
//MARK:- Helper method
extension CalculatedRate{
    private func setViewByTruck(){
        self.viewByTruck.borderColor = Global.APP_COLOR
        self.viewByTrain.borderColor = Global.APP_COLOR_DARK_GREY
        
        self.viewByTruck.borderWidth = 2.0
        self.viewByTrain.borderWidth = 1.0
        
        self.lblByTruck.textColor = Global.APP_COLOR
        self.lblByTrain.textColor = Global.APP_COLOR_DARK_GREY
    }
    private func setViewByTrain(){
        self.viewByTruck.borderColor = Global.APP_COLOR_DARK_GREY
        self.viewByTrain.borderColor = Global.APP_COLOR
        
        self.viewByTruck.borderWidth = 1.0
        self.viewByTrain.borderWidth = 2.0
        
        self.lblByTruck.textColor = Global.APP_COLOR_DARK_GREY
        self.lblByTrain.textColor = Global.APP_COLOR
    }
}
