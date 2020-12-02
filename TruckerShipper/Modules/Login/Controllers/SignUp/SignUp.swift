//
//  SignUp.swift
//  TruckerShipper
//
//  Created by Mac Book on 30/11/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class SignUp: BaseController {
    
    @IBOutlet weak var tvTermsAndPolicies: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK:- Helper Methods
extension SignUp{
    private func setTermsAndPoliciesTextView(){
        let mainString = Strings.TERMS_AND_POLICIES.text
        let termsString = Strings.TERMS_OF_SERVICES.text
        let policyString = Strings.PRIVACY_POLICY.text
        
        let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        self.tvTermsAndPolicies.linkTextAttributes = [NSAttributedString.Key.foregroundColor: Global.APP_COLOR]
        let attributedModifiedMessage = NSMutableAttributedString(string: mainString, attributes: attributes)
        
        let regex1 = try! NSRegularExpression(pattern: termsString,options: .caseInsensitive)
        for match in regex1.matches(in: mainString, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: mainString.count)) as [NSTextCheckingResult] {
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.link, value: "https://terms.com", range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineColor, value: Global.APP_COLOR, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: match.range)
        }
        let regex2 = try! NSRegularExpression(pattern: policyString,options: .caseInsensitive)
        for match in regex2.matches(in: mainString, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: mainString.count)) as [NSTextCheckingResult] {
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.link, value: "https://policy.com", range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.underlineColor, value: Global.APP_COLOR, range: match.range)
            attributedModifiedMessage.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: match.range)
        }
        
        self.tvTermsAndPolicies.attributedText = attributedModifiedMessage
        self.tvTermsAndPolicies.textAlignment = .center
    }
}
