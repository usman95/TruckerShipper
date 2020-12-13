//
//  BookingModel.swift
//
//  Created by Hamza Hasan on 13/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class BookingModel: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let bookingDate = "bookingDate"
    static let transitFreeDays = "transitFreeDays"
    static let shipperId = "shipperId"
    static let pickup = "pickup"
    static let dropOff = "dropOff"
    static let cargoTypeId = "cargoTypeId"
    static let commodityId = "commodityId"
    static let bookingNumber = "bookingNumber"
    static let bookingTypeId = "bookingTypeId"
    static let route = "route"
    static let pickUpDate = "pickUpDate"
    static let shippingLine = "shippingLine"
    static let createdAt = "createdAt"
    static let remarks = "remarks"
    static let transportModeId = "transportModeId"
    static let status = "status"
    static let updatedBy = "updatedBy"
    static let id = "_id"
    static let isDeleted = "isDeleted"
    static let totalDistance = "totalDistance"
    static let v = "__v"
    static let updatedAt = "updatedAt"
    static let weight = "weight"
    static let cargoMode = "cargoMode"
    static let documents = "documents"
    static let createdBy = "createdBy"
    static let quantityOfTrucks = "quantityOfTrucks"
  }

  // MARK: Properties
  @objc dynamic var bookingDate: String? = ""
  @objc dynamic var transitFreeDays = 0
  @objc dynamic var shipperId: ShipperIdModel?
  @objc dynamic var pickup: PickupModel?
  @objc dynamic var dropOff: DropOffModel?
  @objc dynamic var cargoTypeId: AttributeModel?
  @objc dynamic var commodityId: AttributeModel?
  @objc dynamic var bookingNumber: String? = ""
  @objc dynamic var bookingTypeId: AttributeModel?
  @objc dynamic var route: String? = ""
  @objc dynamic var pickUpDate: String? = ""
  @objc dynamic var shippingLine: String? = ""
  @objc dynamic var createdAt: String? = ""
  var remarks = List<RemarksModel>()
  @objc dynamic var transportModeId: AttributeModel?
  @objc dynamic var status: String? = ""
  @objc dynamic var updatedBy: UpdatedBy?
  @objc dynamic var id: String? = ""
  @objc dynamic var isDeleted = false
  @objc dynamic var totalDistance = 0
  @objc dynamic var v = 0
  @objc dynamic var updatedAt: String? = ""
  @objc dynamic var weight = 0
  @objc dynamic var cargoMode: String? = ""
//  var documents = List<Any>()
  @objc dynamic var createdBy: CreatedByModel?
  @objc dynamic var quantityOfTrucks = 0

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
    bookingDate <- map[SerializationKeys.bookingDate]
    transitFreeDays <- map[SerializationKeys.transitFreeDays]
    shipperId <- map[SerializationKeys.shipperId]
    pickup <- map[SerializationKeys.pickup]
    dropOff <- map[SerializationKeys.dropOff]
    cargoTypeId <- map[SerializationKeys.cargoTypeId]
    commodityId <- map[SerializationKeys.commodityId]
    bookingNumber <- map[SerializationKeys.bookingNumber]
    bookingTypeId <- map[SerializationKeys.bookingTypeId]
    route <- map[SerializationKeys.route]
    pickUpDate <- map[SerializationKeys.pickUpDate]
    shippingLine <- map[SerializationKeys.shippingLine]
    createdAt <- map[SerializationKeys.createdAt]
    remarks <- (map[SerializationKeys.remarks], ListTransform<RemarksModel>())
    transportModeId <- map[SerializationKeys.transportModeId]
    status <- map[SerializationKeys.status]
    updatedBy <- map[SerializationKeys.updatedBy]
    id <- map[SerializationKeys.id]
    isDeleted <- map[SerializationKeys.isDeleted]
    totalDistance <- map[SerializationKeys.totalDistance]
    v <- map[SerializationKeys.v]
    updatedAt <- map[SerializationKeys.updatedAt]
    weight <- map[SerializationKeys.weight]
    cargoMode <- map[SerializationKeys.cargoMode]
//    documents <- map[SerializationKeys.documents]
    createdBy <- map[SerializationKeys.createdBy]
    quantityOfTrucks <- map[SerializationKeys.quantityOfTrucks]
  }


}
