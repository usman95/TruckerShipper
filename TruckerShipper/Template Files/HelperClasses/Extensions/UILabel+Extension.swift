//
//  UILabel+Extension.swift
//  Quick Delivery
//
//  Created by Shakeel Khan on 8/8/20.
//  Copyright © 2020 Quick Delivery. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func strikeThrough() {
        if let lblText = self.text {
            let attributeString =  NSMutableAttributedString(string: lblText)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: Global.APP_COLOR, range: NSMakeRange(0,attributeString.length))
            self.attributedText = attributeString
        }
    }
}
