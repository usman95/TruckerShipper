//
//  MyContracts.swift
//  TruckerShipper
//
//  Created by Mac Book on 07/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class MyContracts: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        // Do any additional setup after loading the view.
    }
}
//MARK:- Helper methods
extension MyContracts{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "MyContractsTVC", bundle: nil), forCellReuseIdentifier: "MyContractsTVC")
    }
}
//MARK:- UITableViewDataSource
extension MyContracts: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyContractsTVC", for: indexPath)
        return cell
    }
}
//MARK:- UITableViewDelegate
extension MyContracts: UITableViewDelegate{
    
}
