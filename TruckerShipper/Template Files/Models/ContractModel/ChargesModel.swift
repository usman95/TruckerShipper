//
//  Charges.swift
//
//  Created by Hamza Hasan on 21/12/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class ChargesModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let amount = "amount"
        static let subTotal = "subTotal"
    }
    
    // MARK: Properties
    @objc dynamic var amount = 0
    @objc dynamic var subTotal = 0
    @objc dynamic var id:String? = ""
    
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
        amount <- map[SerializationKeys.amount]
        subTotal <- map[SerializationKeys.subTotal]
    }
    
    
}
