//
//  UserModel.swift
//
//  Created by Hamza Hasan on 24/07/2020
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class UserModel: Object, Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let updatedAt = "updated_at"
        static let email = "email"
        static let token = "token"
        static let otpExpire = "otp_expire"
        static let subscribedToNewsLetter = "subscribed_to_news_letter"
        static let gender = "gender"
        static let phoneVerified = "phone_verified"
        static let otpCode = "otp_code"
        static let dateOfBirth = "date_of_birth"
        static let channelId = "channel_id"
        static let status = "status"
        static let customerGroupId = "customer_group_id"
        static let lastName = "last_name"
        static let id = "id"
        static let firstName = "first_name"
        static let createdAt = "created_at"
        static let phone = "phone"
        static let isVerified = "is_verified"
    }
    
    // MARK: Properties
    @objc dynamic var updatedAt: String? = ""
    @objc dynamic var email: String? = ""
    @objc dynamic var token: String? = ""
    @objc dynamic var otpExpire: String? = ""
    @objc dynamic var subscribedToNewsLetter = 0
    @objc dynamic var gender: String? = ""
    @objc dynamic var phoneVerified = 0
    @objc dynamic var otpCode: String? = ""
    @objc dynamic var dateOfBirth: String? = ""
    @objc dynamic var channelId = 0
    @objc dynamic var status = 0
    @objc dynamic var customerGroupId = 0
    @objc dynamic var lastName: String? = ""
    @objc dynamic var id = 0
    @objc dynamic var firstName: String? = ""
    @objc dynamic var createdAt: String? = ""
    @objc dynamic var phone: String? = ""
    @objc dynamic var isVerified = 0
    @objc dynamic var accessToken: String? = ""
    @objc dynamic var isGuest = false
    @objc dynamic var isSocial = false
    @objc dynamic var useCurrentLocation = false
    
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
        updatedAt <- map[SerializationKeys.updatedAt]
        email <- map[SerializationKeys.email]
        token <- map[SerializationKeys.token]
        otpExpire <- map[SerializationKeys.otpExpire]
        subscribedToNewsLetter <- map[SerializationKeys.subscribedToNewsLetter]
        gender <- map[SerializationKeys.gender]
        phoneVerified <- map[SerializationKeys.phoneVerified]
        otpCode <- map[SerializationKeys.otpCode]
        dateOfBirth <- map[SerializationKeys.dateOfBirth]
        channelId <- map[SerializationKeys.channelId]
        status <- map[SerializationKeys.status]
        customerGroupId <- map[SerializationKeys.customerGroupId]
        lastName <- map[SerializationKeys.lastName]
        id <- map[SerializationKeys.id]
        firstName <- map[SerializationKeys.firstName]
        createdAt <- map[SerializationKeys.createdAt]
        phone <- map[SerializationKeys.phone]
        isVerified <- map[SerializationKeys.isVerified]
    }
    
    
}
