//
//  Dashboard.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class Dashboard: BaseController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLoadRequest: UIButtonDeviceClass!
    @IBOutlet weak var btnRateRequest: UIButtonDeviceClass!
    
    let dashboardView = DashboardHeader.instanceFromNib() as! DashboardHeader
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnLoadRequest(_ sender: UIButtonDeviceClass) {
        super.pushToHome(bookingRequest: .load)
    }
    @IBAction func onBtnRateRequest(_ sender: UIButtonDeviceClass) {
        super.pushToHome(bookingRequest: .rate)
    }
}
//MARK:- Helper Methods
extension Dashboard{
    private func setUI(){
        self.registerCells()
        self.setHeaderView()
    }
    private func registerCells(){
        self.tableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
    }
    private func setHeaderView(){
        self.dashboardView.setData()
        self.tableView.tableHeaderView = self.dashboardView
    }
}
//MARK:- UITableViewDataSource
extension Dashboard: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
        return cell
    }
}
//MARK:- UITableViewDelegate
extension Dashboard: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50.0)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TitleHeader.instanceFromNib() as! TitleHeader
        return header
    }
}
