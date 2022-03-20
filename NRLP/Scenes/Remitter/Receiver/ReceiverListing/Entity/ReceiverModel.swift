//
//  ReceiverModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct ReceiverModel: Codable {
    
    var receiverName: String?
    let receiverBankNumber: String?
    let receiverCnic: Int?
    let remitterCnic: Int?
    let linkDate: String?
    let receiverMobileNumber: String?
    var linkStatus: String?
    let receiverBankName: String?
    var receiverType: RemitterReceiverType? {
        if receiverBankNumber == nil || receiverBankName == nil {
            return RemitterReceiverType.cnic
        } else {
            return RemitterReceiverType.bank
        }
    }
    
    var formattedReceiverCNIC: String {
        if let receiverCnic = receiverCnic, receiverCnic != 0 {
            var cnic = "\(receiverCnic)"
            
            if cnic.count < 13 {
                cnic = String(repeating: "0", count: 13 - cnic.count) + cnic
            }
            
            return CNICFormatter().format(string: cnic)
        }
        return CNICFormatter().format(string: "")
    }
    
    var formattedRemitterCNIC: String {
        
        if let remitterCnic = remitterCnic, remitterCnic != 0 {
            var cnic = "\(remitterCnic)"
            
            if cnic.count < 13 {
                cnic = String(repeating: "0", count: 13 - cnic.count) + cnic
            }
            
            return CNICFormatter().format(string: cnic)
        }
        return CNICFormatter().format(string: "")    }
    
    enum CodingKeys: String, CodingKey {
        case receiverName = "receiver_name"
        case receiverBankNumber = "rec_bank_iban"
        case receiverCnic = "receiver_cnic"
        case linkDate = "link_date"
        case receiverMobileNumber = "receiver_mobile_no"
        case linkStatus = "link_status"
        case receiverBankName = "rec_bank_name"
        case remitterCnic = "remitter_cnic"
    }
}

struct AddReceiverRequestModel: Codable {
    
    let cnic: String?
    let mobileNo: String?
    let fullName: String?
    //    let motherMaidenName: String?
    //    let cnicIssueDate: String?
    //    let birthPlace: String?
    let bankAccountNumber: String?
    let bankName: String?
    
    enum CodingKeys: String, CodingKey {
        case cnic = "nic_nicop"
        case mobileNo = "mobile_no"
        case fullName = "full_name"
        //        case motherMaidenName = "mother_maiden_name"
        //        case cnicIssueDate = "cnic_nicop_issuance_date"
        //        case birthPlace = "place_of_birth"
        case bankAccountNumber = "account_number_iban"
        case bankName = "bank_name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cnic?.aesEncrypted(), forKey: .cnic)
        try container.encodeIfPresent(mobileNo, forKey: .mobileNo)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        //        try container.encodeIfPresent(motherMaidenName?.aesEncrypted(), forKey: .motherMaidenName)
        //        try container.encodeIfPresent(cnicIssueDate?.aesEncrypted(), forKey: .cnicIssueDate)
        //        try container.encodeIfPresent(birthPlace?.aesEncrypted(), forKey: .birthPlace)
        try container.encodeIfPresent(bankAccountNumber?.aesEncrypted(), forKey: .bankAccountNumber)
        try container.encodeIfPresent(bankName?.aesEncrypted(), forKey: .bankName)
    }
}

struct AddReceiverResponseModel: Codable {
    let message: String
}

struct DeleteReceiverRequestModel: Codable {
    
    let cnic: String?
    
    enum CodingKeys: String, CodingKey {
        case cnic = "nic_nicop"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cnic?.aesEncrypted(), forKey: .cnic)
    }
}

struct DeleteReceiverResponseModel: Codable {
    let message: String
}

struct ReceiverListResponseModel: Codable {
    let message: String
    let data: [ReceiverModel]
}
