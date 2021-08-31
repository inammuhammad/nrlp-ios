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
}
