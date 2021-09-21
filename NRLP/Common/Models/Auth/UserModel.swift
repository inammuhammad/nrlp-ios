//
//  UserModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct UserModel: Codable {

    var type: String?
    var cnicNicop: Int
    var fullName: String
    var points: String?
    var mobileNo: String?
    var id: Int
    var email: String?
    
    var createdAt: String?
    var updatedAt: String?
//    var isActive: Int?
//    var isDeleted: Int?
    var loyaltyType: String
    private var currentPointsBalance: String?
    var userCountry: Country?
    
    var residentID: String?
    var passportTypeValue: String?
    
    var passportType: PassportType? {
        if let type = passportTypeValue {
            return PassportType(rawValue: type)
        }
        return nil
    }
    
    var passportNumber: String?
    
    var loyaltyLevel: LoyaltyType {
        return LoyaltyType(rawValue: loyaltyType.lowercased()) ?? .green
    }
    
    var accountType: AccountType? {
        if let type = type {
            return AccountType(rawValue: type)
        }
        return nil
    }

    var loyaltyPoints: String? {
        return currentPointsBalance ?? points
    }

    var roundedLoyaltyPoints: Int64 {
        return Int64(loyaltyPoints?.double ?? 0)
    }
    
    var usdBalance: String?
    var memberSince: String?
    
    var formattedUsdBalance: String {
        return CurrencyFormatter().format(string: usdBalance ?? "0.0")
    }

    enum CodingKeys: String, CodingKey {
        case type = "user_type"
        case cnicNicop = "nic_nicop"
        case fullName = "full_name"
        case id = "id"
//        case isActive = "is_active"
//        case isDeleted = "is_deleted"
        case loyaltyType = "loyalty_level"
        case points = "loyalty_points"
        case mobileNo = "mobile_no"
        case email = "email"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case currentPointsBalance = "current_points_balance"
        case residentID = "resident_id"
        case passportTypeValue = "passport_type"
        case passportNumber = "passport_id"
        case usdBalance = "usd_balance"
        case memberSince = "member_since"
    }
    
    init() {
        self.type = ""
        self.cnicNicop = 0
        self.fullName = ""
        self.points = ""
        self.currentPointsBalance = nil
        self.mobileNo = ""
        self.id = 0
        self.email = ""
        self.loyaltyType = ""
        self.createdAt = ""
        self.updatedAt = ""
//        self.isActive = 0
//        self.isDeleted = 0
        self.residentID = ""
        self.passportTypeValue = ""
        self.passportNumber = ""
        self.usdBalance = ""
        self.memberSince = ""
    }

    mutating func update(from userModel: UserModel) {
        self.type = userModel.type ?? type
        self.cnicNicop = userModel.cnicNicop
        self.fullName = userModel.fullName
        self.points = userModel.points ?? points
        self.currentPointsBalance = userModel.currentPointsBalance ??  currentPointsBalance
        self.mobileNo = userModel.mobileNo ?? mobileNo
        self.id = userModel.id
        self.email = userModel.email ?? email
        self.loyaltyType = userModel.loyaltyLevel.rawValue
        self.createdAt = userModel.createdAt ?? createdAt
        self.updatedAt = userModel.updatedAt ?? updatedAt
//        self.isActive = userModel.isActive ?? isActive
//        self.isDeleted = userModel.isDeleted ?? isDeleted
        self.residentID = userModel.residentID?.aesDecrypted() ?? residentID
        self.passportTypeValue = userModel.passportTypeValue ?? passportTypeValue
        self.passportNumber = userModel.passportNumber?.aesDecrypted() ?? passportNumber
        self.memberSince = userModel.memberSince ?? memberSince
        self.usdBalance = userModel.usdBalance ?? usdBalance
    }
}
