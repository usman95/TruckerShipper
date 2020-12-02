//
//  TripExpenses.swift
//  TruckerDriver
//
//  Created by Mac Book on 16/11/2020.
//  Copyright © 2020 Marine group. All rights reserved.
//

import UIKit

class TripExpenses: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        // Do any additional setup after loading the view.
    }
}
//MARk:- Helper Methods
extension TripExpenses{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "TripExpenseDetailTVC", bundle: nil), forCellReuseIdentifier: "TripExpenseDetailTVC")
        self.tableView.register(UINib(nibName: "TripExpensesTVC", bundle: nil), forCellReuseIdentifier: "TripExpensesTVC")
    }
}
//MARK:- UITableViewDataSource
extension TripExpenses: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 10
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripExpenseDetailTVC", for: indexPath) as! TripExpenseDetailTVC
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripExpensesTVC", for: indexPath) as! TripExpensesTVC
            return cell
        }
    }
}
//MARK:- UITableViewDataSource
extension TripExpenses: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 40
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            let header = TripExpensesHeader.instanceFromNib()
            return header
        }
    }
}
