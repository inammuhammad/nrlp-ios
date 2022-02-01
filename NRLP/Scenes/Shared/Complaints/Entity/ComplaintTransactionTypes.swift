//
//  ComplaintTransactionTypes.swift
//  NRLP
//
//  Created by Bilal Iqbal on 01/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct ComplaintTransactionTypesRequestModel: Codable {}

struct ComplaintTransactionTypesResponseModel: Codable {
    var message: String
    var data: [String]
}

