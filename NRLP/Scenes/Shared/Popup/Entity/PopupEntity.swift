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
    
}
