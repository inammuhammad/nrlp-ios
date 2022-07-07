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
    var loyaltyType: String
    private var currentPointsBalance: String?
    var userCountry: Country?
    var countryName: String?
    var residentID: String?
    var passportTypeValue: String?
    
    var birthPlace: String?
    var fatherName: String?
    var motherMaidenName: String?
    var cnicIssueDateStr: String?
    private var nadraVerifiedStr: String?
    
    var requiresNadraVerification: Bool?
    var receiverCount: Int?
    
    var nadraVerified: NadraTypes? {
        return NadraTypes(rawValue: nadraVerifiedStr?.lowercased() ?? "")
    }
    
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
    
    var formattedCnicIssueDate: String {
        return DateFormat().formatDateString(dateString: cnicIssueDateStr ?? "", fromFormat: .dateTimeMilis, toFormat: .shortDateFormat) ?? ""
    }
    
    var notificationCount: Int?
    var nadraStatusCode: String?

    enum CodingKeys: String, CodingKey {
        case type = "user_type"
        case cnicNicop = "nic_nicop"
        case fullName = "full_name"
        case id = "id"
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
        case countryName = "country"
        case birthPlace = "place_of_birth"
        case fatherName = "father_name"
        case motherMaidenName = "mother_maiden_name"
        case cnicIssueDateStr = "cnic_nicop_issuance_date"
        case nadraVerifiedStr = "nadra_verified"
        case requiresNadraVerification = "require_nadra_verification"
        case receiverCount = "receiver_count"
        case notificationCount = "notification_count"
        case nadraStatusCode = "nadra_status_code"
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
        self.countryName = ""
        self.birthPlace = ""
        self.fatherName = ""
        self.motherMaidenName = ""
        self.cnicIssueDateStr = ""
        self.nadraVerifiedStr = ""
        self.requiresNadraVerification = false
        self.receiverCount = 1
        self.notificationCount = 0
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
        self.countryName = userModel.countryName ?? countryName
        self.birthPlace = userModel.birthPlace ?? birthPlace
        self.fatherName = userModel.fatherName ?? fatherName
        self.motherMaidenName = userModel.motherMaidenName ?? motherMaidenName
        self.cnicIssueDateStr = userModel.cnicIssueDateStr
        self.nadraVerifiedStr = userModel.nadraVerifiedStr
        self.requiresNadraVerification = userModel.requiresNadraVerification ?? requiresNadraVerification
        self.receiverCount = userModel.receiverCount ?? receiverCount
        self.notificationCount = userModel.notificationCount ?? notificationCount
        
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.requiresNadraVerification = try container.decodeIfPresent(Bool.self, forKey: .requiresNadraVerification)
//        self.type = try container.decodeIfPresent(String.self, forKey: .type)
//        self.cnicNicop = try container.decodeIfPresent(Int.self, forKey: .cnicNicop) ?? 0
//        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
//        self.points = try container.decodeIfPresent(String.self, forKey: .points)
//        self.currentPointsBalance = try container.decodeIfPresent(String.self, forKey: .currentPointsBalance)
//        self.mobileNo = try container.decodeIfPresent(String.self, forKey: .mobileNo)
//        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
//        self.email = try container.decodeIfPresent(String.self, forKey: .email)
//        self.loyaltyType = try container.decodeIfPresent(String.self, forKey: .loyaltyType) ?? ""
//        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
//        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
//        self.residentID = try container.decodeIfPresent(String.self, forKey: .residentID)
//        self.passportTypeValue = try container.decodeIfPresent(String.self, forKey: .passportTypeValue)
//        self.passportNumber = try container.decodeIfPresent(String.self, forKey: .passportNumber)
//        self.memberSince = try container.decodeIfPresent(String.self, forKey: .memberSince)
//        self.usdBalance = try container.decodeIfPresent(String.self, forKey: .usdBalance)
//        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
//        self.birthPlace = try container.decodeIfPresent(String.self, forKey: .birthPlace)
//        self.motherMaidenName = try container.decodeIfPresent(String.self, forKey: .motherMaidenName)
//        self.cnicIssueDateStr = try container.decodeIfPresent(String.self, forKey: .cnicIssueDateStr)
//        self.nadraVerifiedStr = try container.decodeIfPresent(String.self, forKey: .nadraVerifiedStr) ?? ""
//
//    }
}
