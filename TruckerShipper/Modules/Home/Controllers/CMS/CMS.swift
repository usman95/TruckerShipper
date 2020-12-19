//
//  CMS.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class CMS: BaseController {

    @IBOutlet weak var lblTitle: UILabelDeviceClass!
    @IBOutlet weak var tvCMS: UITextViewDeviceClass!
    
    var cmsType = CMSType.privacyPolicy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.callAPIs()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper methods
extension CMS{
    private func setUI(){
        switch self.cmsType{
        case .privacyPolicy:
            self.lblTitle.text = Strings.PRIVACY_POLICY.text.uppercased()
        case .termsAndCondition:
            self.lblTitle.text = Strings.TERMS_AND_CONDITIONS.text.uppercased()
        }
    }
    private func callAPIs(){
        switch self.cmsType{
        case .privacyPolicy:
            self.getPrivacyPolicy()
        case .termsAndCondition:
            self.getTermsAndConditions()
        }
    }
    private func setData(data: String){
        self.tvCMS.text = data
    }
}
//MARK:- Services
extension CMS{
    private func getPrivacyPolicy(){
        APIManager.sharedInstance.attributesAPIManager.PrivacyPolicy(success: { (responseObject) in
            let response = responseObject as Dictionary
            let privacyPolicy = response["privacyPolicy"] as? String ?? ""
            self.setData(data: privacyPolicy)
        }) { (error) in
            print(error)
        }
    }
    private func getTermsAndConditions(){
        APIManager.sharedInstance.attributesAPIManager.TermsAndCondition(success: { (responseObject) in
            let response = responseObject as Dictionary
            let privacyPolicy = response["termsAndConditions"] as? String ?? ""
            self.setData(data: privacyPolicy)
        }) { (error) in
            print(error)
        }
    }
}
