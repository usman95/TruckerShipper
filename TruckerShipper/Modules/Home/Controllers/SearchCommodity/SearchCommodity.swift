//
//  SearchCommodity.swift
//  TruckerShipper
//
//  Created by Mac Book on 24/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchCommodity: BaseController {
    
    @IBOutlet weak var tfSearch: UITextFieldDeviceClass!
    
    var arrCommodity = [AttributeModel]()
    var arrFilteredCommodity = [AttributeModel]()
    var isFilter = false
    
    var setSelectedCommodity: ((AttributeModel?)->Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCommodity()
        self.registerCells()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTfSearch(_ sender: UITextFieldDeviceClass) {
        let searchText = sender.text ?? ""
        if searchText.isEmpty{
            self.isFilter = false
        }
        else{
            self.isFilter = true
            self.arrFilteredCommodity = self.arrCommodity.filter{($0.title ?? "").localizedCaseInsensitiveContains(searchText)}
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @IBAction func onBtnClose(_ sender: UIButton) {
        self.tfSearch.text = nil
        self.isFilter = false
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
//MARK:- Helper methods
extension SearchCommodity{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "SearchCommodityTVC", bundle: nil), forCellReuseIdentifier: "SearchCommodityTVC")
    }
}
//MARK:- UITableViewDataSource
extension SearchCommodity: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.isFilter{
        case true:
            return self.arrFilteredCommodity.count
        case false:
            return self.arrCommodity.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCommodityTVC", for: indexPath) as! SearchCommodityTVC
        switch self.isFilter{
        case true:
            let data = self.arrFilteredCommodity[indexPath.row]
            cell.setData(data: data)
        case false:
            let data = self.arrCommodity[indexPath.row]
            cell.setData(data: data)
        }
        return cell
    }
}
//MARK:- UITableViewDelegate
extension SearchCommodity: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        
        switch self.isFilter{
        case true:
            let selectedCommodity = self.arrFilteredCommodity[indexPath.row]
            self.setSelectedCommodity?(selectedCommodity)
        case false:
            let selectedCommodity = self.arrCommodity[indexPath.row]
            self.setSelectedCommodity?(selectedCommodity)
        }
        
    }
}
extension SearchCommodity{
    private func getCommodity(){
        if !self.arrCommodity.isEmpty{
            self.tableView.reloadData()
            return
        }
        
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.Commodity(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let commodities = response["commodities"] as? [[String:Any]] else {return}
            self.arrCommodity = Mapper<AttributeModel>().mapArray(JSONArray: commodities)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
