//
//  DropOffState.swift
//
//  Created by Hamza Hasan on 26/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class DropOffStateModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let arrived = "arrived"
        static let departed = "departed"
        static let arrivedTime = "arrivedTime"
        static let departedTime = "departedTime"
    }
    
    // MARK: Properties
    @objc dynamic var arrived = false
    @objc dynamic var departed = false
    @objc dynamic var arrivedTime: String? = ""
    @objc dynamic var departedTime: String? = ""
    @objc dynamic var id: String? = ""
    
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
        arrived <- map[SerializationKeys.arrived]
        departed <- map[SerializationKeys.departed]
        arrivedTime <- map[SerializationKeys.arrivedTime]
        departedTime <- map[SerializationKeys.departedTime]
    }
    
    
}
