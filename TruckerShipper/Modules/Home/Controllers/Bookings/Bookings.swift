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
    @IBOutlet weak var btnCancelled: UIButtonStatesDeviceClass!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var bookingType = BookingType.pending
    var refreshControl = UIRefreshControl()
    var arrBookings = [BookingModel]()
    var totalBookings = 0
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setBookingStatusUI()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollToItem()
    }
    
    @IBAction func onBtnBookingsStatus(_ sender: UIButtonStatesDeviceClass) {
        switch sender.tag {
        case 0:
            self.bookingType = BookingType.pending
        case 1:
            self.bookingType = BookingType.inProgress
        case 2:
            self.bookingType = BookingType.completed
        case 3:
            self.bookingType = BookingType.rejected
            
        default:
            self.bookingType = BookingType.cancelled
        }
        self.setBookingStatusUI()
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
    private func setBookingStatusUI(){
        switch self.bookingType{
        case .pending:
            self.btnPending.isSelected = true
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = false
            self.btnCancelled.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
        case .inProgress:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = true
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = false
            self.btnCancelled.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
        case .completed:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = true
            self.btnRejected.isSelected = false
            self.btnCancelled.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
        case .rejected:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = true
            self.btnCancelled.isSelected = false
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
            
        case .cancelled:
            self.btnPending.isSelected = false
            self.btnInProgress.isSelected = false
            self.btnCompleted.isSelected = false
            self.btnRejected.isSelected = false
            self.btnCancelled.isSelected = true
            
            self.arrBookings.removeAll()
            self.tableView.reloadData()
        default:
            break
        }
        self.scrollToItem()
        self.refreshBookings()
    }
    private func scrollToItem(){
        switch self.bookingType{
            
        case .pending:
            let frame = CGRect(x: 0, y: 0, width: self.btnPending.frame.width, height: self.btnPending.frame.height)
            self.scrollView.scrollRectToVisible(frame, animated: true)
        case .inProgress:
            let frame = CGRect(x: self.btnInProgress.frame.width, y: 0, width: self.btnInProgress.frame.width, height: self.btnInProgress.frame.height)
            self.scrollView.scrollRectToVisible(frame, animated: true)
        case .completed:
            let frame = CGRect(x: self.btnCompleted.center.x, y: 0, width: self.btnCompleted.frame.width, height: self.btnCompleted.frame.height)
            self.scrollView.scrollRectToVisible(frame, animated: true)
        case .rejected:
            let frame = CGRect(x: self.btnRejected.center.x, y: 0, width: self.btnRejected.frame.width, height: self.btnRejected.frame.height)
            self.scrollView.scrollRectToVisible(frame, animated: true)
        case .cancelled:
            let frame = CGRect(x: self.btnCancelled.center.x, y: 0, width: self.btnCancelled.frame.width, height: self.btnCancelled.frame.height)
            self.scrollView.scrollRectToVisible(frame, animated: true)
        default:
            break
        }
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
        cell.setData(data: data, isSearched: false)
        
        cell.btnViewTrips.tag = indexPath.row
        cell.btnAddDocuments.tag = indexPath.row
        
        cell.btnViewTrips.addTarget(self, action: #selector(self.onBtnViewTrips(_:)), for: .touchUpInside)
        cell.btnAddDocuments.addTarget(self, action: #selector(self.onBtnViewAddDocuments(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onBtnViewTrips(_ sender:UIButton){
        let booking = self.arrBookings[sender.tag]
        
        if booking.status == BookingType.pending.rawValue{
            Utility.main.showAlert(message: Strings.ASK_TO_CANCEL_NOTIFICATION.text, title: Strings.CONFIRMATION.text, YES: Strings.YES.text, NO: Strings.NO.text) { (yes, no) in
                if yes != nil{
                    let index = sender.tag
                    let id = self.arrBookings[index].id ?? ""
                    self.cancelBooking(id: id, index: index)
                }
            }
        }
        else{
            super.pushToTrips(booking: booking)
        }
    }
    @objc func onBtnViewAddDocuments(_ sender:UIButton){
        let booking = self.arrBookings[sender.tag]
        super.pushToBookingDocuments(booking: booking)
    }
}
//MARK:- UITableViewDelegate
extension Bookings: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
        let shipperId = AppStateManager.sharedInstance.loggedInUser.user?.id ?? ""
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit,
                                   "status":status,
                                   "shipperId":shipperId]
        
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
    private func cancelBooking(id: String, index: Int){
        let status = BookingType.cancelled.rawValue
        let param:[String:Any] = ["status":status]
        
        APIManager.sharedInstance.shipperAPIManager.BookingStatus(id: id, params: param, success: { (responseObject) in
            self.arrBookings.remove(at: index)
            
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
            }
        }) { (error) in
            print(error)
        }
    }
}
