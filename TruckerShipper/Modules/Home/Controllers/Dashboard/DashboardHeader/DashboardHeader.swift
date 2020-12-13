//
//  DashboardHeader.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class DashboardHeader: UIView {

    class func instanceFromNib() -> UIView{
        return UINib(nibName: "DashboardHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
