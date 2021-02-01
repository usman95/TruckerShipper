import UIKit

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        //if your storyboard name is same as ControllerName uncomment it
        //return "\(self)"
        return "\(self)" + "_ID"
        
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        Utility.main.topViewController()?.view.endEditing(true)
    }
}
extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
}
extension UIViewController {
    
    //Align Textfield Text
    func loopThroughSubViewAndAlignTextfieldText(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UITextField && subView.tag <= 0{
                    let textField = subView as! UITextField
                    textField.textAlignment = MOLHLanguage.currentAppleLanguage() == "en" ? .left:.right
                } else if subView is UITextView && subView.tag <= 0{
                    let textView = subView as! UITextView
                    textView.textAlignment = MOLHLanguage.currentAppleLanguage() == "en" ? .left:.right
                    
                }
                loopThroughSubViewAndAlignTextfieldText(subviews: subView.subviews)
            }
        }
    }
}
