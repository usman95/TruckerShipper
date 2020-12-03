//
//  ForgotPassword.swift
//  TruckerShipper
//
//  Created by Mac Book on 30/11/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class ForgotPassword: BaseController {
    
    @IBOutlet weak var tfEmailAddress: UITextFieldDeviceClass!
    @IBOutlet weak var btnSubmit: UIButtonDeviceClass!
    
    @IBAction func onBtnSubmit(_ sender: UIButtonDeviceClass) {
        self.forgotPassword()
    }
}
//MARK:- Helper Methods
extension ForgotPassword{
    private func validate()->[String:Any]?{
        let email = self.tfEmailAddress.text ?? ""
        
        if !Validation.isValidEmail(email){
            Utility.main.showToast(message: Strings.INVALID_EMAIL.text)
            self.btnSubmit.shake()
            return nil
        }
        
        let param:[String:Any] = ["email":email]
        return param
    }
}
//MARK:- Services
extension ForgotPassword{
    private func forgotPassword(){
        guard let param = self.validate() else {return}
        APIManager.sharedInstance.usersAPIManager.ForgotPassword(params: param, success: { (responseObject) in
            Utility.main.showAlert(message: Strings.FORGOT_PASSWORD_EMAIL_SENT.text, title: Strings.CONFIRMATION.text) {
                Utility.main.topViewController()?.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
}
