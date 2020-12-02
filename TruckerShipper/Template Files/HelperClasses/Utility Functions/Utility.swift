import Foundation
import UIKit
import AVFoundation
import Toast_Swift
import ContactsUI

//MARK:- AppHelperUtility setup
@objc class Utility: NSObject{
    static let main = Utility()
    fileprivate override init() {}
}
extension Utility{
    func topViewController(base: UIViewController? = (AppDelegate.shared).window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    func thumbnailForVideoAtURL(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform=true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    func openURL(url:URL){
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
        else{
            self.showAlert(message: Strings.URL_NOT_VALID.text ,title: Strings.ERROR.text)
        }
    }
    func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
//MARK:- SHOW TOAST
extension Utility{
    func showToast(message:String){
        Utility().topViewController()?.view.makeToast(message, duration: 2.0, position: .center, title: nil, image: nil, style: .init(), completion: nil)
    }
}
//MARK:- INDICATOR
extension Utility{
    static func showLoader() {
        CustomLoader.sharedInstance.startAnimation()
    }
    static func hideLoader(){
        CustomLoader.sharedInstance.stopAnimation()
    }
}
//MARK:- Make phone call
extension Utility{
    func makeCallTo(number:String){
        guard let number = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(number)
    }
}
//MARK:- Alert related functions
extension Utility{
    func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        Utility().topViewController()!.present(alert, animated: true){}
    }
    func showAlert(message: String, title: String, usingCompletionHandler handler:@escaping (() -> Swift.Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            handler()
        }))
        Utility().topViewController()!.present(alertController, animated: true, completion: nil)
    }
    func showAlert(message: String, title: String, YES: String, NO: String, completionHandler: @escaping (UIAlertAction?, UIAlertAction?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: YES, style: .default){ (alertActionYES) in
            completionHandler(alertActionYES, nil)
        })
        alertController.addAction(UIAlertAction(title: NO, style: .cancel){ (alertActionNO) in
            completionHandler(nil, alertActionNO)
        })
        Utility().topViewController()!.present(alertController, animated: true, completion: nil)
    }
}
//MARK:- Validation Alert
extension Utility{
//    func showAlert(message:String){
//        let storyboard = AppStoryboard.Login.instance
//        guard let controller = storyboard.instantiateViewController(identifier: "ValidationController") as? ValidationController else {return}
//        controller.message = message
//        Utility().topViewController()!.present(controller, animated: true, completion: nil)
//    }
//    func showAlert(message: String, usingCompletionHandler handler:@escaping (() -> Swift.Void)) {
//        let storyboard = AppStoryboard.Login.instance
//        guard let controller = storyboard.instantiateViewController(identifier: "ConfirmationController") as? ConfirmationController else {return}
//        controller.message = message
//        Utility().topViewController()!.present(controller, animated: true, completion: nil)
//        
//        controller.dismiss = { _ in
//            handler()
//        }
//    }
//    func showAlert(message: String, YES: String, NO: String, completionHandler: @escaping (Bool, Bool) -> Void) {
//        let storyboard = AppStoryboard.Login.instance
//        guard let controller = storyboard.instantiateViewController(identifier: "ConfirmController") as? ConfirmController else {return}
//        controller.message = message
//        controller.yesText = YES
//        controller.noText = NO
//        Utility().topViewController()!.present(controller, animated: true, completion: nil)
//        
//        controller.dismiss = { Yes,No in
//            completionHandler(Yes, No)
//        }
//    }
//    func showSorryAlert(message: String, usingCompletionHandler handler:@escaping (() -> Swift.Void)) {
//        let storyboard = AppStoryboard.Login.instance
//        guard let controller = storyboard.instantiateViewController(identifier: "SorryController") as? SorryController else {return}
//        controller.message = message
//        Utility().topViewController()!.present(controller, animated: true, completion: nil)
//        
//        controller.dismiss = { _ in
//            handler()
//        }
//    }
}
//MARK:- Go To Settings
extension Utility{
    func goToSettings(){
        let alertController = UIAlertController (title: "Settings", message: "Location permission is mendatory to give customer access to track his delivery.\nGo to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        Utility.main.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
//MARK:- Utility Methods
extension Utility{
    func stringDateFormatter(dateStr: String , dateFormat : String , formatteddate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = formatteddate
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter.string(from: date ?? Date())
    }
    func dateFormatter(date: Date,dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    func getDateFrom(dateString: String,dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: dateString) else {return nil}
        return date
    }
    func emojiFlag(regionCode: String) -> String? {
        let code = regionCode.uppercased()
        
        guard Locale.isoRegionCodes.contains(code) else {return nil}
        
        var flagString = ""
        for s in code.unicodeScalars {
            guard let scalar = UnicodeScalar(127397 + s.value) else {
                continue
            }
            flagString.append(String(scalar))
        }
        return flagString
    }
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func presentSettingsAlert() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!

        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Permission to Contacts", message: "QuickDelivery needs access to contacts in order to send them invitations.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
                UIApplication.shared.open(settingsURL)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            Utility.main.topViewController()?.present(alert, animated: true)
        }
    }
}
//MARK:- Phone contacts
extension Utility{
    func getContacts() -> [CNContact] {
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        
        return results.sorted(by: { $0.givenName < $1.givenName })
    }
}
//MARK:- Share QD application link
extension Utility{
    func shareQuickDelivery(text: String){
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = Utility.main.topViewController()?.view
        Utility.main.topViewController()?.present(activityViewController, animated: true, completion: nil)
    }
}
