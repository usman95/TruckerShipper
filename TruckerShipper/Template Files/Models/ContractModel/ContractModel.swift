//
//  ContractModel.swift
//
//  Created by Hamza Hasan on 21/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class ContractModel: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let transitFreeDays = "transitFreeDays"
    static let sizeId = "sizeId"
    static let shipperId = "shipperId"
    static let totalDuration = "totalDuration"
    static let pickup = "pickup"
    static let isEmptyPickupLocation = "isEmptyPickupLocation"
    static let dropOff = "dropOff"
    static let cargoTypeId = "cargoTypeId"
    static let commodityId = "commodityId"
    static let isEmptyReturnLocation = "isEmptyReturnLocation"
    static let isExpired = "isExpired"
    static let charges = "charges"
    static let expiryInDays = "expiryInDays"
    static let title = "title"
    static let bookingTypeId = "bookingTypeId"
    static let route = "route"
    static let shippingLine = "shippingLine"
    static let createdAt = "createdAt"
    static let remarks = "remarks"
    static let transportModeId = "transportModeId"
    static let contractEndDate = "contractEndDate"
    static let updatedBy = "updatedBy"
    static let id = "_id"
    static let isDeleted = "isDeleted"
    static let totalDistance = "totalDistance"
    static let v = "__v"
    static let updatedAt = "updatedAt"
    static let weight = "weight"
    static let cargoMode = "cargoMode"
    static let contractStartDate = "contractStartDate"
    static let quantityOfTrucks = "quantityOfTrucks"
  }

  // MARK: Properties
  @objc dynamic var transitFreeDays = 0
  @objc dynamic var sizeId: AttributeModel?
  @objc dynamic var totalDuration: String? = ""
  @objc dynamic var pickup: PickupModel?
  @objc dynamic var isEmptyPickupLocation = false
  @objc dynamic var dropOff: DropOffModel?
  @objc dynamic var cargoTypeId: AttributeModel?
  @objc dynamic var commodityId: AttributeModel?
  @objc dynamic var isEmptyReturnLocation = false
  @objc dynamic var isExpired = false
  @objc dynamic var charges: ChargesModel?
  @objc dynamic var expiryInDays = 0
  @objc dynamic var title: String? = ""
  @objc dynamic var bookingTypeId: AttributeModel?
  @objc dynamic var route: String? = ""
  @objc dynamic var shippingLine: ShippingLineModel?
  @objc dynamic var createdAt: String? = ""
  var remarks = List<RemarksModel>()
  @objc dynamic var transportModeId: AttributeModel?
  @objc dynamic var contractEndDate: String? = ""
  @objc dynamic var id: String? = ""
  @objc dynamic var isDeleted = false
  @objc dynamic var totalDistance = 0
  @objc dynamic var v = 0
  @objc dynamic var updatedAt: String? = ""
  @objc dynamic var weight = 0
  @objc dynamic var cargoMode: String? = ""
  @objc dynamic var contractStartDate: String? = ""
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
    transitFreeDays <- map[SerializationKeys.transitFreeDays]
    sizeId <- map[SerializationKeys.sizeId]
    totalDuration <- map[SerializationKeys.totalDuration]
    pickup <- map[SerializationKeys.pickup]
    isEmptyPickupLocation <- map[SerializationKeys.isEmptyPickupLocation]
    dropOff <- map[SerializationKeys.dropOff]
    cargoTypeId <- map[SerializationKeys.cargoTypeId]
    commodityId <- map[SerializationKeys.commodityId]
    isEmptyReturnLocation <- map[SerializationKeys.isEmptyReturnLocation]
    isExpired <- map[SerializationKeys.isExpired]
    charges <- map[SerializationKeys.charges]
    expiryInDays <- map[SerializationKeys.expiryInDays]
    title <- map[SerializationKeys.title]
    bookingTypeId <- map[SerializationKeys.bookingTypeId]
    route <- map[SerializationKeys.route]
    shippingLine <- map[SerializationKeys.shippingLine]
    createdAt <- map[SerializationKeys.createdAt]
    remarks <- (map[SerializationKeys.remarks], ListTransform<RemarksModel>())
    transportModeId <- map[SerializationKeys.transportModeId]
    contractEndDate <- map[SerializationKeys.contractEndDate]
    id <- map[SerializationKeys.id]
    isDeleted <- map[SerializationKeys.isDeleted]
    totalDistance <- map[SerializationKeys.totalDistance]
    v <- map[SerializationKeys.v]
    updatedAt <- map[SerializationKeys.updatedAt]
    weight <- map[SerializationKeys.weight]
    cargoMode <- map[SerializationKeys.cargoMode]
    contractStartDate <- map[SerializationKeys.contractStartDate]
    quantityOfTrucks <- map[SerializationKeys.quantityOfTrucks]
  }


}
