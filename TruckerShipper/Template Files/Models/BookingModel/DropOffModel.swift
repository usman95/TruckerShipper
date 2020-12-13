//
//  DropOff.swift
//
//  Created by Hamza Hasan on 13/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class DropOffModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let destination = "destination"
        static let cityId = "cityId"
        static let fullName = "fullName"
        static let labourers = "labourers"
        static let address = "address"
        static let destinationName = "destinationName"
        static let phoneNumber = "phoneNumber"
        static let coordinates = "coordinates"
    }
    
    // MARK: Properties
    @objc dynamic var destination: String? = ""
    @objc dynamic var cityId: AttributeModel?
    @objc dynamic var fullName: String? = ""
    @objc dynamic var labourers: String? = ""
    @objc dynamic var address: String? = ""
    @objc dynamic var destinationName: String? = ""
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
        destination <- map[SerializationKeys.destination]
        cityId <- map[SerializationKeys.cityId]
        fullName <- map[SerializationKeys.fullName]
        labourers <- map[SerializationKeys.labourers]
        address <- map[SerializationKeys.address]
        destinationName <- map[SerializationKeys.destinationName]
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

class ListLatLong:Object{
    @objc dynamic var value: Double = 0.0
}
