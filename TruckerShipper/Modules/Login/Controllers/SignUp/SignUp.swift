//
//  SignUp.swift
//  TruckerShipper
//
//  Created by Mac Book on 30/11/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import DropDown
import ObjectMapper

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
    
    let shipperDropDown = DropDown()
    var arrShipper = [String]()
    var selectedShipper: String?
    
    var selectedRole: AttributeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAttributes()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnShipperType(_ sender: UIButton) {
        self.shipperDropDown.show()
    }
    @IBAction func onBtnShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
            self.tfShipperType.text = item
            self.selectedShipper = item
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
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: match.range)
        }
        let regex2 = try! NSRegularExpression(pattern: policyString,options: .caseInsensitive)
        for match in regex2.matches(in: mainString, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: mainString.count)) as [NSTextCheckingResult] {
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.link, value: "https://policy.com", range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: match.range)
        }
        self.tvTermsAndPolicies.delegate = self
        self.tvTermsAndPolicies.attributedText = attributedModifiedMessage
        self.tvTermsAndPolicies.textAlignment = .center
    }
    private func getAttributes(){
        self.getRoles()
        self.getShipperTypes()
    }
    private func validate()->[String:Any]?{
        let firstName = self.tfFirstName.text ?? ""
        let lastName = self.tfLastName.text ?? ""
        let email = self.tfEmailAddress.text ?? ""
        let contactNo = self.tfPhoneNumber.text ?? ""
        let roleId = self.selectedRole?.id ?? ""
        let shipperType = self.selectedShipper ?? ""
        let password = self.tfPassword.text ?? ""
        let confirm_password = self.tfConfirmPassword.text ?? ""
        
        if !Validation.isValidName(firstName){
            Utility.main.showToast(message: Strings.INVALID_F_NAME.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.isValidName(lastName){
            Utility.main.showToast(message: Strings.INVALID_L_NAME.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.isValidEmail(email){
            Utility.main.showToast(message: Strings.INVALID_EMAIL.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.isValidNumber(contactNo){
            Utility.main.showToast(message: Strings.INVALID_PHONE.text)
            self.btnCreateAnAccount.shake()
            return nil
        }
        if !Validation.validateStringLength(shipperType){
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
        
        let params:[String:Any] = ["firstName":firstName,
                                   "lastName":lastName,
                                   "email":email,
                                   "contactNo":contactNo,
                                   "roleId":roleId,
                                   "shipperType":shipperType,
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
    private func getRoles(){
        APIManager.sharedInstance.usersAPIManager.Roles(success: { (responseObject) in
            guard let roles = responseObject as? [[String:Any]] else {return}
            let arrRoles = Mapper<AttributeModel>().mapArray(JSONArray: roles)
            self.selectedRole = arrRoles.filter{$0.title == RoleType.Shipper.rawValue}.first
        }) { (error) in
            print(error)
        }
    }
    private func getShipperTypes(){
        APIManager.sharedInstance.usersAPIManager.ShipperTypes(success: { (responseObject) in
            guard let shipper = responseObject as? [String] else {return}
            self.arrShipper = shipper
            self.setShipperDropDown()
        }) { (error) in
            print(error)
        }
    }
    private func signUp(){
        guard let params = self.validate() else {return}
        APIManager.sharedInstance.usersAPIManager.SignUp(params: params, success: { (responseObject) in
            print(responseObject)
            Utility.main.showAlert(message: Strings.SIGNUP_COMPLETED.text, title: Strings.CONFIRMATION.text) {
                Utility.main.topViewController()?.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
}
