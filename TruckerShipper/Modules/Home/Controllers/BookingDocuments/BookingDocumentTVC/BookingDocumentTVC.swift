//
//  BookingDocumentTVC.swift
//  TruckerShipper
//
//  Created by Mac Book on 14/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class BookingDocumentTVC: UITableViewCell {

    @IBOutlet weak var lblDocumentType: UILabelDeviceClass!
    @IBOutlet weak var btnViewDocument: UIButton!
    @IBOutlet weak var btnUploadDocument: UIButton!
    
    func setData(data: DocumentModel, index: Int){
        self.lblDocumentType.text = "\(index+1). \(data.docType ?? "")"
        self.btnViewDocument.isHidden = (data.url ?? "").isEmpty 
    }
}
