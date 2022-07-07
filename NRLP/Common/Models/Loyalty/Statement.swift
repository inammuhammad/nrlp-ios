//
//  Statement.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct Statement: Codable {
    
    let status: String?
    let type: String
    let points: String
    let date: String
    let name: String?
    let transaction_id: String?
    
    lazy var formattedCreatedDate: String = {
        return DateFormat().formatDateString(dateString: date) ?? ""
    }()
    
    var createdDate: Date? {
        return DateFormat().formatDate(dateString: date)
    }
    var localFormattedCreatedDate: String {
        guard let createdDate = createdDate?.local else {
            return ""
        }
        
        return DateFormat().formatDateString(to: createdDate, formatter: .daySuffixFullMonth) ?? ""
    }
}
