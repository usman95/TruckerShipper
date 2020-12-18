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
    @IBOutlet weak var btnTrackLocation: UIButtonDeviceClass!
    
    var bookingDetail: BookingDetailtModel?
    var trip: TripsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.getBookingDetail()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper methods
extension TripDetail{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "TripDetailTVC", bundle: nil), forCellReuseIdentifier: "TripDetailTVC")
        self.tableView.register(UINib(nibName: "MilesTVC", bundle: nil), forCellReuseIdentifier: "MilesTVC")
    }
}
//MARK:- Helper method
extension TripDetail{
}
//MARK:- Helper method
extension TripDetail: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.trip?.tripMiles.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailTVC", for: indexPath) as!  TripDetailTVC
            cell.setData(bookingDetail: self.bookingDetail, trip: self.trip)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MilesTVC", for: indexPath) as! MilesTVC
            let data = self.trip?.tripMiles[indexPath.row]
            cell.setData(data: data)
            return cell
        }
    }
}
//MARK:- UITableViewDelegate
extension TripDetail: UITableViewDelegate{
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
            header.setData(data: Strings.MILES_TRACKING.text)
            return header
        }
    }
}
//MARK:- Services
extension TripDetail{
    private func getBookingDetail(){
        let id = self.bookingDetail?.id ?? ""
        
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
