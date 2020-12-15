//
//  TripDetail.swift
//  TruckerShipper
//
//  Created by Mac Book on 15/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class TripDetail: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    let tripDetailView = TripHeader.instanceFromNib() as! TripHeader
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHeaderView()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper method
extension TripDetail{
    private func setHeaderView(){
//        self.dashboardView.setData()
        self.tableView.tableHeaderView = self.tripDetailView
    }
}
//MARK:- Helper method
extension TripDetail: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
