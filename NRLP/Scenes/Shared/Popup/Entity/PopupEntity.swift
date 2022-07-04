//
//  PopupEntity.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 04/07/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct PopupRequestModel: Codable {
    let custType: String
    let accountStatus: String
    
    enum CodingKeys: String, CodingKey {
        case custType = "cust_type"
        case accountStatus = "acc_status"
    }
}

struct PopupResponseModel: Codable {
    let message: String
    let records: PopupResponseRecord
}

struct PopupResponseRecord: Codable {
    let eventStartDatetime, custType: String
    let id: Int
    let createdAt, displayText: String
    let isDeleted: Int
    let accStatus, updatedAt: String
    let isActive: Int
    let eventEndDatetime: String

    enum CodingKeys: String, CodingKey {
        case eventStartDatetime = "event_start_datetime"
        case custType = "cust_type"
        case id
        case createdAt = "created_at"
        case displayText = "display_text"
        case isDeleted = "is_deleted"
        case accStatus = "acc_status"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case eventEndDatetime = "event_end_datetime"
    }
}
