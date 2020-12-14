//
//  User.swift
//
//  Created by Hamza Hasan on 03/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class User: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let cityId = "cityId"
        static let email = "email"
        static let createdAt = "createdAt"
        static let address = "address"
        static let lastName = "lastName"
        static let isEmailVerified = "isEmailVerified"
        static let roleId = "roleId"
        static let isActivated = "isActivated"
        static let updatedBy = "updatedBy"
        static let id = "_id"
        static let isDeleted = "isDeleted"
        static let contactNo = "contactNo"
        static let updatedAt = "updatedAt"
        static let firstName = "firstName"
        static let countryId = "countryId"
        static let createdBy = "createdBy"
        static let shipperType = "shipperType"
        static let nicNo = "nicNo"
        static let company = "company"
        static let ntn = "ntn"
        static let website = "website"
        static let profileImageUrl = "profileImageUrl"
        static let documents = "documents"
        
    }
    
    // MARK: Properties
    @objc dynamic var cityId: AttributeModel?
    @objc dynamic var email: String? = ""
    @objc dynamic var createdAt: String? = ""
    @objc dynamic var address: String? = ""
    @objc dynamic var lastName: String? = ""
    @objc dynamic var isEmailVerified = false
    @objc dynamic var roleId: RoleId?
    @objc dynamic var isActivated = false
    @objc dynamic var updatedBy: UpdatedBy?
    @objc dynamic var id: String? = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var contactNo: String? = ""
    @objc dynamic var updatedAt: String? = ""
    @objc dynamic var firstName: String? = ""
    @objc dynamic var countryId: AttributeModel?
    @objc dynamic var createdBy: CreatedByModel?
    @objc dynamic var shipperType: String? = ""
    @objc dynamic var nicNo: String? = ""
    @objc dynamic var company: String? = ""
    @objc dynamic var ntn: String? = ""
    @objc dynamic var website: String? = ""
    @objc dynamic var profileImageUrl: String? = ""
    var documents = List<DocumentModel>()
    
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    
    required convenience public init?(map : Map){
        self.init()
    }
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public func mapping(map: Map) {
        cityId <- map[SerializationKeys.cityId]
        email <- map[SerializationKeys.email]
        createdAt <- map[SerializationKeys.createdAt]
        address <- map[SerializationKeys.address]
        lastName <- map[SerializationKeys.lastName]
        isEmailVerified <- map[SerializationKeys.isEmailVerified]
        roleId <- map[SerializationKeys.roleId]
        isActivated <- map[SerializationKeys.isActivated]
        updatedBy <- map[SerializationKeys.updatedBy]
        id <- map[SerializationKeys.id]
        isDeleted <- map[SerializationKeys.isDeleted]
        contactNo <- map[SerializationKeys.contactNo]
        updatedAt <- map[SerializationKeys.updatedAt]
        firstName <- map[SerializationKeys.firstName]
        countryId <- map[SerializationKeys.countryId]
        createdBy <- map[SerializationKeys.createdBy]
        shipperType <- map[SerializationKeys.shipperType]
        nicNo <- map[SerializationKeys.nicNo]
        company <- map[SerializationKeys.company]
        ntn <- map[SerializationKeys.ntn]
        website <- map[SerializationKeys.website]
        profileImageUrl <- map[SerializationKeys.profileImageUrl]
        documents <- (map[SerializationKeys.documents], ListTransform<DocumentModel>())
    }
    
    
}
