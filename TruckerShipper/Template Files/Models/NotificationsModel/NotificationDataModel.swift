//
//  Data.swift
//
//  Created by Hamza Hasan on 20/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class NotificationDataModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let title = "title"
        static let bookingId = "bookingId"
        static let bookingNumber = "bookingNumber"
        static let body = "body"
        static let bookingStatus = "bookingStatus"
    }
    
    // MARK: Properties
    @objc dynamic var title: String? = ""
    @objc dynamic var bookingId: String? = ""
    @objc dynamic var bookingNumber: String? = ""
    @objc dynamic var body: String? = ""
    @objc dynamic var id = 0
    @objc dynamic var bookingStatus: String? = ""
    
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
        title <- map[SerializationKeys.title]
        bookingId <- map[SerializationKeys.bookingId]
        bookingNumber <- map[SerializationKeys.bookingNumber]
        body <- map[SerializationKeys.body]
        bookingStatus <- map[SerializationKeys.bookingStatus]
    }
    
    
}
