//
//  TripExpensesHeader.swift
//  TruckerDriver
//
//  Created by Mac Book on 16/11/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit

class TripExpensesHeader: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TripExpensesHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
