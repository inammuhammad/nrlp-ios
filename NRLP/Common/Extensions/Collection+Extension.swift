//
//  Collection+Extension.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 26/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

public extension Collection {
    
    /// Convert self to JSON String.
    /// Returns: the pretty printed JSON string or an empty string if any error occur.
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.sortedKeys])
            return (String(data: jsonData, encoding: .utf8) ?? "{}")
        } catch {
            print("json serialization error: \(error)")
            return "{}"
        }
    }
}
