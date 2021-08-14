//
//  ChangePasswordModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct ChangePasswordRequestModel: Codable {
    let oldPassword: String
    let newPassword: String

    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oldPassword.aesEncrypted(), forKey: .oldPassword)
        try container.encode(newPassword.aesEncrypted(), forKey: .newPassword)
    }
}

struct ChangePasswordResponseModel: Codable {
    let message: String

}
