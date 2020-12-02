//
//  CustomLocale.swift
//  Template
//
//  Created by Usman Bin Rehan on 10/31/17.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//

import Foundation
class CustomLocale: NSObject {
    var name:String?
    var languageCode:String?
    var countryCode:String?
    
    init(languageCode: String,countryCode:String,name: String) {
        
        self.name = name
        self.languageCode = languageCode
        self.countryCode = countryCode
    }
    
}
