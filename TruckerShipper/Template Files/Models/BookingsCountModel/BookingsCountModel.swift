//
//  BookingsCountModel.swift
//
//  Created by Hamza Hasan on 18/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class BookingsCountModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let pending = "pending"
        static let id = "id"
        static let cancelled = "cancelled"
        static let completed = "completed"
        static let inProgress = "inProgress"
        static let rejected = "rejected"
        static let accepted = "accepted"
    }
    
    // MARK: Properties
    @objc dynamic var pending = 0
    @objc dynamic var id = 0
    @objc dynamic var cancelled = 0
    @objc dynamic var completed = 0
    @objc dynamic var inProgress = 0
    @objc dynamic var rejected = 0
    @objc dynamic var accepted = 0
    
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
        pending <- map[SerializationKeys.pending]
        id <- map[SerializationKeys.id]
        cancelled <- map[SerializationKeys.cancelled]
        completed <- map[SerializationKeys.completed]
        inProgress <- map[SerializationKeys.inProgress]
        rejected <- map[SerializationKeys.rejected]
        accepted <- map[SerializationKeys.accepted]
    }
    
    
}
