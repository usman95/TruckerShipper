//
//  Login.swift
//  TruckerDriver
//
//  Created by Mac Book on 09/10/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit
import ObjectMapper

class Login: BaseController {

    @IBOutlet weak var tfEmailAddress: UITextFieldDeviceClass!
    @IBOutlet weak var tfPassword: UITextFieldDeviceClass!
    @IBOutlet weak var btnLogin: UIButtonDeviceClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfEmailAddress.text = "hcurnor@gmail.com"
        self.tfPassword.text = "abc123++"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
        let email = self.tfEmailAddress.text ?? ""
        let password = self.tfPassword.text ?? ""
        
        if !Validation.isValidEmail(email){
            Utility.main.showToast(message: Strings.INVALID_EMAIL.text)
            self.btnLogin.shake()
            return nil
        }
        if !Validation.validateStringLength(password){
            Utility.main.showToast(message: Strings.EMPTY_PWD.text)
            self.btnLogin.shake()
            return nil
        }
        
        let params:[String:Any] = ["email":email,
                                   "password":password]
        return params
    }
}
//MARK:- Services
extension Login{
    private func login(){
        guard let params = self.validate() else {return}
        APIManager.sharedInstance.usersAPIManager.Login(params: params, success: { (responseObject) in
            guard let user = Mapper<UserModel>().map(JSON: responseObject) else{return}
            print(user)
            AppStateManager.sharedInstance.loginUser(user: user)
        }) { (error) in
            print(error)
        }
    }
}
