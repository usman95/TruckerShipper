//
//  DriverId.swift
//
//  Created by Hamza Hasan on 15/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class DriverIdModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "_id"
        static let email = "email"
        static let address = "address"
        static let lastName = "lastName"
        static let contactNo = "contactNo"
        static let firstName = "firstName"
        static let driverType = "driverType"
        static let profileImageUrl = "profileImageUrl"
    }
    
    // MARK: Properties
    @objc dynamic var id: String? = ""
    @objc dynamic var email: String? = ""
    @objc dynamic var address: String? = ""
    @objc dynamic var lastName: String? = ""
    @objc dynamic var contactNo: String? = ""
    @objc dynamic var firstName: String? = ""
    @objc dynamic var driverType: String? = ""
    @objc dynamic var profileImageUrl: String? = ""
    
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
        id <- map[SerializationKeys.id]
        email <- map[SerializationKeys.email]
        address <- map[SerializationKeys.address]
        lastName <- map[SerializationKeys.lastName]
        contactNo <- map[SerializationKeys.contactNo]
        firstName <- map[SerializationKeys.firstName]
        driverType <- map[SerializationKeys.driverType]
        profileImageUrl <- map[SerializationKeys.profileImageUrl]
    }
    
    
}
