//
//  APIKeyComponentModel.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 15/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

struct AppKeyRequestModel: Codable {}

struct AppKeyResponseModel: Codable {
    let data: AppKey
    let message: String
}

struct AppKey: Codable {
    let key: String
}
