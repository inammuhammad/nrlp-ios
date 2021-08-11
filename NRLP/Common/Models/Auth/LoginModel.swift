//
//  LoginModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct LoginRequestModel: Codable {

    let accountType: String
    let cnicNicop: String
    let paassword: String

    enum CodingKeys: String, CodingKey {
        case accountType = "user_type"
        case cnicNicop = "nic_nicop"
        case paassword = "password"
    }

}

struct LoginResponseModel: Codable {

    let message: String?
    let token: String?
    var user: UserModel
    let expiresIn: String?

    enum CodingKeys: String, CodingKey {
        case expiresIn = "expires_in"
        case message = "message"
        case token = "token"
        case user
    }

}
