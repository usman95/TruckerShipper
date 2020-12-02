//
//  Dictionary+Extension.swift
//  Quick Delivery
//
//  Created by macbook on 14/07/2019.
//  Copyright © 2019 Seller. All rights reserved.
//

import Foundation

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    func printJson() {
        print(json)
    }
}
