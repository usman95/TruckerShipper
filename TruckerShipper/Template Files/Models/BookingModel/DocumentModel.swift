//
//  DocumentModel.swift
//
//  Created by Hamza Hasan on 14/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class DocumentModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let docType = "docType"
        static let url = "url"
        static let id = "_id"
    }
    
    // MARK: Properties
    @objc dynamic var docType: String? = ""
    @objc dynamic var url: String? = ""
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
        docType <- map[SerializationKeys.docType]
        url <- map[SerializationKeys.url]
        id <- map[SerializationKeys.id]
    }
    
    
}
