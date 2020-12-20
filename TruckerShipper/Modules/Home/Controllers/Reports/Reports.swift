//
//  Reports.swift
//  TruckerShipper
//
//  Created by Mac Book on 19/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit

class Reports: BaseController {

    @IBOutlet weak var tfStartDate: UITextFieldDeviceClass!
    @IBOutlet weak var tfEndDate: UITextFieldDeviceClass!
    
    var reportDatePickerType = ReportDateType.start
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    
    @IBAction func onTfStartDate(_ sender: UITextField) {
        self.reportDatePickerType = .start
        self.setDate(date: self.selectedStartDate ?? Date())
        self.getPickedDate(sender)
    }
    @IBAction func onTfEndDate(_ sender: UITextField) {
        self.reportDatePickerType = .end
        self.setDate(date: self.selectedStartDate ?? self.selectedEndDate ?? Date())
        self.getPickedDate(sender)
    }
}
//MARK:- Date Picker
extension Reports{
    private func getPickedDate(_ sender: UITextField){
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        
        switch self.reportDatePickerType{
        case .start:
            datePickerView.date = self.selectedStartDate ?? Date()
        case .end:
            datePickerView.minimumDate = self.selectedStartDate ?? Date()
            datePickerView.date = self.selectedEndDate ?? Date()
        }
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        self.setDate(date: sender.date)
    }
    private func setDate(date:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        switch self.reportDatePickerType{
        case .start:
            self.selectedStartDate = date
            self.selectedEndDate = nil
            
            self.tfStartDate.text = dateFormatter.string(from: date)
            self.tfEndDate.text = nil
        case .end:
            self.selectedEndDate = date
            
            self.tfEndDate.text = dateFormatter.string(from: date)
        }
    }
}
