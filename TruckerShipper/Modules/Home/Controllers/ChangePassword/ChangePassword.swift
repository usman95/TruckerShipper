//
//  ChangePassword.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class ChangePassword: BaseController {
    
    @IBOutlet weak var tfOldPassword: UITextFieldDeviceClass!
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
            self.tfOldPassword.isSecureTextEntry = !self.tfOldPassword.isSecureTextEntry
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
        let oldPassword = self.tfOldPassword.text ?? ""
        let newPassword = self.tfNewPassword.text ?? ""
        let confirmPassword = self.tfConfirmPassword.text ?? ""

        if !Validation.validateStringLength(oldPassword){
            Utility.main.showToast(message: Strings.INVALID_PWD_LENGTH.text)
            self.btnChangePassword.shake()
            return nil
        }
        if !Validation.validateStringLength(newPassword){
            Utility.main.showToast(message: Strings.INVALID_NEW_PWD_LENGTH.text)
            self.btnChangePassword.shake()
            return nil
        }
        if !Validation.isConfirmPasswordIsEqualToPassword(password: newPassword, confirm: confirmPassword){
            Utility.main.showToast(message: Strings.PWD_DONT_MATCH.text)
            self.btnChangePassword.shake()
            return nil
        }
        
        let params:[String:Any] = ["oldPassword":oldPassword,
                                   "newPassword": newPassword]
        return params
    }
}
//MARK:- Services
extension ChangePassword{
    private func changePassword(){
        let id = AppStateManager.sharedInstance.loggedInUser.user?.id ?? ""
        guard let params = self.validate() else {return}
        
        APIManager.sharedInstance.usersAPIManager.UpdatePassword(id: id, params: params, success: { (responseObject) in
            Utility.main.showAlert(message: Strings.PASSWORD_UPDATED.text, title: Strings.CONFIRMATION.text) {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
}
