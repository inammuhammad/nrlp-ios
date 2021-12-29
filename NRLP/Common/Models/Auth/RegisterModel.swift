//
//  RegisterModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct RegisterRequestModel: Codable {

    let accountType: String
    let cnicNicop: String
    var email: String
    var fullName: String
    var mobileNo: String
    var paassword: String
    var passportType: String
    var passportNumber: String
    var registrationCode: String?
//    var transactionAmount: String?
//    var transactionRefNo: String?
    var residentID: String?
    var country: String?
    var cnicIssueDate: String?
    var motherMaidenName: String?
    var birthPlace: String?
    var sotp: String

    enum CodingKeys: String, CodingKey {
        case accountType = "user_type"
        case cnicNicop = "nic_nicop"
        case email = "email"
        case fullName = "full_name"
        case mobileNo = "mobile_no"
        case paassword = "password"
        case registrationCode = "registration_code"
//        case transactionAmount = "amount"
//        case transactionRefNo = "reference_no"
        case residentID = "resident_id"
        case passportType = "passport_type"
        case passportNumber = "passport_id"
        case country = "country"
        case cnicIssueDate = "cnic_nicop_issuance_date"
        case motherMaidenName = "mother_maiden_name"
        case birthPlace = "place_of_birth"
        case sotp = "sotp"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(cnicNicop.aesEncrypted(), forKey: .cnicNicop)
        try container.encode(email.aesEncrypted(), forKey: .email)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(mobileNo, forKey: .mobileNo)
        try container.encode(paassword.aesEncrypted(), forKey: .paassword)
        try container.encode(registrationCode?.aesEncrypted(), forKey: .registrationCode)
//        try container.encode(transactionAmount?.aesEncrypted(), forKey: .transactionAmount)
//        try container.encode(transactionRefNo?.aesEncrypted(), forKey: .transactionRefNo)
        try container.encode(residentID?.aesEncrypted(), forKey: .residentID)
        try container.encode(passportType, forKey: .passportType)
        try container.encode(passportNumber.aesEncrypted(), forKey: .passportNumber)
        try container.encode(country, forKey: .country)
        try container.encode(birthPlace?.aesEncrypted(), forKey: .birthPlace)
        try container.encode(motherMaidenName?.aesEncrypted(), forKey: .motherMaidenName)
        try container.encode(cnicIssueDate?.aesEncrypted(), forKey: .cnicIssueDate)
        try container.encode(sotp, forKey: .sotp)
    }
}

struct RegisterResponseModel: Codable {

    let message: String!

}
