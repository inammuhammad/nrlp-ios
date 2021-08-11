//
//  APIConstants.swift
//  1Link-NRLP
//
//  Created by VenD on 24/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias ErrorStateTuple = (code: Int, message: String)

struct APIConstants {
    enum ErrorStates {
        static let noInternetConnection = ErrorStateTuple(503, "Internet not available.")
    }
}
