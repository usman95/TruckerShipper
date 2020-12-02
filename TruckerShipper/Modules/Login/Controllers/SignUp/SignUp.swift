//
//  SignUp.swift
//  TruckerShipper
//
//  Created by Mac Book on 30/11/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import DropDown

class SignUp: BaseController {
    
    @IBOutlet weak var tfFirstName: UITextFieldDeviceClass!
    @IBOutlet weak var tfLastName: UITextFieldDeviceClass!
    @IBOutlet weak var tfEmailAddress: UITextFieldDeviceClass!
    @IBOutlet weak var tfPhoneNumber: UITextFieldDeviceClass!
    @IBOutlet weak var tfShipperType: UITextFieldDeviceClass!
    @IBOutlet weak var tfPassword: UITextFieldDeviceClass!
    @IBOutlet weak var tfConfirmPassword: UITextFieldDeviceClass!
    @IBOutlet weak var btnCreateAnAccount: UIButtonDeviceClass!
    @IBOutlet weak var tvTermsAndPolicies: UITextView!
    
    var selectedShipper: String?
    var arrShipper = ["Individual","Company"]
    let shipperDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnShipperType(_ sender: UIButton) {
        self.shipperDropDown.show()
    }
    @IBAction func onBtnShowPassword(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            self.tfPassword.isSecureTextEntry = !self.tfPassword.isSecureTextEntry
        default:
            self.tfConfirmPassword.isSecureTextEntry = !self.tfConfirmPassword.isSecureTextEntry
        }
    }
    @IBAction func onBtnCreateAccount(_ sender: UIButtonDeviceClass) {
        self.signUp()
    }
}
//MARK:- Helper Methods
extension SignUp{
    private func setUI(){
        self.setShipperDropDown()
        self.setTermsAndPoliciesTextView()
    }
    private func setShipperDropDown(){
        self.shipperDropDown.dataSource = self.arrShipper
        self.shipperDropDown.anchorView = self.tfShipperType
        self.shipperDropDown.cellHeight = self.tfShipperType.frame.height
        self.shipperDropDown.width = self.tfShipperType.frame.width
        self.shipperDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.tfShipperType.text = item
        }
    }
    private func setTermsAndPoliciesTextView(){
        let mainString = Strings.TERMS_AND_POLICIES.text
        let termsString = Strings.TERMS_OF_SERVICES.text
        let policyString = Strings.PRIVACY_POLICY.text
        
        let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        self.tvTermsAndPolicies.linkTextAttributes = [NSAttributedString.Key.foregroundColor: Global.APP_COLOR]
        let attributedModifiedMessage = NSMutableAttributedString(string: mainString, attributes: attributes)
        
        let regex1 = try! NSRegularExpression(pattern: termsString,options: .caseInsensitive)
        for match in regex1.matches(in: mainString, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: mainString.count)) as [NSTextCheckingResult] {
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.link, value: "https://terms.com", range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineColor, value: Global.APP_COLOR, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: match.range)
        }
        let regex2 = try! NSRegularExpression(pattern: policyString,options: .caseInsensitive)
        for match in regex2.matches(in: mainString, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: mainString.count)) as [NSTextCheckingResult] {
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.link, value: "https://policy.com", range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineColor, value: Global.APP_COLOR, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: match.range)
        }
        self.tvTermsAndPolicies.delegate = self
        self.tvTermsAndPolicies.attributedText = attributedModifiedMessage
        self.tvTermsAndPolicies.textAlignment = .center
    }
    private func validate()->[String:Any]?{
        let first_name = self.tfFirstName.text ?? ""
        let last_name = self.tfLastName.text ?? ""
        let email_address = self.tfEmailAddress.text ?? ""
        let phone_number = self.tfPhoneNumber.text ?? ""
        let shipper_type = self.selectedShipper ?? ""
        let password = self.tfPassword.text ?? ""
        let confirm_password = self.tfConfirmPassword.text ?? ""
        
        if !Validation.isValidName(first_name){
            Utility.main.showToast(message: Strings.INVALID_F_NAME.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.isValidName(last_name){
            Utility.main.showToast(message: Strings.INVALID_L_NAME.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.isValidEmail(email_address){
            Utility.main.showToast(message: Strings.INVALID_EMAIL.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.isValidNumber(phone_number){
            Utility.main.showToast(message: Strings.INVALID_PHONE.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.validateStringLength(shipper_type){
            Utility.main.showToast(message: Strings.SELECT_SHIPPER.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.isValidPasswordLength(password){
            Utility.main.showToast(message: Strings.INVALID_PWD_LENGTH.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if password != confirm_password{
            Utility.main.showToast(message: Strings.PWD_DONT_MATCH.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        
        let params:[String:Any] = ["first_name":first_name,
                                   "last_name":last_name,
                                   "email_address":email_address,
                                   "phone_number":phone_number,
                                   "shipper_type":shipper_type,
                                   "password":password]
        return params
    }
}
//MARK:- UITextViewDelegate
extension SignUp: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let urlString = URL.absoluteString
        if urlString.contains("terms"){
            
        }
        if urlString.contains("policy"){
            
        }
        return false
    }
}
//MARK:- Services
extension SignUp{
    private func signUp(){
        guard let params = self.validate() else {return}
        print(params)
    }
}
