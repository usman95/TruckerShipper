//
//  ButtonStates.swift
//  Tobdon
//
//  Created by Usman Bin Rehan on 2/18/19.
//  Copyright © 2019 Usman Bin Rehan. All rights reserved.
//

import Foundation
import UIKit

class RedGrayButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        if self.isSelected{
            self.setTitleColor(.white, for: .selected)
            self.backgroundColor = Global.APP_COLOR
        }
        else{
            self.setTitleColor(.darkGray, for: .normal)
            self.backgroundColor = .clear
        }
    }
}
class RedGrayButtonLeft: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.height
        let radius = CGFloat(height / 2.0)
        roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        self.clipsToBounds = true
        if self.isSelected{
            self.setTitleColor(.white, for: .selected)
            self.backgroundColor = Global.APP_COLOR
        }
        else{
            self.setTitleColor(.darkGray, for: .normal)
            self.backgroundColor = .clear
        }
    }
}
class RedGrayButtonRight: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.height
        let radius = CGFloat(height / 2.0)
        roundCorners(corners: [.topRight,.bottomRight], radius: radius)
        self.clipsToBounds = true
        if self.isSelected{
            self.setTitleColor(.white, for: .selected)
            self.backgroundColor = Global.APP_COLOR
        }
        else{
            self.setTitleColor(.darkGray, for: .normal)
            self.backgroundColor = .clear
        }
    }
}
