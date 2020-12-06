//
//  MyAccount.swift
//  TruckerShipper
//
//  Created by Mac Book on 05/12/2020.
//  Copyright © 2020 Mac Book. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown
import GooglePlaces

class MyAccount: BaseController {
    
    @IBOutlet weak var tfFirstName: UITextFieldDeviceClass!
    @IBOutlet weak var tfLastName: UITextFieldDeviceClass!
    @IBOutlet weak var tfPhone: UITextFieldDeviceClass!
    @IBOutlet weak var tfEmail: UITextFieldDeviceClass!
    @IBOutlet weak var tfNIC: UITextFieldDeviceClass!
    @IBOutlet weak var tfCountry: UITextFieldDeviceClass!
    @IBOutlet weak var tfCity: UITextFieldDeviceClass!
    @IBOutlet weak var tfAddress: UITextFieldDeviceClass!
    @IBOutlet weak var tfShipperType: UITextFieldDeviceClass!
    @IBOutlet weak var tfCompany: UITextFieldDeviceClass!
    @IBOutlet weak var tfNTN: UITextFieldDeviceClass!
    @IBOutlet weak var tfWebsite: UITextFieldDeviceClass!
    @IBOutlet weak var btnSaveProfile: UIButtonDeviceClass!
    
    let countriesDropDown = DropDown()
    var arrCountry = [AttributeModel]()
    var selectedCountry: AttributeModel?
    
    let citiesDropDown = DropDown()
    var arrAllCity = [AttributeModel]()
    var arrCity = [AttributeModel]()
    var selectedCity: AttributeModel?
    
