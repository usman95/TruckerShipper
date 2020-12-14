//
//  BookingDocuments.swift
//  TruckerShipper
//
//  Created by Mac Book on 14/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class BookingDocuments: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    var booking: BookingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        // Do any additional setup after loading the view.
    }

}
//MARK:- Helper methods
extension BookingDocuments{
    private func registerCells(){
        self.tableView.register(UINib(nibName: "BookingDocumentTVC", bundle: nil), forCellReuseIdentifier: "BookingDocumentTVC")
    }
}
extension BookingDocuments: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.booking?.documents.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDocumentTVC", for: indexPath) as! BookingDocumentTVC
        let data = self.booking?.documents[indexPath.row] ?? DocumentModel()
        cell.setData(data: data)
        return cell
    }
}
