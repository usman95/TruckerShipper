//
//  ShippingLine.swift
//
//  Created by Hamza Hasan on 21/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class ShippingLineModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let prefix = "prefix"
        static let contactNo = "contactNo"
        static let title = "title"
        static let email = "email"
        static let id = "_id"
        static let address = "address"
    }
    
    // MARK: Properties
    @objc dynamic var prefix: String? = ""
    @objc dynamic var contactNo: String? = ""
    @objc dynamic var title: String? = ""
    @objc dynamic var email: String? = ""
    @objc dynamic var id: String? = ""
    @objc dynamic var address: String? = ""
    
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
        prefix <- map[SerializationKeys.prefix]
        contactNo <- map[SerializationKeys.contactNo]
        title <- map[SerializationKeys.title]
        email <- map[SerializationKeys.email]
        id <- map[SerializationKeys.id]
        address <- map[SerializationKeys.address]
    }
    
    
}
