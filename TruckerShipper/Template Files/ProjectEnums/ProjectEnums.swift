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
enum ShipperType: String{
    case WalkIn = "Walk-In"
    case Contractual = "Contractual"
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
enum BookingType: String{
    case pending = "pending"
    case inProgress = "in-progress"//"accepted"
    case completed = "completed"//"rejected","cancelled"
    case rejected = "rejected"
}
enum MileType: String{
    case pending = "pending"
    case inProgress = "in-progress"
    case completed = "completed"
}
enum ImagePickerType{
    case profile
    case ntn
}
