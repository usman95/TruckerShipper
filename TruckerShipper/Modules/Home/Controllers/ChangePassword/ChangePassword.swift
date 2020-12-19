//
//  ChangePassword.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class ChangePassword: BaseController {
    
    @IBOutlet weak var tfCurrentPassword: UITextFieldDeviceClass!
    @IBOutlet weak var tfNewPassword: UITextFieldDeviceClass!
    @IBOutlet weak var tfConfirmPassword: UITextFieldDeviceClass!
    @IBOutlet weak var btnChangePassword: UIButtonDeviceClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func onBtnViewPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag{
        case 0:
            self.tfCurrentPassword.isSecureTextEntry = !self.tfCurrentPassword.isSecureTextEntry
        case 1:
            self.tfNewPassword.isSecureTextEntry = !self.tfNewPassword.isSecureTextEntry
        default:
            self.tfConfirmPassword.isSecureTextEntry = !self.tfConfirmPassword.isSecureTextEntry
        }
    }
    @IBAction func onBtnChangePassword(_ sender: UIButtonDeviceClass) {
        self.changePassword()
    }
}
//MARK:- Helper Methods
extension ChangePassword{
    private func validate() -> [String:Any]? {
        let currentPassword = self.tfCurrentPassword.text ?? ""
        let newPassword = self.tfNewPassword.text ?? ""
        let confirmPassword = self.tfConfirmPassword.text ?? ""

        if currentPassword == ""{
            Utility.main.showToast(message: Strings.INVALID_PWD_LENGTH.text)
            self.btnChangePassword.shake()
            return nil
        }
        if newPassword == ""{
            Utility.main.showToast(message: Strings.INVALID_PWD_LENGTH.text)
            self.btnChangePassword.shake()
            return nil
        }
        if confirmPassword == ""{
            Utility.main.showToast(message: Strings.INVALID_PWD_LENGTH.text)
            self.btnChangePassword.shake()
            return nil
        }
        if !Validation.isConfirmPasswordIsEqualToPassword(password: newPassword, confirm: confirmPassword){
            Utility.main.showToast(message: Strings.PWD_DONT_MATCH.text)
            self.btnChangePassword.shake()
            return nil
        }
        
        let params:[String:Any] = ["old_password":currentPassword,
                                   "password": newPassword]
        return params
    }
}
//MARK:- Services
extension ChangePassword{
    private func changePassword(){
        guard let params = self.validate() else {return}
        
    }
}
