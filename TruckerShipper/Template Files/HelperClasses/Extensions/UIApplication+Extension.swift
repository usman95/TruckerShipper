
import Foundation
import UIKit

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(NSURL(string: url)! as URL) {
                application.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
                return
            }
        }
    }
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
           if let nav = viewController as? UINavigationController {
               return topViewController(nav.visibleViewController)
           }
           if let tab = viewController as? UITabBarController {
               if let selected = tab.selectedViewController {
                   return topViewController(selected)
               }
           }
           if let presented = viewController?.presentedViewController {
               return topViewController(presented)
           }
           
           return viewController
       }
}
