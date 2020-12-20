//
//  MyContracts.swift
//  TruckerShipper
//
//  Created by Mac Book on 07/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper
import DZNEmptyDataSet

class MyContracts: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var arrContracts = [ContractModel]()
    var totalContracts = 0
    var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.getMyContracts()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper methods
extension MyContracts{
    private func setUI(){
        self.tableView.emptyDataSetSource = self
        self.registerCells()
        self.pullToRefresh()
    }
    private func registerCells(){
        self.tableView.register(UINib(nibName: "MyContractsTVC", bundle: nil), forCellReuseIdentifier: "MyContractsTVC")
    }
    
    private func pullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refreshBookings), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    @objc func refreshBookings() {
        self.pageNumber = 0
        self.arrContracts.removeAll()
        self.tableView.reloadData()
        self.getMyContracts()
    }
}
//MARK:- UITableViewDataSource
extension MyContracts: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrContracts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyContractsTVC", for: indexPath) as! MyContractsTVC
        let data = self.arrContracts[indexPath.row]
        cell.setData(data: data)
        return cell
    }
}
//MARK:- UITableViewDelegate
extension MyContracts: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if tableView.visibleCells.contains(cell) {
                if indexPath.row == self.arrContracts.count - 1{
                    self.loadMoreCells()
                }
            }
        }
    }
    
    private func loadMoreCells(){
        if self.totalContracts != self.arrContracts.count{
            self.pageNumber += 1
            self.getMyContracts()
        }
    }
}
//MARK:- DZNEmptyDataSetSource
extension MyContracts: DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = Strings.NO_DATA_AVAILABLE.text
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
//MARK:- Services
extension MyContracts{
    private func getMyContracts(){
        let skip = self.pageNumber * Constants.PAGINATION_PAGE_SIZE
        let limit = Constants.PAGINATION_PAGE_SIZE
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.shipperAPIManager.ShipperContracts(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            
            if let contractsCount = response["shipperContractsCount"] as? Int {self.totalContracts = contractsCount}
            
            guard let contracts = response["shipperContracts"] as? [[String:Any]] else {return}
            let arrContracts = Mapper<ContractModel>().mapArray(JSONArray: contracts)
            self.arrContracts.append(contentsOf: arrContracts)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
            print(error)
        }
    }
}
