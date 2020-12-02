//
//  Login.swift
//  TruckerDriver
//
//  Created by Mac Book on 09/10/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit

class Login: BaseController {

    @IBOutlet weak var tfUserName: UITextFieldDeviceClass!
    @IBOutlet weak var tfPassword: UITextFieldDeviceClass!
    @IBOutlet weak var btnLogin: UIButtonDeviceClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnShowPassword(_ sender: UIButton) {
        self.tfPassword.isSecureTextEntry = !self.tfPassword.isSecureTextEntry
    }
    @IBAction func onBtnForgotPassword(_ sender: Any) {
        super.pushToForgotPassword()
    }
    @IBAction func onBtnLogin(_ sender: Any) {
        self.login()
    }
    @IBAction func onBtnSignUp(_ sender: Any) {
        super.pushToSignUp()
    }
}
//MARK:- Helper Methods
extension Login{
    private func validate() -> [String:Any]? {
        let userName = self.tfUserName.text ?? ""
        let password = self.tfPassword.text ?? ""
        
        if !Validation.isValidName(userName){
            Utility.main.showToast(message: Strings.INVALID_NAME.text)
            self.btnLogin.shake()
            return nil
        }
        if !Validation.validateStringLength(password){
            Utility.main.showToast(message: Strings.EMPTY_PWD.text)
            self.btnLogin.shake()
            return nil
        }
        
        let params:[String:Any] = ["userName":userName,
                                   "password":password]
        return params
    }
}
//MARK:- Services
extension Login{
    private func login(){
//        guard let params = self.validate() else {return}
        let user = UserModel()
        AppStateManager.sharedInstance.loginUser(user: user)
    }
}
