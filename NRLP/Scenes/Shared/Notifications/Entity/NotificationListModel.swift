//
//  NotificationListingModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 16/05/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

struct NotificationListRequestModel: Codable {
    let page: String
    let perPage: String
    let nicNicop: String
    let notificationType: String
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case nicNicop = "nic_nicop"
        case notificationType = "notification_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(perPage, forKey: .perPage)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(notificationType, forKey: .notificationType)
        
    }
}

struct NotificationListResponseModel: Codable {
    let message: String
    let data: NotificationListDataModel
}

struct NotificationListDataModel: Codable {
    let records: [NotificationRecordModel]
    let totalPages: Int?
    let perPage: String?
    let totalRecords: Int
    let page: String
    
    enum CodingKeys: String, CodingKey {
        case records = "records"
        case totalPages = "total_pages"
        case perPage = "per_page"
        case totalRecords = "total_records"
        case page = "page"
    }
}

struct NotificationRecordModel: Codable {
    let id, cnic: Int
    let notificationMessage, custType, createdAt, notificationDatetime: String
    let notificationPriority: String
    var isReadFlag: Int
    let readDatetime: String
    let isActive: Int
    let updatedAt: String
    let isDeleted: Int
    let notificationType, notificationID: String
    
    enum CodingKeys: String, CodingKey {
        case id, cnic
        case notificationMessage = "notification_message"
        case custType = "cust_type"
        case createdAt = "created_at"
        case notificationDatetime = "notification_datetime"
        case notificationPriority = "notification_priority"
        case isReadFlag = "is_read_flag"
        case readDatetime = "read_datetime"
        case isActive = "is_active"
        case updatedAt = "updated_at"
        case isDeleted = "is_deleted"
        case notificationType = "notification_type"
        case notificationID = "notification_id"
    }
}

struct NotificationReadRequestModel: Codable {
    let id: String
    let isRead: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case isRead = "is_read_flag"
    }
}

struct NotificationReadResponseModel: Codable {
    
}

struct NotificationDeleteRequestModel: Codable {
    let id: String
    let isRead: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case isRead = "is_read_flag"
    }
}

struct NotificationDeleteResponseModel: Codable {
    
}
