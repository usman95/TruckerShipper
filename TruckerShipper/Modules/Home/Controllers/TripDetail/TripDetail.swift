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
    var inProgressMile: TripMilesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getBookingDetail()
    }
    
    @IBAction func onBtnTrackLocation(_ sender: UIButtonDeviceClass) {
        super.pushToTrackLocation(inProgressMile: self.inProgressMile)
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
    private func setData(){
        guard let selectedTrip:TripsModel = self.bookingDetail?.trips.filter({$0.id == self.trip?.id}).first else {return}
        let selectedInProgressMile = selectedTrip.tripMiles.filter{$0.status == MileType.inProgress.rawValue}.first
        
        if let inProgressMile = selectedInProgressMile{
            self.inProgressMile = inProgressMile
            self.btnTrackLocation.isHidden = false
        }
        else{
            self.btnTrackLocation.isHidden = true
        }
    }
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
            self.setData()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
