//
//  ComplaintModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct ComplaintRequestModel: Codable {
    let registered: Int?
    let userType: String?
    let complaintTypeID: Int?
    let mobileNo: String?
    let email: String?
    let countryOfResidence: String?
    let mobileOperatorName: String?
    let name: String?
    let cnic: String?
    let transactionType: String?
    let beneficiaryCnic: String?
    let beneficiaryCountryOfResidence: String?
    let beneficiaryMobileNo: String?
    let beneficiaryMobileOperatorName: String?
    let remittingEntity: String?
    let transactionID: String?
    let transactionDate: String?
    let transactionAmount: String?
    let redemptionPartners: String?
    let comments: String?
    let locMobileNo: String?
    let branchCenter: String?
    let countryForNadra: String?
    let selfAwardType: String?
    
    enum CodingKeys: String, CodingKey {
        case registered = "c_registered"
        case userType = "c_user_type"
        case complaintTypeID = "c_complaint_type_id"
        case mobileNo = "c_mobile_no"
        case email = "c_email"
        case countryOfResidence = "c_country_of_residence"
        case mobileOperatorName = "c_mobile_operator_name"
        case name = "c_name"
        case cnic = "c_nic_nicop"
        case transactionType = "c_transaction_type"
        case beneficiaryCnic = "c_beneficiary_nic_nicop"
        case beneficiaryCountryOfResidence = "c_beneficiary_country_of_residence"
        case beneficiaryMobileNo = "c_beneficiary_mobile_no"
        case beneficiaryMobileOperatorName = "c_beneficiary_mobile_operator_name"
        case remittingEntity = "c_remitting_entity"
        case transactionID = "c_transaction_id"
        case transactionDate = "c_transaction_date"
        case transactionAmount = "c_transaction_amount"
        case redemptionPartners = "c_redemption_partners"
        case comments = "c_comments"
        case locMobileNo = "loc_mobile_no"
        case branchCenter = "branch_center"
        case countryForNadra = "country_for_nadra"
        case selfAwardType = "self_award_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(registered, forKey: .registered)
        try container.encodeIfPresent(userType, forKey: .userType)
        try container.encodeIfPresent(complaintTypeID, forKey: .complaintTypeID)
        try container.encodeIfPresent(mobileNo, forKey: .mobileNo)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(countryOfResidence, forKey: .countryOfResidence)
        try container.encodeIfPresent(mobileOperatorName, forKey: .mobileOperatorName)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(cnic, forKey: .cnic)
        try container.encodeIfPresent(transactionType, forKey: .transactionType)
        try container.encodeIfPresent(beneficiaryCnic, forKey: .beneficiaryCnic)
        try container.encodeIfPresent(beneficiaryCountryOfResidence, forKey: .beneficiaryCountryOfResidence)
        try container.encodeIfPresent(beneficiaryMobileNo, forKey: .beneficiaryMobileNo)
        try container.encodeIfPresent(beneficiaryMobileOperatorName, forKey: .beneficiaryMobileOperatorName)
        try container.encodeIfPresent(remittingEntity, forKey: .remittingEntity)
        try container.encodeIfPresent(transactionID, forKey: .transactionID)
        try container.encodeIfPresent(transactionDate, forKey: .transactionDate)
        try container.encodeIfPresent(transactionAmount, forKey: .transactionAmount)
        try container.encodeIfPresent(redemptionPartners, forKey: .redemptionPartners)
        try container.encodeIfPresent(comments, forKey: .comments)
        try container.encodeIfPresent(locMobileNo, forKey: .locMobileNo)
        try container.encodeIfPresent(branchCenter, forKey: .branchCenter)
        try container.encodeIfPresent(countryForNadra, forKey: .countryForNadra)
        try container.encodeIfPresent(selfAwardType, forKey: .selfAwardType)
    }
}

struct ComplaintResponseModel: Codable {
    let message: String
    let complaintId: String
}
