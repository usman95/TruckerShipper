//
//  CreatedBy.swift
//
//  Created by Hamza Hasan on 03/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class CreatedByModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let lastName = "lastName"
        static let firstName = "firstName"
        static let id = "_id"
        static let email = "email"
    }
    
    // MARK: Properties
    @objc dynamic var lastName: String? = ""
    @objc dynamic var firstName: String? = ""
    @objc dynamic var id: String? = ""
    @objc dynamic var email: String? = ""
    
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
        lastName <- map[SerializationKeys.lastName]
        firstName <- map[SerializationKeys.firstName]
        id <- map[SerializationKeys.id]
        email <- map[SerializationKeys.email]
    }
    
    
}
