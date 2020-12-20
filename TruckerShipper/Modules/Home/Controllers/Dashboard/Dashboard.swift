//
//  Dashboard.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper

class Dashboard: BaseController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLoadRequest: UIButtonDeviceClass!
    @IBOutlet weak var btnRateRequest: UIButtonDeviceClass!
    
    var bookingsCount: BookingsCountModel?
    var refreshControl = UIRefreshControl()
    var arrNotifications = [NotificationsModel]()
    var totalNotifications = 0
    var pageNumber = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
        self.getBookingsCount()
        self.getNotifications()
    }
    
    @IBAction func onBtnLoadRequest(_ sender: UIButtonDeviceClass) {
//        super.pushToHome()
    }
    @IBAction func onBtnRateRequest(_ sender: UIButtonDeviceClass) {
        super.pushToHome()
    }
}
//MARK:- Helper Methods
extension Dashboard{
    private func setUI(){
        self.registerCells()
        
        let shipperType = AppStateManager.sharedInstance.loggedInUser.user?.shipperType ?? ""
        switch shipperType{
        case ShipperType.WalkIn.rawValue:
            self.btnLoadRequest.isHidden = true
        default:
            self.btnLoadRequest.isHidden = false
        }
        
        self.pullToRefresh()
    }
    private func registerCells(){
        self.tableView.register(UINib(nibName: "DashboardTVC", bundle: nil), forCellReuseIdentifier: "DashboardTVC")
        self.tableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
    }
    private func setDashboard(){
        DispatchQueue.main.async {
            let index = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [index], with: .automatic)
        }
    }
    
    private func pullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refreshAll), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    @objc func refreshAll() {
        self.pageNumber = 0
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 0.0
        default:
            return 50.0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            return nil
        default:
            let header = TitleHeader.instanceFromNib() as! TitleHeader
            header.setData(data: Strings.NOTIFICATIONS.text)
            return header
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {return}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if tableView.visibleCells.contains(cell) {
                if indexPath.row == self.arrNotifications.count - 1{
                    self.loadMoreCells()
                }
            }
        }
    }
    
    private func loadMoreCells(){
        if self.totalNotifications != self.arrNotifications.count{
            self.pageNumber += 1
            self.getNotifications()
        }
    }
}
extension Dashboard{
    private func getBookingsCount(){
        APIManager.sharedInstance.shipperAPIManager.BookingsCount(success: { (responseObject) in
            self.bookingsCount = Mapper<BookingsCountModel>().map(JSON: responseObject)
            self.setDashboard()
        }) { (error) in
            print(error)
        }
    }
    private func getNotifications(){
        let skip = self.pageNumber * Constants.PAGINATION_PAGE_SIZE
        let limit = Constants.PAGINATION_PAGE_SIZE
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        APIManager.sharedInstance.shipperAPIManager.Notifications(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary

            if let notificationsCount = response["notificationsCount"] as? Int {self.totalNotifications = notificationsCount}

            guard let notifications = response["notifications"] as? [[String:Any]] else {return}
            let arrNotifications = Mapper<NotificationsModel>().mapArray(JSONArray: notifications)
            self.arrNotifications.append(contentsOf: arrNotifications)

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
            print(responseObject)
            self.arrNotifications.remove(at: index)
            
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .bottom)
            }
        }) { (error) in
            print(error)
        }
    }
}
