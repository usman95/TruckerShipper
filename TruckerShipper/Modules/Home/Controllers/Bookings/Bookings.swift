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
    @IBOutlet weak var btnRejected: UIButtonStatesDeviceClass!
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
            self.btnRejected.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
            self.bookingType = BookingType.pending
            self.recordsToSkip = 0
            self.getBookings()
        case 1:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = true
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
            self.bookingType = BookingType.inProgress
            self.recordsToSkip = 0
            self.getBookings()
        case 2:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = true
            self.btnRejected.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
            self.bookingType = BookingType.completed
            self.recordsToSkip = 0
            self.getBookings()
        default:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = true
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
            self.bookingType = BookingType.rejected
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
        cell.setData(bookingType: self.bookingType, data: data)
        
        cell.btnViewTrips.tag = indexPath.row
        cell.btnAddDocuments.tag = indexPath.row
        
        cell.btnViewTrips.addTarget(self, action: #selector(self.onBtnViewTrips(_:)), for: .touchUpInside)
        cell.btnAddDocuments.addTarget(self, action: #selector(self.onBtnViewAddDocuments(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onBtnViewTrips(_ sender:UIButton){
        let booking = self.arrBookings[sender.tag]
        super.pushToTrips(booking: booking)
    }
    @objc func onBtnViewAddDocuments(_ sender:UIButton){
        let booking = self.arrBookings[sender.tag]
        super.pushToBookingDocuments(booking: booking)
    }
}
//MARK:- Services
extension Bookings{
    private func getBookings(){
        let skip = self.recordsToSkip
        let limit = Constants.PAGINATION_PAGE_SIZE
        let status = self.bookingType.rawValue
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit,
                                   "status":status]
        
        APIManager.sharedInstance.shipperAPIManager.AllBookings(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            response.printJson()
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
