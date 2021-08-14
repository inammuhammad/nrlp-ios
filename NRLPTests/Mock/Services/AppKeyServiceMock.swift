//
//  AppKeyServiceMock.swift
//  NRLPTests
//
//  Created by Muhammad Usman Tatla on 25/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class AppKeyServiceMock: AppKeyServiceProtocol {
    func fetchAppKey(cnic: String, type: AccountType, responseHandler: @escaping AppKeyCompletionHandler) {
        responseHandler(.success(AppKeyResponseModel(data: AppKey(key: "SDw8kjTojgfBuNDb25\\/QocH7D0xyWi6tMXKybLV8Wgo="), message: "")))
    }
}
