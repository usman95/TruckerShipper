//
//  Notifications.swift
//  TruckerDriver
//
//  Created by Mac Book on 17/11/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit

class Notifications: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var recordsToSkip = 0
    var arrBookings = [BookingModel]()
    var totalBookings = 0
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.getNotifications()
        // Do any additional setup after loading the view.
    }
}
//MARk:- Helper Methods
extension Notifications{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
    }
}
extension Notifications: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath)
        return cell
    }
}
//MARK:- Services
extension Notifications{
    private func getNotifications(){
        let skip = self.recordsToSkip + (self.pageNumber * Constants.PAGINATION_PAGE_SIZE)
        let limit = Constants.PAGINATION_PAGE_SIZE

        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        APIManager.sharedInstance.shipperAPIManager.Notifications(params: params, success: { (responseObject) in
            print(responseObject)
        }) { (error) in
            print(error)
        }
    }
}
