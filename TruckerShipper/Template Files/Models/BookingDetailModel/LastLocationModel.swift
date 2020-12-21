//
//  LastLocationModel.swift
//
//  Created by Hamza Hasan on 21/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class LastLocationModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let tripNumber = "tripNumber"
        static let lng = "lng"
        static let tripMileNumber = "tripMileNumber"
        static let bearing = "bearing"
        static let bookingNumber = "bookingNumber"
        static let lat = "lat"
    }
    
    // MARK: Properties
    @objc dynamic var tripNumber: String? = ""
    @objc dynamic var lng = 0.0
    @objc dynamic var tripMileNumber: String? = ""
    @objc dynamic var bearing = 0
    @objc dynamic var bookingNumber: String? = ""
    @objc dynamic var lat = 0.0
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
        tripNumber <- map[SerializationKeys.tripNumber]
        lng <- map[SerializationKeys.lng]
        tripMileNumber <- map[SerializationKeys.tripMileNumber]
        bearing <- map[SerializationKeys.bearing]
        bookingNumber <- map[SerializationKeys.bookingNumber]
        lat <- map[SerializationKeys.lat]
    }
    
    
}
