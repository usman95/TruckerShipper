//
//  ProjectEnums.swift
//  Quick Delivery
//
//  Created by macbook on 16/07/2019.
//  Copyright © 2019 Seller. All rights reserved.
//

import Foundation

enum LocalizationType: String{
    case EN = "en"
    case UR = "ur"
}
enum RoleType: String{
    case Shipper = "Shipper"
}
enum LocationPickerType{
    case pickUp
    case dropOff
}
enum ModeOfTransportType: String{
    case truck = "truck"
    case train = "train"
}
enum BookingDatePickerType{
    case booking
    case pickUp
}
