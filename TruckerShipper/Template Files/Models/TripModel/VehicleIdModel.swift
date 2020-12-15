//
//  VehicleId.swift
//
//  Created by Hamza Hasan on 15/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class VehicleIdModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let height = "height"
        static let loadCapacity = "loadCapacity"
        static let registrationNumber = "registrationNumber"
        static let id = "_id"
        static let axl = "axl"
        static let wheeler = "wheeler"
    }
    
    // MARK: Properties
    @objc dynamic var height = 0
    @objc dynamic var loadCapacity = 0
    @objc dynamic var registrationNumber: String? = ""
    @objc dynamic var id: String? = ""
    @objc dynamic var axl = 0
    @objc dynamic var wheeler = 0
    
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
        height <- map[SerializationKeys.height]
        loadCapacity <- map[SerializationKeys.loadCapacity]
        registrationNumber <- map[SerializationKeys.registrationNumber]
        id <- map[SerializationKeys.id]
        axl <- map[SerializationKeys.axl]
        wheeler <- map[SerializationKeys.wheeler]
    }
    
    
}
