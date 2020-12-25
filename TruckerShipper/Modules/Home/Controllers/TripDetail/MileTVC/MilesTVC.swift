//
//  MilesTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class MilesTVC: UITableViewCell {
    
    let pendingMileColor = UIColor(red:194/255, green:193/255, blue:193/255, alpha:1.0)
    let inProgressMileColor = UIColor(red:0/255, green:70/255, blue:158/255, alpha:1.0)
    let completedMileColor = UIColor(red:63/255, green:183/255, blue:115/255, alpha:1.0)
    
    @IBOutlet weak var viewCurrentMileRadioFill: RoundedView!
    @IBOutlet weak var lblMile: UILabelDeviceClass!
    @IBOutlet weak var lblArrival: UILabelDeviceClass!
    @IBOutlet weak var lblDeparture: UILabelDeviceClass!
    @IBOutlet weak var lblArrivalDateTime: UILabelDeviceClass!
    @IBOutlet weak var lblDepartureDateTime: UILabelDeviceClass!
    @IBOutlet weak var imgArrivalCalendar: UIImageView!
    @IBOutlet weak var imgDepartureCalendar: UIImageView!
    
    func setData(data: TripMilesModel?, index: Int){
        
        switch index{
        case 0:
            self.lblMile.text = data?.pickUpAddress ?? ""
            
            let mileArrivalDateString = data?.pickUpState?.arrivedTime ?? ""
            let mileDepartureDateString = data?.pickUpState?.departedTime ?? ""
            
            switch mileArrivalDateString.isEmpty {
            case true:
                self.lblArrivalDateTime.text = Strings.NA.text
            case false:
                let mileArrivalDate = Utility.main.stringDateFormatter(dateStr: mileArrivalDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd-MM-yy hh:mm a")
                self.lblArrivalDateTime.text = mileArrivalDate
            }
            
            switch mileDepartureDateString.isEmpty {
            case true:
                self.lblDepartureDateTime.text = Strings.NA.text
            case false:
                let mileDepartureDate = Utility.main.stringDateFormatter(dateStr: mileDepartureDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd-MM-yy hh:mm a")
                self.lblDepartureDateTime.text = mileDepartureDate
            }
            
        default:
            self.lblMile.text = data?.dropOffAddress ?? ""
            
            let mileArrivalDateString = data?.dropOffState?.arrivedTime ?? ""
            let mileDepartureDateString = data?.dropOffState?.departedTime ?? ""
            
            switch mileArrivalDateString.isEmpty {
            case true:
                self.lblArrivalDateTime.text = Strings.NA.text
            case false:
                let mileArrivalDate = Utility.main.stringDateFormatter(dateStr: mileArrivalDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd-MM-yy hh:mm a")
                self.lblArrivalDateTime.text = mileArrivalDate
            }
            
            switch mileDepartureDateString.isEmpty {
            case true:
                self.lblDepartureDateTime.text = Strings.NA.text
            case false:
                let mileDepartureDate = Utility.main.stringDateFormatter(dateStr: mileDepartureDateString, dateFormat: Constants.serverDateFormat, formatteddate: "dd-MM-yy hh:mm a")
                self.lblDepartureDateTime.text = mileDepartureDate
            }
        }
        
        switch (data?.status ?? "") {
        case MileType.pending.rawValue:
            
            self.viewCurrentMileRadioFill.backgroundColor = self.pendingMileColor
            
            self.lblMile.textColor = self.pendingMileColor
            self.lblArrival.textColor = self.pendingMileColor
            self.lblDeparture.textColor = self.pendingMileColor
            self.lblArrivalDateTime.textColor = self.pendingMileColor
            self.lblDepartureDateTime.textColor = self.pendingMileColor
            
            let calendarImage = UIImage(named: "CalendarGray")?.maskWithColor(color: self.pendingMileColor)
            self.imgArrivalCalendar.image = calendarImage
            self.imgDepartureCalendar.image = calendarImage
            
        case MileType.inProgress.rawValue:
            
            self.viewCurrentMileRadioFill.backgroundColor = self.inProgressMileColor
            
            self.lblMile.textColor = self.inProgressMileColor
            self.lblArrival.textColor = self.inProgressMileColor
            self.lblDeparture.textColor = self.inProgressMileColor
            self.lblArrivalDateTime.textColor = self.inProgressMileColor
            self.lblDepartureDateTime.textColor = self.inProgressMileColor
            
            let calendarImage = UIImage(named: "CalendarGray")?.maskWithColor(color: self.inProgressMileColor)
            self.imgArrivalCalendar.image = calendarImage
            self.imgDepartureCalendar.image = calendarImage
            
        case MileType.completed.rawValue:

            self.viewCurrentMileRadioFill.backgroundColor = self.completedMileColor
            
            self.lblMile.textColor = self.completedMileColor
            self.lblArrival.textColor = self.completedMileColor
            self.lblDeparture.textColor = self.completedMileColor
            self.lblArrivalDateTime.textColor = self.completedMileColor
            self.lblDepartureDateTime.textColor = self.completedMileColor
            
            let calendarImage = UIImage(named: "CalendarGray")?.maskWithColor(color: self.completedMileColor)
            self.imgArrivalCalendar.image = calendarImage
            self.imgDepartureCalendar.image = calendarImage
        default:
            break
        }
    }
}
