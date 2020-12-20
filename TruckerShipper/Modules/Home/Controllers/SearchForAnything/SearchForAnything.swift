//
//  SearchForAnything.swift
//  TruckerShipper
//
//  Created by Mac Book on 20/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper
import DZNEmptyDataSet

class SearchForAnything: BaseController {

    @IBOutlet weak var lblTitle: UILabelDeviceClass!
    @IBOutlet weak var tfSearchForAnything: UITextFieldDeviceClass!
    @IBOutlet weak var tableView: UITableView!
    
    var searchType = SearchType.search
    var arrBookings = [BookingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTfSearchForAnything(_ sender: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.searchBookings()
        }
    }
    @IBAction func onBtnClearSearchRecords(_ sender: UIButton) {
        self.refreshBookings()
    }
}
//MARK:- Helper methods
extension SearchForAnything{
    private func setUI(){
        switch self.searchType {
        case .search:
            self.lblTitle.text = Strings.SEARCH_FOR_ANYTHING.text.uppercased()
        case .shipmentTracking:
            self.lblTitle.text = Strings.SHIPMENT_TRACKING.text.uppercased()
        }
        
        self.tableView.emptyDataSetSource = self
        self.registerCells()
    }
    private func registerCells(){
        self.tableView.register(UINib(nibName: "BookingsTVC", bundle: nil), forCellReuseIdentifier: "BookingsTVC")
    }
    private func refreshBookings(){
        self.tfSearchForAnything.text = nil
        self.arrBookings.removeAll()
        self.tableView.reloadData()
    }
}
//MARK:- UITableViewDataSource
extension SearchForAnything: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBookings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTVC", for: indexPath) as! BookingsTVC
        let data = self.arrBookings[indexPath.row]
        cell.setData(data: data)
        
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
//MARK:- DZNEmptyDataSetSource
extension SearchForAnything: DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = Strings.NO_DATA_AVAILABLE.text
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
//MARK:- Services
extension SearchForAnything{
    private func searchBookings(){
        let searchText = self.tfSearchForAnything.text ?? ""
        if searchText.isEmpty{
            self.refreshBookings()
            return
        }
        if searchText.count < 3{
            return
        }

        let params:[String:Any] = ["searchText":searchText]
        
        APIManager.sharedInstance.shipperAPIManager.BookingSearch(params: params, success: { (responseObject) in
            print(responseObject)
            guard let bookings = responseObject as? [[String:Any]] else {return}
            self.arrBookings = Mapper<BookingModel>().mapArray(JSONArray: bookings)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
