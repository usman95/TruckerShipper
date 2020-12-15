//
//  TripHeader.swift
//  TruckerShipper
//
//  Created by Mac Book on 15/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class TripHeader: UIView {

   class func instanceFromNib() -> UIView{
        return UINib(nibName: "TripHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
