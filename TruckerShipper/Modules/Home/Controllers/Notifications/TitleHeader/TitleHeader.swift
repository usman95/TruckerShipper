//
//  TitleHeader.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class TitleHeader: UIView {

    @IBOutlet weak var lblTitle: UILabelDeviceClass!
    
    class func instanceFromNib() -> UIView{
        return UINib(nibName: "TitleHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
