//
//  LogoutService.swift
//  1Link-NRLP
//
//  Created by VenD on 04/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class LogoutServicePositiveMock: LogoutServiceProtocol {
    func logoutUser(completion: @escaping LogoutServiceCallBack) {
        completion(.success(LogoutResponseModel(message: "Logout")))
    }
}

class LogoutServiceNegativeMock: LogoutServiceProtocol {
    func logoutUser(completion: @escaping LogoutServiceCallBack) {
        completion(.failure(.internetOffline))
    }
}
