//
//  NotificationsTVC.swift
//  TruckerDriver
//
//  Created by Mac Book on 17/11/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationsTVC: UITableViewCell {

    @IBOutlet weak var imgNotification: RoundedImage!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    func setData(data: NotificationsModel?){
        let notificationImage = data?.from?.profileImageUrl ?? ""
        self.imgNotification.sd_setImage(with: URL(string: notificationImage), placeholderImage: UIImage(named: "profilePlaceHolder"))
        
        self.lblNotification.text = data?.body ?? ""
        
        let notificationDateString = data?.createdAt ?? "2020-12-14T14:24:59.741Z"
        let notificationDateTime = Utility.main.stringDateFormatter(dateStr: notificationDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd-MM-yy hh:mm a")
        self.lblDate.text = notificationDateTime
    }
    
}
