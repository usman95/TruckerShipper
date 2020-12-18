//
//  TripDetail.swift
//  TruckerShipper
//
//  Created by Mac Book on 15/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper

class TripDetail: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    let tripDetailView = TripHeader.instanceFromNib() as! TripHeader
    var booking: BookingModel?
    var bookingDetail: BookingDetailtModel?
    
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
//MARK:- Services
extension TripDetail{
    private func getBookingDetail(){
        let id = self.booking?.id ?? ""
        
        APIManager.sharedInstance.shipperAPIManager.BookingDetails(id: id, success: { (responseObject) in
            self.bookingDetail = Mapper<BookingDetailtModel>().map(JSON: responseObject)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
