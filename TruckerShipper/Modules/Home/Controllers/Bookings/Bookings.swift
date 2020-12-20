//
//  Bookings.swift
//  TruckerShipper
//
//  Created by Mac Book on 13/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper
import DZNEmptyDataSet

class Bookings: BaseController {

    @IBOutlet weak var btnPending: UIButtonStatesDeviceClass!
    @IBOutlet weak var btnInProgress: UIButtonStatesDeviceClass!
    @IBOutlet weak var btnCompleted: UIButtonStatesDeviceClass!
    @IBOutlet weak var btnRejected: UIButtonStatesDeviceClass!
    @IBOutlet weak var tableView: UITableView!
    
    var bookingType = BookingType.pending
    var refreshControl = UIRefreshControl()
    var arrBookings = [BookingModel]()
    var totalBookings = 0
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
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
        case 1:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = true
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
            self.bookingType = BookingType.inProgress
        case 2:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = true
            self.btnRejected.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
            self.bookingType = BookingType.completed
        default:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = true
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
            self.bookingType = BookingType.rejected
        }
        
        self.refreshBookings()
    }
}
//MARK:- Helper methods
extension Bookings{
    private func setUI(){
        self.tableView.emptyDataSetSource = self
        self.registerCells()
        self.pullToRefresh()
    }
    private func registerCells(){
        self.tableView.register(UINib(nibName: "BookingsTVC", bundle: nil), forCellReuseIdentifier: "BookingsTVC")
    }
    
    private func pullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refreshBookings), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    @objc func refreshBookings() {
        self.pageNumber = 0
        self.arrBookings.removeAll()
        self.tableView.reloadData()
        self.getBookings()
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
//MARK:- UITableViewDelegate
extension Bookings: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if tableView.visibleCells.contains(cell) {
                if indexPath.row == self.arrBookings.count - 1{
                    self.loadMoreCells()
                }
            }
        }
    }
    
    private func loadMoreCells(){
        if self.totalBookings != self.arrBookings.count{
            self.pageNumber += 1
            self.getBookings()
        }
    }
}
//MARK:- DZNEmptyDataSetSource
extension Bookings: DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = Strings.NO_DATA_AVAILABLE.text
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
//MARK:- Services
extension Bookings{
    private func getBookings(){
        let skip = self.pageNumber * Constants.PAGINATION_PAGE_SIZE
        let limit = Constants.PAGINATION_PAGE_SIZE
        let status = self.bookingType.rawValue

        let params:[String:Any] = ["skip":skip,
                                   "limit":limit,
                                   "status":status]
        
        APIManager.sharedInstance.shipperAPIManager.AllBookings(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            
            if let bookingsCount = response["bookingsCount"] as? Int {self.totalBookings = bookingsCount}
            
            guard let bookings = response["bookings"] as? [[String:Any]] else {return}
            let arrBookings = Mapper<BookingModel>().mapArray(JSONArray: bookings)
            self.arrBookings.append(contentsOf: arrBookings)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
            print(error)
        }
    }
}
