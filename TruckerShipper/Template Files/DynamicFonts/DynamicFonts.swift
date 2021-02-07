//
//  DynamicFonts.swift
//  Racing
//
//  Created by Mac Book on 26/10/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class UILabelDeviceClass : UILabel {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0
    @IBInspectable var iPhoneFontWeight:String = "regular" {
        didSet {
            overrideFontSize(iPhoneFontSize, iPhoneFontWeight)
        }
    }
    @IBInspectable var isCircular:Bool = false
    
    func overrideFontSize(_ fontSize:CGFloat, _ fontWeight:String) {
        
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.6)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.6)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.6)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.6)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.6)
            default:
                break
            }
        case 568.0: //iphone 5, 5s => 4 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.7)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.7)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.7)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.7)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.7)
            default:
                break
            }
        case 667.0: //iphone 6, 6s => 4.7 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.8)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.8)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.8)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.8)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.8)
            default:
                break
            }
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.9)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.9)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.9)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.9)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.9)
            default:
                break
            }
        case 812.0: //iphone 11 pro
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.95)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.95)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.95)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.95)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.95)
            default:
                break
            }
        case 896.0, 926.0: //iphone 11,11 pro max , 12 pro max
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize)
            default:
                break
            }
        default:
            print("not an iPhone")
            break
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isCircular{
            let height = self.frame.height
            self.layer.cornerRadius = CGFloat(height / 2.0)
            self.clipsToBounds = true
        }
    }
}

class UITextFieldDeviceClass : UITextField {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0
    @IBInspectable var iPhoneFontWeight:String = "regular" {
        didSet {
            overrideFontSize(iPhoneFontSize, iPhoneFontWeight)
        }
    }
    @IBInspectable var isCircular:Bool = false
    
    func overrideFontSize(_ fontSize:CGFloat, _ fontWeight:String) {
        
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.6)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.6)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.6)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.6)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.6)
            default:
                break
            }
        case 568.0: //iphone 5, 5s => 4 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.7)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.7)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.7)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.7)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.7)
            default:
                break
            }
        case 667.0: //iphone 6, 6s => 4.7 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.8)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.8)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.8)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.8)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.8)
            default:
                break
            }
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.9)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.9)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.9)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.9)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.9)
            default:
                break
            }
        case 812.0: //iphone 11 pro
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.95)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.95)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.95)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.95)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.95)
            default:
                break
            }
        case 896.0, 926.0: //iphone 11,11 pro max, 12 Pro max
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize)
            default:
                break
            }
        default:
            print("not an iPhone")
            break
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isCircular{
            let height = self.frame.height
            self.layer.cornerRadius = CGFloat(height / 2.0)
            self.clipsToBounds = true
        }
    }
}

class UIButtonDeviceClass : UIButton {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0
    @IBInspectable var iPhoneFontWeight:String = "regular" {
        didSet {
            overrideFontSize(iPhoneFontSize, iPhoneFontWeight)
        }
    }
    @IBInspectable var isCircular:Bool = false
    
    func overrideFontSize(_ fontSize:CGFloat, _ fontWeight:String) {
        
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.6)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.6)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.6)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.6)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.6)
            default:
                break
            }
        case 568.0: //iphone 5, 5s => 4 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.7)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.7)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.7)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.7)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.7)
            default:
                break
            }
        case 667.0: //iphone 6, 6s => 4.7 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.8)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.8)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.8)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.8)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.8)
            default:
                break
            }
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.9)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.9)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.9)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.9)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.9)
            default:
                break
            }
        case 812.0: //iphone 11 pro
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.95)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.95)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.95)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.95)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.95)
            default:
                break
            }
        case 896.0, 926.0: //iphone 11,11 pro max, 12 pro max
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize)
            default:
                break
            }
        default:
            print("not an iPhone")
            break
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isCircular{
            let height = self.frame.height
            self.layer.cornerRadius = CGFloat(height / 2.0)
            self.clipsToBounds = true
        }
    }
}

class UIButtonStatesDeviceClass : UIButton {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0
    @IBInspectable var iPhoneFontWeight:String = "regular" {
        didSet {
            overrideFontSize(iPhoneFontSize, iPhoneFontWeight)
        }
    }
    @IBInspectable var isCircular:Bool = false
    
    func overrideFontSize(_ fontSize:CGFloat, _ fontWeight:String) {
        
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.6)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.6)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.6)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.6)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.6)
            default:
                break
            }
        case 568.0: //iphone 5, 5s => 4 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.7)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.7)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.7)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.7)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.7)
            default:
                break
            }
        case 667.0: //iphone 6, 6s => 4.7 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.8)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.8)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.8)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.8)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.8)
            default:
                break
            }
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.9)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.9)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.9)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.9)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.9)
            default:
                break
            }
        case 812.0: //iphone 11 pro
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.95)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.95)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.95)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.95)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.95)
            default:
                break
            }
        case 896.0, 926.0: //iphone 11,11 pro max, 12 pro max
            switch fontWeight {
            case "light":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-light", size: fontSize)
            case "regular":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-regular", size: fontSize)
            case "medium":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-medium", size: fontSize)
            case "semiBold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize)
            case "bold":
                self.titleLabel?.font = UIFont(name: "Greycliff-cf-bold", size: fontSize)
            default:
                break
            }
        default:
            print("not an iPhone")
            break
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isCircular{
            let height = self.frame.height
            self.layer.cornerRadius = CGFloat(height / 2.0)
            self.clipsToBounds = true
        }
        
        self.tintColor = .clear
        if self.isSelected{
            self.backgroundColor = Global.APP_COLOR
            self.setTitleColor(.white, for: .selected)
        }
        else{
            self.backgroundColor = .clear
            self.setTitleColor(Global.APP_COLOR_DARK_GREY, for: .normal)
        }
    }
    
}

class UITextViewDeviceClass : UITextView {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0
    @IBInspectable var iPhoneFontWeight:String = "regular" {
        didSet {
            overrideFontSize(iPhoneFontSize, iPhoneFontWeight)
        }
    }
    @IBInspectable var isCircular:Bool = false
    
    func overrideFontSize(_ fontSize:CGFloat, _ fontWeight:String) {
        
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.6)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.6)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.6)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.6)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.6)
            default:
                break
            }
        case 568.0: //iphone 5, 5s => 4 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.7)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.7)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.7)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.7)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.7)
            default:
                break
            }
        case 667.0: //iphone 6, 6s => 4.7 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.8)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.8)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.8)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.8)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.8)
            default:
                break
            }
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.9)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.9)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.9)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.9)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.9)
            default:
                break
            }
        case 812.0: //iphone 11 pro
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize * 0.95)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize * 0.95)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize * 0.95)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize * 0.95)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize * 0.95)
            default:
                break
            }
        case 896.0, 926.0: //iphone 11,11 pro max, 12 pro max
            switch fontWeight {
            case "light":
                self.font = UIFont(name: "Greycliff-cf-light", size: fontSize)
            case "regular":
                self.font = UIFont(name: "Greycliff-cf-regular", size: fontSize)
            case "medium":
                self.font = UIFont(name: "Greycliff-cf-medium", size: fontSize)
            case "semiBold":
                self.font = UIFont(name: "Greycliff-cf-semiBold", size: fontSize)
            case "bold":
                self.font = UIFont(name: "Greycliff-cf-bold", size: fontSize)
            default:
                break
            }
        default:
            print("not an iPhone")
            break
        }
    }
}
