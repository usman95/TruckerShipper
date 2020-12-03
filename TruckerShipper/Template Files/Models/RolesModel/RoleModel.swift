//
//  UserModel.swift
//
//  Created by Hamza Hasan on 24/07/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class RoleModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "_id"
        static let title = "title"
    }
    // MARK: Properties
    @objc dynamic var id: String? = ""
    @objc dynamic var title: String? = ""
    
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
        title <- map[SerializationKeys.title]
    }
}
