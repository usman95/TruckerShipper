//
//  Dashboard.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper
import LGSideMenuController

class Dashboard: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLoadRequest: UIButtonDeviceClass!
    @IBOutlet weak var btnRateRequest: UIButtonDeviceClass!
    
    var bookingsCount: BookingsCountModel?
    var refreshControl = UIRefreshControl()
    var arrNotifications = [NotificationsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShipperTypeUI()
        self.getBookingsCount()
        self.getNotifications()
    }
    
    @IBAction func onBtnLoadRequest(_ sender: UIButtonDeviceClass) {
        super.pushToMyContracts()
    }
    @IBAction func onBtnRateRequest(_ sender: UIButtonDeviceClass) {
        super.pushToHome()
    }
}
//MARK:- Helper Methods
extension Dashboard{
    private func setUI(){
        self.registerCells()
        self.pullToRefresh()
    }
    private func setShipperTypeUI(){
        let shipperType = AppStateManager.sharedInstance.loggedInUser.user?.shipperType ?? ""
        switch shipperType{
        case ShipperType.WalkIn.rawValue:
            self.btnLoadRequest.isHidden = true
        default:
            self.btnLoadRequest.isHidden = false
        }
        
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return}
        guard let sideMenu = topController.leftViewController as? SideMenu else {return}
        sideMenu.setShipperTypeUI()
    }
    private func registerCells(){
        self.tableView.register(UINib(nibName: "DashboardTVC", bundle: nil), forCellReuseIdentifier: "DashboardTVC")
        self.tableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
    }
    private func setDashboard(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func pullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(self.refreshAll), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    @objc func refreshAll() {
        self.arrNotifications.removeAll()
        self.tableView.reloadData()
        
        self.getBookingsCount()
        self.getNotifications()
    }
}
//MARK:- UITableViewDataSource
extension Dashboard: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        default:
            return self.arrNotifications.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTVC", for: indexPath) as! DashboardTVC
            cell.setData(data: self.bookingsCount)
            cell.btnProfileImage.addTarget(self, action: #selector(self.onBtnProfileImage(_:)), for: .touchUpInside)
            cell.btnTotalBookings.addTarget(self, action: #selector(self.onBtnBookingStatus(_:)), for: .touchUpInside)
            cell.btnBookingsInProgress.addTarget(self, action: #selector(self.onBtnBookingStatus(_:)), for: .touchUpInside)
            cell.btnCompletedBookings.addTarget(self, action: #selector(self.onBtnBookingStatus(_:)), for: .touchUpInside)
            cell.btnCancelled.addTarget(self, action: #selector(self.onBtnBookingStatus(_:)), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
            let data = self.arrNotifications[indexPath.row]
            cell.setData(data: data)
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(self.onBtnDeleteNotification(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func onBtnProfileImage(_ sender: UIButton){
        super.pushToMyAccount()
    }
    @objc func onBtnBookingStatus(_ sender: UIButton){
        switch sender.tag {
        case 0:
            super.pushToBookings(bookingType: .pending)
        case 1:
            super.pushToBookings(bookingType: .inProgress)
        case 2:
            super.pushToBookings(bookingType: .completed)
        default:
            super.pushToBookings(bookingType: .cancelled)
        }
    }
    @objc func onBtnDeleteNotification(_ sender: UIButton){
        Utility.main.showAlert(message: Strings.ASK_TO_DELETE_NOTIFICATION.text, title: Strings.CONFIRMATION.text, YES: Strings.YES.text, NO: Strings.NO.text) { (yes, no) in
            if yes != nil{
                let index = sender.tag
                let id = self.arrNotifications[index].id ?? ""
                self.deleteNotification(id: id, index: index)
            }
        }
    }
}
//MARK:- UITableViewDelegate
extension Dashboard: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {return}
        
        let notification = self.arrNotifications[indexPath.row].data
        let bookingStatus = notification?.bookingStatus ?? ""
        if bookingStatus == BookingType.inProgress.rawValue || bookingStatus == BookingType.accepted.rawValue || bookingStatus == BookingType.completed.rawValue{
            let booking = BookingModel()
            booking.id = self.arrNotifications[indexPath.row].data?.bookingId
            super.pushToTrips(booking: booking)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 0.0
        default:
            if !self.arrNotifications.isEmpty{
                return 50.0
            }
            else{
                return 0.0
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            return nil
        default:
            if !self.arrNotifications.isEmpty{
                let header = TitleHeader.instanceFromNib() as! TitleHeader
                header.setData(data: Strings.NOTIFICATIONS.text)
                return header
            }
            else{
                return nil
            }
        }
    }
}
extension Dashboard{
    private func getBookingsCount(){
        APIManager.sharedInstance.shipperAPIManager.BookingsCount(success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let bookingCounts = response["bookingCounts"] as? [String:Any] else {return}
            self.bookingsCount = Mapper<BookingsCountModel>().map(JSON: bookingCounts)
            self.setDashboard()
        }) { (error) in
            print(error)
        }
    }
    private func getNotifications(){
        let skip = 0
        let limit = 1000
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.shipperAPIManager.Notifications(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let notifications = response["notifications"] as? [[String:Any]] else {return}
            self.arrNotifications = Mapper<NotificationsModel>().mapArray(JSONArray: notifications)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
            print(error)
        }
    }
    private func deleteNotification(id: String, index: Int){
        APIManager.sharedInstance.shipperAPIManager.DeleteNotification(id: id, success: { (responseObject) in
            self.arrNotifications.remove(at: index)
            
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .bottom)
            }
        }) { (error) in
            print(error)
        }
    }
}
