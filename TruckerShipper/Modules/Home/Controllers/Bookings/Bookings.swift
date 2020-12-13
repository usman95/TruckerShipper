//
//  Bookings.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper

class Bookings: BaseController {

    @IBOutlet weak var btnPending: UIButtonStatesDeviceClass!
    @IBOutlet weak var btnInProgress: UIButtonStatesDeviceClass!
    @IBOutlet weak var btnCompleted: UIButtonStatesDeviceClass!
    @IBOutlet weak var tableView: UITableView!
    
    var bookingType = BookingType.pending
    var recordsToSkip = 0
    var arrBookings = [BookingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.getBookings()
        // Do any additional setup after loading the view.
    }

    @IBAction func onBtnBookingsStatus(_ sender: UIButtonStatesDeviceClass) {
        switch sender.tag {
        case 0:
            self.btnPending.isSelected = true
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = false
            
            self.bookingType = BookingType.pending
            self.recordsToSkip = 0
            self.getBookings()
        case 1:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = true
            self.btnCompleted.isSelected = false
            
            self.bookingType = BookingType.inProgress
            self.recordsToSkip = 0
            self.getBookings()
        default:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = true
            
            self.bookingType = BookingType.completed
            self.recordsToSkip = 0
            self.getBookings()
        }
    }
}
//MARK:- Helper methods
extension Bookings{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "BookingsTVC", bundle: nil), forCellReuseIdentifier: "BookingsTVC")
    }
}
//MARK:- UITableViewDataSource
extension Bookings: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBookings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTVC", for: indexPath) as! BookingsTVC
        let data = self.arrBookings[indexPath.row]
        cell.setData(data: data)
        return cell
    }
}
//MARK:- Services
extension Bookings{
    private func getBookings(){
        let skip = self.recordsToSkip
        let limit = Constants.PAGINATION_PAGE_SIZE
//        let status = self.bookingType.rawValue
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
//        let params:[String:Any] = ["skip":skip,
//                                   "limit":limit,
//                                   "status":status]
        
        APIManager.sharedInstance.shipperAPIManager.AllBookings(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let bookings = response["bookings"] as? [[String:Any]] else {return}
            self.arrBookings = Mapper<BookingModel>().mapArray(JSONArray: bookings)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
