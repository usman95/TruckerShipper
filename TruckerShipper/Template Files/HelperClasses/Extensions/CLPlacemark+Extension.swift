//
//  File.swift
//  Quick Delivery
//
//  Created by Mac Book on 31/07/2020.
//  Copyright © 2020 Quick Delivery. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
            if let street = thoroughfare {
                result += ", \(street)"
            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
