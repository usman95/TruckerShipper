//
//  SearchCommodityTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 24/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class SearchCommodityTVC: UITableViewCell {

    @IBOutlet weak var lblCommodity: UILabelDeviceClass!
    
    func setData(data: AttributeModel?){
        self.lblCommodity.text = data?.title ?? ""
    }
    
}
