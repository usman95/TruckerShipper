//
//  TripDetail.swift
//  TruckerShipper
//
//  Created by Mac Book on 15/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class TripDetail: BaseController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnTrackLocation: UIButtonDeviceClass!
    
    var bookingDetail: BookingDetailtModel?
    var trip: TripsModel?
    var tripMiles = List<TripMilesModel>()
    var inProgressMile: TripMilesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setTripMiles()
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
    private func setTripMiles(){
        self.tripMiles.removeAll()
        
        let tripMiles = self.trip?.tripMiles ?? List<TripMilesModel>()
        if !tripMiles.isEmpty{
            self.tripMiles.append(tripMiles.first ?? TripMilesModel())
        }
        
        for tripMile in tripMiles{
            self.tripMiles.append(tripMile)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
            return self.tripMiles.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailTVC", for: indexPath) as!  TripDetailTVC
            cell.setData(bookingDetail: self.bookingDetail, trip: self.trip)
            
            cell.btnCallDriver.addTarget(self, action: #selector(self.onBtnCallDriver(_:)), for: .touchUpInside)
            cell.btnMessageDriver.addTarget(self, action: #selector(self.onBtnMessageDriver(_:)), for: .touchUpInside)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MilesTVC", for: indexPath) as! MilesTVC
            let data = self.tripMiles[indexPath.row]
            cell.setData(data: data, index: indexPath.row)
            return cell
        }
    }
    
    @objc func onBtnCallDriver(_ sender: UIButton){
        guard let selectedTrip:TripsModel = self.bookingDetail?.trips.filter({$0.id == self.trip?.id}).first else {return}
        
        let selectedInProgressMile = selectedTrip.tripMiles.filter{$0.status == MileType.inProgress.rawValue}.first
        let selectedPendingMile = selectedTrip.tripMiles.filter{$0.status == MileType.pending.rawValue}.first
        let selectedCompletedMile = selectedTrip.tripMiles.filter{$0.status == MileType.completed.rawValue}.first
        
        if selectedInProgressMile != nil{
            let phoneNumber = selectedInProgressMile?.driverId?.contactNo ?? ""
            Utility.main.makeCallTo(number: phoneNumber)
            return
        }
        if selectedPendingMile != nil{
            let phoneNumber = selectedPendingMile?.driverId?.contactNo ?? ""
            Utility.main.makeCallTo(number: phoneNumber)
            return
        }
        if selectedCompletedMile != nil{
            let phoneNumber = selectedCompletedMile?.driverId?.contactNo ?? ""
            Utility.main.makeCallTo(number: phoneNumber)
            return
        }
    }
    @objc func onBtnMessageDriver(_ sender: UIButton){
        guard let selectedTrip:TripsModel = self.bookingDetail?.trips.filter({$0.id == self.trip?.id}).first else {return}
        
        let selectedInProgressMile = selectedTrip.tripMiles.filter{$0.status == MileType.inProgress.rawValue}.first
        let selectedPendingMile = selectedTrip.tripMiles.filter{$0.status == MileType.pending.rawValue}.first
        let selectedCompletedMile = selectedTrip.tripMiles.filter{$0.status == MileType.completed.rawValue}.first
        
        if selectedInProgressMile != nil{
            let phoneNumber = selectedInProgressMile?.driverId?.contactNo ?? ""
            Utility.main.sendSMS(number: phoneNumber)
            return
        }
        if selectedPendingMile != nil{
            let phoneNumber = selectedPendingMile?.driverId?.contactNo ?? ""
            Utility.main.sendSMS(number: phoneNumber)
            return
        }
        if selectedCompletedMile != nil{
            let phoneNumber = selectedCompletedMile?.driverId?.contactNo ?? ""
            Utility.main.sendSMS(number: phoneNumber)
            return
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
            if let selectedTrip:TripsModel = self.bookingDetail?.trips.filter({$0.id == self.trip?.id}).first {
                self.trip = selectedTrip
                self.setTripMiles()
            }
            
            DispatchQueue.main.async {
                self.setData()
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
