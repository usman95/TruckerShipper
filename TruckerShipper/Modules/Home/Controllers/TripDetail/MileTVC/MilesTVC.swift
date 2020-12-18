//
//  MilesTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class MilesTVC: UITableViewCell {
    
    let pendingMileColor = UIColor(red:194/255, green:193/255, blue:193/255, alpha:1.0)
    let inProgressMileColor = UIColor(red:0/255, green:70/255, blue:158/255, alpha:1.0)
    let completedMileColor = UIColor(red:63/255, green:183/255, blue:115/255, alpha:1.0)
    
    @IBOutlet weak var viewCurrentMileRadioStroke: RoundedView!
    @IBOutlet weak var viewCurrentMileRadioFill: RoundedView!
    @IBOutlet weak var lblMile: UILabelDeviceClass!
    
    func setData(data: TripMilesModel?){
        self.lblMile.text = data?.dropOffAddress ?? ""
        
        switch (data?.status ?? "") {
        case MileType.pending.rawValue:
            self.lblMile.textColor = self.pendingMileColor
            self.viewCurrentMileRadioStroke.borderColor = self.pendingMileColor
            self.viewCurrentMileRadioFill.backgroundColor = self.pendingMileColor
        case MileType.inProgress.rawValue:
            self.lblMile.textColor = self.inProgressMileColor
            self.viewCurrentMileRadioStroke.borderColor = self.inProgressMileColor
            self.viewCurrentMileRadioFill.backgroundColor = self.inProgressMileColor
        case MileType.completed.rawValue:
            self.lblMile.textColor = self.completedMileColor
            self.viewCurrentMileRadioStroke.borderColor = self.completedMileColor
            self.viewCurrentMileRadioFill.backgroundColor = self.completedMileColor
        default:
            break
        }
    }
}
