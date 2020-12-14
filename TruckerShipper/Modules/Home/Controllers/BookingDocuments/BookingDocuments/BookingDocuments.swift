//
//  BookingDocuments.swift
//  TruckerShipper
//
//  Created by Mac Book on 14/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper

class BookingDocuments: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    var booking: BookingModel?
    var selectedDocument: DocumentModel?
    var data: Data?
    
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
//MARK:- UITableViewDataSource
extension BookingDocuments: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.booking?.documents.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDocumentTVC", for: indexPath) as! BookingDocumentTVC
        let data = self.booking?.documents[indexPath.row] ?? DocumentModel()
        cell.setData(data: data, index: indexPath.row)
        
        cell.btnViewDocument.tag = indexPath.row
        cell.btnUploadDocument.tag = indexPath.row
        
        cell.btnViewDocument.addTarget(self, action: #selector(self.onBtnViewDocument(_:)), for: .touchUpInside)
        cell.btnUploadDocument.addTarget(self, action: #selector(self.onBtnUploadDocument(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onBtnViewDocument(_ sender:UIButton){
        let fileURLString = self.booking?.documents[sender.tag].url
        super.pushToWebView(fileURLString: fileURLString)
    }
    @objc func onBtnUploadDocument(_ sender:UIButton){
        self.selectedDocument = self.booking?.documents[sender.tag]
        self.uploadDocumentBy()
    }
}
//MARK:- Services
extension BookingDocuments{
    func uploadDocument(){
        let id = booking?.id ?? ""
        
        let doc = self.data ?? Data()
        let docId = self.selectedDocument?.id ?? ""
        
        let params:[String:Any] = ["doc":doc,
                                   "docId":docId]
        APIManager.sharedInstance.shipperAPIManager.UploadDocument(id: id, params: params, success: { (responseObject) in
            self.booking = Mapper<BookingModel>().map(JSON: responseObject)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
}
