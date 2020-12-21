//
//  TripMiles.swift
//
//  Created by Hamza Hasan on 15/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class TripMilesModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let pickUpAddress = "pickUpAddress"
        static let tripMileNumber = "tripMileNumber"
        static let tripId = "tripId"
        static let bookingId = "bookingId"
        static let sos = "sos"
        static let departure = "departure"
        static let createdAt = "createdAt"
        static let pickUpLocation = "pickUpLocation"
        static let dropOffLocation = "dropOffLocation"
        static let status = "status"
        static let mileStartDate = "mileStartDate"
        static let id = "_id"
        static let sequence = "sequence"
        static let vehicleId = "vehicleId"
        static let pickUpArrival = "pickUpArrival"
        static let v = "__v"
        static let crewId = "crewId"
        static let driverId = "driverId"
        static let updatedAt = "updatedAt"
        static let distance = "distance"
        static let dropOffAddress = "dropOffAddress"
        static let lastLocation = "lastLocation"
    }
    
    // MARK: Properties
    @objc dynamic var pickUpAddress: String? = ""
    @objc dynamic var tripMileNumber: String? = ""
    @objc dynamic var tripId: String? = ""
    @objc dynamic var bookingId: String? = ""
    @objc dynamic var sos = false
    @objc dynamic var departure = false
    @objc dynamic var createdAt: String? = ""
    var pickUpLocation = List<ListLatLong>()
    var dropOffLocation = List<ListLatLong>()
    @objc dynamic var status: String? = ""
    @objc dynamic var mileStartDate: String? = ""
    @objc dynamic var id: String? = ""
    @objc dynamic var sequence = 0
    @objc dynamic var vehicleId: VehicleIdModel?
    @objc dynamic var pickUpArrival = false
    @objc dynamic var v = 0
    @objc dynamic var crewId: CrewIdModel?
    @objc dynamic var driverId: DriverIdModel?
    @objc dynamic var updatedAt: String? = ""
    @objc dynamic var distance = 0
    @objc dynamic var dropOffAddress: String? = ""
    @objc dynamic var lastLocation: LastLocationModel?
    
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
        pickUpAddress <- map[SerializationKeys.pickUpAddress]
        tripMileNumber <- map[SerializationKeys.tripMileNumber]
        tripId <- map[SerializationKeys.tripId]
        bookingId <- map[SerializationKeys.bookingId]
        sos <- map[SerializationKeys.sos]
        departure <- map[SerializationKeys.departure]
        createdAt <- map[SerializationKeys.createdAt]
        pickUpLocation <- map[SerializationKeys.pickUpLocation]
        dropOffLocation <- map[SerializationKeys.dropOffLocation]
        status <- map[SerializationKeys.status]
        mileStartDate <- map[SerializationKeys.mileStartDate]
        id <- map[SerializationKeys.id]
        sequence <- map[SerializationKeys.sequence]
        vehicleId <- map[SerializationKeys.vehicleId]
        pickUpArrival <- map[SerializationKeys.pickUpArrival]
        v <- map[SerializationKeys.v]
        crewId <- map[SerializationKeys.crewId]
        driverId <- map[SerializationKeys.driverId]
        updatedAt <- map[SerializationKeys.updatedAt]
        distance <- map[SerializationKeys.distance]
        dropOffAddress <- map[SerializationKeys.dropOffAddress]
        lastLocation <- map[SerializationKeys.lastLocation]
        
        var pickUpLocation: [Double]? = nil
        pickUpLocation <- map["pickUpLocation"]
        
        pickUpLocation?.forEach { coordinate in
            let value = ListLatLong()
            value.value = coordinate
            self.pickUpLocation.append(value)
        }
        
        var dropOffLocation: [Double]? = nil
        dropOffLocation <- map["dropOffLocation"]
        
        dropOffLocation?.forEach { coordinate in
            let value = ListLatLong()
            value.value = coordinate
            self.dropOffLocation.append(value)
        }
    }
    
    
}
