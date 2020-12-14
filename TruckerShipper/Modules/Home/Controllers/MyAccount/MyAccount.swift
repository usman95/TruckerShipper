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
    
    var shipperProfile: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setProfileData()
        self.callAPIs()
        self.getUserDetails()
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
    private func setData(){
        let user = self.shipperProfile?.user
        
        self.tfFirstName.text = user?.firstName ?? ""
        self.tfLastName.text = user?.lastName ?? ""
        self.tfPhone.text = user?.contactNo ?? ""
        self.tfEmail.text = user?.email ?? ""
        self.tfNIC.text = user?.nicNo ?? ""
//        self.tfCountry.text = ""
//        self.tfCity.text = ""
        self.tfAddress.text = user?.address ?? ""
        self.tfShipperType.text = user?.shipperType ?? ""
        self.tfCompany.text = user?.company ?? ""
        self.tfNTN.text = user?.ntn ?? ""
        self.tfWebsite.text = user?.website ?? ""
    }
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
    private func setSelectedCountry(){
        let countryId = AppStateManager.sharedInstance.loggedInUser.user?.countryId?.id ?? ""
        
        self.selectedCountry = self.arrCountry.filter{$0.id == countryId}.first
        self.tfCountry.text = self.selectedCountry?.title ?? ""
    }
    private func setSelectedCity(){
        let cityId = AppStateManager.sharedInstance.loggedInUser.user?.cityId?.id ?? ""
        
        self.selectedCity = self.arrCity.filter{$0.id == cityId}.first
        self.tfCity.text = self.selectedCity?.title ?? ""
    }
    private func setSelectedShipperType(){
        let shipperType = AppStateManager.sharedInstance.loggedInUser.user?.shipperType
        
        self.selectedShipper = self.arrShipper.filter{$0 == shipperType}.first
        self.tfShipperType .text = self.selectedShipper
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
    private func setProfileData(){
        let data = AppStateManager.sharedInstance.loggedInUser.user
        
        self.tfFirstName.text = data?.firstName ?? ""
        self.tfLastName.text = data?.lastName ?? ""
        self.tfPhone.text = data?.contactNo ?? ""
        self.tfEmail.text = data?.email ?? ""
        
//        self.tfNIC.text = ""
        self.tfCountry.text = ""
        self.tfCity.text = ""
        self.tfAddress.text = data?.address ?? ""
//        self.tfShipperType.text = ""
//        self.tfCompany.text = ""
//        self.tfNTN.text = ""
//        self.tfWebsite.text = ""
        
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
        
        var params:[String:Any] = ["firstName":firstName,
                                   "lastName":lastName,
                                   "contactNo":contactNo,
                                   "email":email,
                                   "countryId":countryId,
                                   "cityId":cityId,
                                   "address":address,
                                   "shipperType":shipperType]
        if !nicNo.isEmpty{
            params["nicNo"] = nicNo
        }
        if !company.isEmpty{
            params["company"] = company
        }
        if !ntn.isEmpty{
            params["ntn"] = ntn
        }
        if !website.isEmpty{
            params["website"] = website
        }
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
            self.setSelectedCountry()
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
            self.setSelectedCity()
        }) { (error) in
            print(error)
        }
    }
    private func getShipperTypes(){
        APIManager.sharedInstance.usersAPIManager.ShipperTypes(success: { (responseObject) in
            guard let shipper = responseObject as? [String] else {return}
            self.arrShipper = shipper
            self.setShipperDropDown()
            self.setSelectedShipperType()
        }) { (error) in
            print(error)
        }
    }
    private func getUserDetails(){
        APIManager.sharedInstance.usersAPIManager.GetProfile(success: { (responseObject) in
            guard let user = Mapper<UserModel>().map(JSON: responseObject) else{return}
            self.shipperProfile = user
            self.setData()
        }) { (error) in
            print(error)
        }
    }
    private func updateProfile(){
        let id = AppStateManager.sharedInstance.loggedInUser.user?.id ?? ""
        
        guard let params = self.validate() else {return}
        print(params)
        
        APIManager.sharedInstance.usersAPIManager.UpdateProfile(id: id, params: params, success: { (responseObject) in
            guard let user = Mapper<UserModel>().map(JSON: responseObject) else{return}
            user.authToken = AppStateManager.sharedInstance.loggedInUser.authToken
            AppStateManager.sharedInstance.saveUser(user: user)
            Utility.main.showAlert(message: Strings.PROFILE_UPDATED.text, title: Strings.CONFIRMATION.text) {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
}
