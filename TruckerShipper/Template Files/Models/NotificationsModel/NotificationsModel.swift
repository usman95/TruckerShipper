//
//  NotificationsModel.swift
//
//  Created by Hamza Hasan on 20/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class NotificationsModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let action = "action"
        static let data = "data"
        static let body = "body"
        static let createdAt = "createdAt"
        static let isRead = "isRead"
        static let fromRefPath = "fromRefPath"
        static let toRefPath = "toRefPath"
        static let type = "type"
        static let to = "to"
        static let id = "_id"
        static let isDeleted = "isDeleted"
        static let updatedAt = "updatedAt"
        static let from = "from"
        static let title = "title"
        static let v = "__v"
    }
    
    // MARK: Properties
    @objc dynamic var action: String? = ""
    @objc dynamic var data: NotificationDataModel?
    @objc dynamic var body: String? = ""
    @objc dynamic var createdAt: String? = ""
    @objc dynamic var isRead = false
    @objc dynamic var fromRefPath: String? = ""
    @objc dynamic var toRefPath: String? = ""
    @objc dynamic var type: String? = ""
    @objc dynamic var to: NotificationToModel?
    @objc dynamic var id: String? = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var updatedAt: String? = ""
    @objc dynamic var from: NotificationFromModel?
    @objc dynamic var title: String? = ""
    @objc dynamic var v = 0
    
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
        action <- map[SerializationKeys.action]
        data <- map[SerializationKeys.data]
        body <- map[SerializationKeys.body]
        createdAt <- map[SerializationKeys.createdAt]
        isRead <- map[SerializationKeys.isRead]
        fromRefPath <- map[SerializationKeys.fromRefPath]
        toRefPath <- map[SerializationKeys.toRefPath]
        type <- map[SerializationKeys.type]
        to <- map[SerializationKeys.to]
        id <- map[SerializationKeys.id]
        isDeleted <- map[SerializationKeys.isDeleted]
        updatedAt <- map[SerializationKeys.updatedAt]
        from <- map[SerializationKeys.from]
        title <- map[SerializationKeys.title]
        v <- map[SerializationKeys.v]
    }
    
    
}
