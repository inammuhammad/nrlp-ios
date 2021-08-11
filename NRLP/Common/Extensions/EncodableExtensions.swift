//
//  EncodableExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

extension Encodable {

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