    let shipperDropDown = DropDown()
    var arrShipper = [String]()
    var selectedShipper: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callAPIs()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBtnCountry(_ sender: UIButton) {
        self.countriesDropDown.show()
    }
    @IBAction func onBtnCity(_ sender: UIButton) {
        self.citiesDropDown.show()
    }
    @IBAction func onBtnShipperType(_ sender: UIButton) {
        self.shipperDropDown.show()
    }
    @IBAction func onBtnAddress(_ sender: UIButton) {
        self.pickLocationFromPlacePicker()
    }
    @IBAction func onBtnSaveProfile(_ sender: UIButton) {
        self.updateProfile()
    }
}
//MARK:- Helper methods
extension MyAccount{
    private func callAPIs(){
        self.getCountries()
        self.getCities()
        self.getShipperTypes()
    }
    private func setCountriesDropDown(){
        self.countriesDropDown.dataSource = self.arrCountry.map{$0.title ?? ""}
        self.countriesDropDown.anchorView = self.tfCountry
        self.countriesDropDown.cellHeight = self.tfCountry.frame.height
        self.countriesDropDown.width = self.tfCountry.frame.width
        self.countriesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfCountry.text = item
            self.selectedCountry = self.arrCountry[index]
            
            self.resetCities()
        }
    }
    private func setCitiesDropDown(){
        self.citiesDropDown.dataSource = self.arrCity.map{$0.title ?? ""}
        self.citiesDropDown.anchorView = self.tfCity
        self.citiesDropDown.cellHeight = self.tfCity.frame.height
        self.citiesDropDown.width = self.tfCity.frame.width
        self.citiesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfCity.text = item
            self.selectedCity = self.arrCity[index]
        }
    }
    private func setShipperDropDown(){
        self.shipperDropDown.dataSource = self.arrShipper
        self.shipperDropDown.anchorView = self.tfShipperType
        self.shipperDropDown.cellHeight = self.tfShipperType.frame.height
        self.shipperDropDown.width = self.tfShipperType.frame.width
        self.shipperDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfShipperType.text = item
            self.selectedShipper = item
        }
    }
    private func resetCities(){
        self.tfCity.text = nil
        self.selectedCity = nil
        self.getCities()
    }
    private func pickLocationFromPlacePicker(){
        let controller = GMSAutocompleteViewController()
        controller.delegate = self
        
        controller.secondaryTextColor = UIColor.lightGray
        controller.tableCellSeparatorColor = UIColor.lightGray
        controller.tableCellBackgroundColor = UIColor.white
            
        self.present(controller, animated: true, completion: nil)
    }
    private func validate()->[String:Any]?{
        let firstName = self.tfFirstName.text ?? ""
        let lastName = self.tfLastName.text ?? ""
        let contactNo = self.tfPhone.text ?? ""
        let email = self.tfEmail.text ?? ""
        let nicNo = self.tfNIC.text ?? ""
        let countryId = self.selectedCountry?.id ?? ""
        let cityId = self.selectedCity?.id ?? ""
        let address = self.tfAddress.text ?? ""
        let shipperType = self.selectedShipper ?? ""
        let company = self.tfCompany.text ?? ""
        let ntn = self.tfNTN.text ?? ""
        let website  = self.tfWebsite.text ?? ""
        
        if !Validation.isValidName(firstName){
            Utility.main.showToast(message: Strings.INVALID_F_NAME.text)
            self.btnSaveProfile.shake()
            return nil
        }
        if !Validation.isValidName(lastName){
            Utility.main.showToast(message: Strings.INVALID_L_NAME.text)
            self.btnSaveProfile.shake()
            return nil
        }
        if !Validation.isValidNumber(contactNo){
            Utility.main.showToast(message: Strings.INVALID_PHONE.text)
            self.btnSaveProfile.shake()
            return nil
        }
        if !Validation.isValidEmail(email){
            Utility.main.showToast(message: Strings.INVALID_EMAIL.text)
            self.btnSaveProfile.shake()
            return nil
        }
        if !Validation.validateStringLength(address){
            Utility.main.showToast(message: Strings.ENTER_ADDRESS.text)
            self.btnSaveProfile.shake()
            return nil
        }
        
        if !Validation.validateStringLength(shipperType){
            Utility.main.showToast(message: Strings.SELECT_SHIPPER.text)
            self.btnSaveProfile.shake()
            return nil
        }
        
        
        let params:[String:Any] = ["firstName":firstName,
                                   "lastName":lastName,
                                   "contactNo":contactNo,
                                   "email":email,
                                   "nicNo":nicNo,
                                   "countryId":countryId,
                                   "cityId":cityId,
                                   "address":address,
                                   "shipperType":shipperType,
                                   "company":company,
                                   "ntn":ntn,
                                   "website":website]
        return params
    }
}
//MARK:- GMSAutocompleteViewControllerDelegate
extension MyAccount: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.tfAddress.text = place.formattedAddress
            }
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        Utility.main.showToast(message: "Error: "+error.localizedDescription)
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {}
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {}
}
//MARK:- Services
extension MyAccount{
    private func getCountries(){
        let skip = "0"
        let limit = "1000"
        
        let params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        
        APIManager.sharedInstance.attributesAPIManager.Country(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let countries = response["countries"] as? [[String:Any]] else {return}
            self.arrCountry = Mapper<AttributeModel>().mapArray(JSONArray: countries)
            self.setCountriesDropDown()
        }) { (error) in
            print(error)
        }
    }
    private func getCities(){
        let skip = "0"
        let limit = "1000"
        let countryId = self.selectedCountry?.id ?? ""
        
        var params:[String:Any] = ["skip":skip,
                                   "limit":limit]
        if !countryId.isEmpty{params["countryId"] = countryId}
        
        APIManager.sharedInstance.attributesAPIManager.City(params: params, success: { (responseObject) in
            let response = responseObject as Dictionary
            guard let cities = response["cities"] as? [[String:Any]] else {return}
            self.arrAllCity = Mapper<AttributeModel>().mapArray(JSONArray: cities)
            self.arrCity = Mapper<AttributeModel>().mapArray(JSONArray: cities)
            self.setCitiesDropDown()
        }) { (error) in
            print(error)
        }
    }
    private func getShipperTypes(){
        APIManager.sharedInstance.usersAPIManager.ShipperTypes(success: { (responseObject) in
            guard let shipper = responseObject as? [String] else {return}
            self.arrShipper = shipper
            self.setShipperDropDown()
        }) { (error) in
            print(error)
        }
    }
    private func updateProfile(){
        let id = AppStateManager.sharedInstance.loggedInUser.user?.id ?? ""
        
        guard let params = self.validate() else {return}
        print(params)
        
        APIManager.sharedInstance.usersAPIManager.UpdateProfile(id: id, params: params, success: { (responseObject) in
            print(responseObject)
        }) { (error) in
            print(error)
        }
    }
}
