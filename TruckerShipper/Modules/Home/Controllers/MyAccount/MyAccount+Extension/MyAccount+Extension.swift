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
        })
    }
}
