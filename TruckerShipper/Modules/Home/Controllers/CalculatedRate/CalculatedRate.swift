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
    
    var priceEstimates: PriceEstimates?
    var setSelectedPrice: ((ModeOfTransportType,String?)->Void)?
    var selectedModeOfTransport = ModeOfTransportType.truck
    var selectedPrice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
    }
    
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
            self.setSelectedPrice?(self.selectedModeOfTransport,self.selectedPrice)
        }
    }
}
//MARK:- Helper method
extension CalculatedRate{
    private func setData(){
        guard let data = self.priceEstimates else {return}
        self.selectedPrice = "\(data.truck)"
        
        self.lblByTruck.text = "\(Constants.localCurrency) \(data.truck.withCommas()) \(Strings.PER_TRUCK.text)"
        self.lblByTrain.text = "\(Constants.localCurrency) \(data.train.withCommas()) \(Strings.PER_CONTAINER.text)"
    }
    private func setViewByTruck(){
        self.viewByTruck.borderColor = Global.APP_COLOR
        self.viewByTrain.borderColor = Global.APP_COLOR_DARK_GREY
        
        self.viewByTruck.borderWidth = 2.0
        self.viewByTrain.borderWidth = 1.0
        
        self.lblByTruck.textColor = Global.APP_COLOR
        self.lblByTrain.textColor = Global.APP_COLOR_DARK_GREY
        
        guard let data = self.priceEstimates else {return}
        self.selectedPrice = "\(data.truck)"
        self.selectedModeOfTransport = .truck
    }
    private func setViewByTrain(){
        self.viewByTruck.borderColor = Global.APP_COLOR_DARK_GREY
        self.viewByTrain.borderColor = Global.APP_COLOR
        
        self.viewByTruck.borderWidth = 1.0
        self.viewByTrain.borderWidth = 2.0
        
        self.lblByTruck.textColor = Global.APP_COLOR_DARK_GREY
        self.lblByTrain.textColor = Global.APP_COLOR
        
        guard let data = self.priceEstimates else {return}
        self.selectedPrice = "\(data.train)"
        self.selectedModeOfTransport = .train
    }
}
