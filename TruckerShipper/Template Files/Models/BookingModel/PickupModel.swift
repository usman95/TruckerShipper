//
//  Pickup.swift
//
//  Created by Hamza Hasan on 13/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class PickupModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let origin = "origin"
        static let cityId = "cityId"
        static let fullName = "fullName"
        static let originName = "originName"
        static let labourers = "labourers"
        static let address = "address"
        static let phoneNumber = "phoneNumber"
        static let coordinates = "coordinates"
    }
    
    // MARK: Properties
    @objc dynamic var origin: String? = ""
    @objc dynamic var cityId: AttributeModel?
    @objc dynamic var fullName: String? = ""
    @objc dynamic var originName: String? = ""
    @objc dynamic var labourers: String? = ""
    @objc dynamic var address: String? = ""
    @objc dynamic var phoneNumber: String? = ""
    var coordinates = List<ListLatLong>()
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
        origin <- map[SerializationKeys.origin]
        cityId <- map[SerializationKeys.cityId]
        fullName <- map[SerializationKeys.fullName]
        originName <- map[SerializationKeys.originName]
        labourers <- map[SerializationKeys.labourers]
        address <- map[SerializationKeys.address]
        phoneNumber <- map[SerializationKeys.phoneNumber]
        
        var coordinates: [Double]? = nil
        coordinates <- map["coordinates"]
        
        coordinates?.forEach { coordinate in
            let value = ListLatLong()
            value.value = coordinate
            self.coordinates.append(value)
        }
    }
}
