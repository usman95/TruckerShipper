//
//  Trips.swift
//  TruckerShipper
//
//  Created by Mac Book on 15/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class Trips: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    var booking: BookingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.getBookingDetail()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper methods
extension Trips{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "MyContractsTVC", bundle: nil), forCellReuseIdentifier: "MyContractsTVC")
    }
}
//MARK:- UITableViewDataSource
extension Trips: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyContractsTVC", for: indexPath)
        return cell
    }
}
//MARK:- UITableViewDelegate
extension Trips: UITableViewDelegate{
    private func getBookingDetail(){
        let id = self.booking?.id ?? ""
        
        APIManager.sharedInstance.shipperAPIManager.BookingDetails(id: id, success: { (responseObject) in
            print(responseObject)
        }) { (error) in
            print(error)
        }
    }
}
