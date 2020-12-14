//
//  MyAccount+Extension.swift
//  TruckerShipper
//
//  Created by Mac Book on 15/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import MobileCoreServices

extension MyAccount{
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
    func uploadProfileImageBy(){
        let alert = UIAlertController(title: Strings.ASK_UPLOAD_DOCMENT_IMAGE_VIA.text , message: "", preferredStyle: .actionSheet)
        
        if self.imagePickerType == .ntn{
            alert.addAction(UIAlertAction(title: "iCloud", style: .default, handler: { (UIAlertAction) in
                self.uploadFromiCloudDrive()
            }))
        }
        
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
extension MyAccount: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        self.dismiss(animated: true, completion: {
            switch self.imagePickerType{
            case .profile:
                if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    self.profileImage = pickedImage
                    self.imgProfile.image = pickedImage
                    self.uploadProfile()
                }
                if self.profileImage == nil{
                    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                        self.profileImage = pickedImage
                        self.imgProfile.image = pickedImage
                        self.uploadProfile()
                    }
                }
            case .ntn:
                if let ntnImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    guard let imageData: NSData = NSData(data: ntnImage.jpegData(compressionQuality: 0.5)!) as NSData? else{return}
                    self.uploadNTN(doc: imageData as Data)
                }
                else{
                    if let ntnImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                        guard let imageData: NSData = NSData(data: ntnImage.jpegData(compressionQuality: 0.5)!) as NSData? else{return}
                        self.uploadNTN(doc: imageData as Data)
                    }
                }
            }
        })
    }
}
//MARK: - Document Picker
extension MyAccount: UIDocumentPickerDelegate,UIDocumentMenuDelegate{
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
        self.uploadNTN(doc: doc as Data)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController){
        print("we cancelled")
        dismiss(animated: true, completion: nil)
    }
}
