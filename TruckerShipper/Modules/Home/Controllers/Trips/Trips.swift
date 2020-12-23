//
//  Trips.swift
//  TruckerShipper
//
//  Created by Mac Book on 15/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper

class Trips: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    var booking: BookingModel?
    var bookingDetail: BookingDetailtModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getBookingDetail()
    }
}
//MARK:- Helper methods
extension Trips{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "BookingsTVC", bundle: nil), forCellReuseIdentifier: "BookingsTVC")
    }
}
//MARK:- UITableViewDataSource
extension Trips: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookingDetail?.trips.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTVC", for: indexPath) as! BookingsTVC
        let trip = self.bookingDetail?.trips[indexPath.row]
        cell.setData(bookingDetails: self.bookingDetail, trip: trip)
        return cell
    }
}
//MARK:- UITableViewDelegate
extension Trips: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.bookingDetail?.trips[indexPath.row].tripMiles.isEmpty ?? false){
            Utility.main.showToast(message: Strings.NO_MILES_AVAILABLE.text)
            return
        }
        
        let trip = self.bookingDetail?.trips[indexPath.row]
        super.pushToTripDetails(bookingDetail: self.bookingDetail, trip: trip)
    }
}
//MARK:- Services
extension Trips{
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
