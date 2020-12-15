//
//  TripModel.swift
//
//  Created by Hamza Hasan on 15/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class TripModel: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let tripNumber = "tripNumber"
    static let id = "_id"
    static let bookingId = "bookingId"
    static let createdAt = "createdAt"
    static let v = "__v"
    static let tripMiles = "tripMiles"
  }

  // MARK: Properties
  @objc dynamic var tripNumber: String? = ""
  @objc dynamic var id: String? = ""
  @objc dynamic var bookingId: String? = ""
  @objc dynamic var createdAt: String? = ""
  @objc dynamic var v = 0
  var tripMiles = List<TripMilesModel>()

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
    id <- map[SerializationKeys.id]
    bookingId <- map[SerializationKeys.bookingId]
    createdAt <- map[SerializationKeys.createdAt]
    v <- map[SerializationKeys.v]
    tripMiles <- (map[SerializationKeys.tripMiles], ListTransform<TripMilesModel>())
  }


}
