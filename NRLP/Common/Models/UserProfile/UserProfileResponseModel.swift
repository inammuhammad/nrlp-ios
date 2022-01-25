//
//  UserProfileResponseModel.swift
//  1Link-NRLP
//
//  Created by VenD on 23/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct UserProfileResponseModel: Codable {
    let message: String
    let data: UserModel?
}

struct SelfAwardValidateResponseModel: Codable {
    let message: String
    let transactionID: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case transactionID = "sa_row_id"
    }
}

struct SelfAwardValidateOTPResponseModel: Codable {
    let message: String
}

struct InitRedemptionTransactionResponseModel: Codable {
    let message: String
    let transactionId: String
    let billInquiryResponse: BillInquiryResponseModel
    let inquiryMessage: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case transactionId = "transaction_id"
        case billInquiryResponse = "bill_inquiry_response"
        case inquiryMessage = "inquiryMessage"
    }
}

struct BillInquiryResponseModel: Codable {
    let amountAfterDueDate: String?
    let amountWithinDueDate: String?
    let billStatus: String?
    let billingMonth: String?
    let channelID: String?
    let clientID: String?
    let companyCode: String?
    let consumerNo: String?
    let customerName: String?
    let dueDate: String?
    let rrn: String?
    let responseCode: String?
    let responseDetail: String?
    let stan: String?
    let signature: String?
    
    var amount: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyy"
        let dueDate = dateFormatter.date(from: dueDate ?? "") ?? Date()
        if dueDate < Date() {
            return amountAfterDueDate ?? ""
        } else {
            return amountWithinDueDate ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case amountAfterDueDate = "AmountAfterDueDate"
        case amountWithinDueDate = "AmountWithinDueDate"
        case billStatus = "BillStatus"
        case billingMonth = "BillingMonth"
        case channelID = "ChannelID"
        case clientID = "ClientID"
        case companyCode = "CompanyCode"
        case consumerNo = "ConsumerNo"
        case customerName = "CustomerName"
        case dueDate = "DueDate"
        case rrn = "RRN"
        case responseCode = "ResponseCode"
        case responseDetail = "ResponseDetail"
        case stan = "STAN"
        case signature = "Signature"
    }
}

struct RedemptionTransactionSendOTPResponseModel: Codable {
    let message: String
    let transactionId: String
    let inquiryMessage: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case transactionId = "transaction_id"
        case inquiryMessage = "inquiryMessage"
    }
}
