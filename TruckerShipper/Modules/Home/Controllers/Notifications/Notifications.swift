//
//  Notifications.swift
//  TruckerDriver
//
//  Created by Mac Book on 17/11/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit
import ObjectMapper
import DZNEmptyDataSet

class Notifications: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var arrNotifications = [NotificationsModel]()
    var totalNotifications = 0
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.getNotifications()
        // Do any additional setup after loading the view.
    }
}
//MARk:- Helper Methods
extension Notifications{
    private func setUI(){
        self.tableView.emptyDataSetSource = self
        self.registerCells()
        self.pullToRefresh()
    }
    private func registerCells(){
        self.tableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
    }
    
    private func pullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refreshNotifications), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    @objc func refreshNotifications() {
        self.pageNumber = 0
        self.arrNotifications.removeAll()
        self.tableView.reloadData()
        self.getNotifications()
    }
}
extension Notifications: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
        let data = self.arrNotifications[indexPath.row]
        cell.setData(data: data)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.onBtnDeleteNotification(_:)), for: .touchUpInside)
        return cell
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
extension Notifications: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = self.arrNotifications[indexPath.row].data
        let bookingStatus = notification?.bookingStatus ?? ""
        if bookingStatus == BookingType.inProgress.rawValue || bookingStatus == BookingType.accepted.rawValue || bookingStatus == BookingType.completed.rawValue{
            let booking = BookingModel()
            booking.id = self.arrNotifications[indexPath.row].data?.bookingId
            super.pushToTrips(booking: booking)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
//MARK:- DZNEmptyDataSetSource
extension Notifications: DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = Strings.NO_DATA_AVAILABLE.text
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
//MARK:- Services
extension Notifications{
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
            self.arrNotifications.remove(at: index)
            
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
            }
        }) { (error) in
            print(error)
        }
    }
}
