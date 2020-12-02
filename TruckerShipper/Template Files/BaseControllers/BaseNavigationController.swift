//
//  BaseNavigationController.swift
//  The Court Lawyer
//
//  Created by Ahmed Shahid on 5/3/18.
//  Copyright © 2018 Ahmed Shahid. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.setBackgroundImage(UIImage(named: "TopBar")!, for: .default)
//        self.navigationBar.tintColor = UIColor.white
//        self.navigationBar.barTintColor = UIColor.white
//        self.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
//        self.navigationBar.isTranslucent = false
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = Global.APP_COLOR
        coloredAppearance.backgroundImage = UIImage(named: "TopBar")
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
               
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        
    }
}
