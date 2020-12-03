//
//  UserModel.swift
//
//  Created by Hamza Hasan on 03/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class UserModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let user = "user"
        static let authToken = "authToken"
    }
    
    // MARK: Properties
    @objc dynamic var id: String? = ""
    @objc dynamic var user: User?
    @objc dynamic var authToken: String? = ""
    
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
        user <- map[SerializationKeys.user]
        authToken <- map[SerializationKeys.authToken]
    }
    
    
}
