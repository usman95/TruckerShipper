//
//  BookingDocuments+Extension.swift
//  TruckerShipper
//
//  Created by Mac Book on 14/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import MobileCoreServices

extension BookingDocuments{
    func uploadFromiCloudDrive(){
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    func uploadFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    func uploadFromGallery(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    func uploadDocumentBy(){
        let alert = UIAlertController(title: Strings.ASK_UPLOAD_DOCMENT_IMAGE_VIA.text , message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "iCloud", style: .default, handler: { (UIAlertAction) in
            self.uploadFromiCloudDrive()
        }))
        alert.addAction(UIAlertAction(title: Strings.CAMERA.text, style: .default, handler: { (UIAlertAction) in
            self.uploadFromCamera()
        }))
        alert.addAction(UIAlertAction(title: Strings.GALLERY.text, style: .default, handler: { (UIAlertAction) in
            self.uploadFromGallery()
        }))
        alert.addAction(UIAlertAction(title: Strings.CANCEL.text, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
//MARK:- UIImagePickerControllerDelegate
extension BookingDocuments: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                guard let imageData: NSData = NSData(data: pickedImage.jpegData(compressionQuality: 0.5)!) as NSData? else{return}
                self.data = imageData as Data
                self.uploadDocument()
            }
            else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                guard let imageData: NSData = NSData(data: pickedImage.jpegData(compressionQuality: 0.5)!) as NSData? else{return}
                self.data = imageData as Data
                self.uploadDocument()
            }
        })
    }
}
//MARK: - Document Picker
extension BookingDocuments: UIDocumentPickerDelegate,UIDocumentMenuDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController){
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL){
        let fileManager = FileManager.default
        print(fileManager.fileExists(atPath: url.path))
        let data = NSData(contentsOfFile: url.path)
        guard let doc = data else {
            Utility.main.showToast(message: "Document format not supported!")
            return
        }
        self.data = doc as Data
        self.uploadDocument()
//        let file = UploadFileData(fileName: "\(url)", fileType: .file, fileData: doc)
//        self.addDocumentIfNotExist(file: file)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController){
        print("we cancelled")
        dismiss(animated: true, completion: nil)
    }
}
