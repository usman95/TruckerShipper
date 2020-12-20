//
//  MyContractsTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 09/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class MyContractsTVC: UITableViewCell {

    @IBOutlet weak var lblDistanceInKM: UILabelDeviceClass!
    @IBOutlet weak var lblAmount: UILabelDeviceClass!
    @IBOutlet weak var lblStartDate: UILabelDeviceClass!
    @IBOutlet weak var lblEndDate: UILabelDeviceClass!
    @IBOutlet weak var lblPickUp: UILabelDeviceClass!
    @IBOutlet weak var lblDropOff: UILabelDeviceClass!
    @IBOutlet weak var imgModeOfTransport: UIImageView!
    
    func setData(data: ContractModel){
        self.lblDistanceInKM.text = "\(data.totalDistance) \(Strings.KM.text)"
        self.lblAmount.text = "\(Strings.PKR.text) : \((data.charges?.amount ?? 0).withCommas())"
        
        let contractStartDateString = data.contractStartDate ?? "2020-12-14T14:24:59.741Z"
        let contractStartDate = Utility.main.stringDateFormatter(dateStr: contractStartDateString, dateFormat: Constants.serverDateFormat, formatteddate: "d MMM yy")
        self.lblStartDate.text = contractStartDate
        
        let contractEndDateString = data.contractEndDate ?? "2020-12-14T14:24:59.741Z"
        let contractEndDate = Utility.main.stringDateFormatter(dateStr: contractEndDateString, dateFormat: Constants.serverDateFormat, formatteddate: "d MMM yy")
        self.lblEndDate.text = contractEndDate
        
        self.lblPickUp.text = data.pickup?.address ?? "-"
        self.lblDropOff.text = data.dropOff?.address ?? "-"
        
        let modeOfTransport = (data.transportModeId?.title ?? "").lowercased()
        switch modeOfTransport{
        case ModeOfTransportType.truck.rawValue:
            self.imgModeOfTransport.image = UIImage(named: "TruckContract")
        case ModeOfTransportType.train.rawValue:
            self.imgModeOfTransport.image = UIImage(named: "ContainerContract")
        default:
            break
        }
    }
    
}
