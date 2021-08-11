//
//  UUIDModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 23/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct UUIDUpdateOTPRequestModel: Codable {
    let accountType: String
    let cnicNicop: String
    let password: String
    let otp: String

    enum CodingKeys: String, CodingKey {
        case accountType = "user_type"
        case cnicNicop = "nic_nicop"
        case password = "password"
        case otp = "otp"
    }
}

struct UUIDUpdateOTPResponseModel: Codable {
    let message: String

}
