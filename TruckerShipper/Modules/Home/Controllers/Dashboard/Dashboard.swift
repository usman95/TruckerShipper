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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
        self.getBookingsCount()
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
            return 10
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
            return cell
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
}
