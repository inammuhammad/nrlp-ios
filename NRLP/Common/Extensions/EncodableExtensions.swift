//
//  EncodableExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

// Encodable + JSON Data
extension Encodable {
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return try? encoder.encode(self)
    }
}

// Encodable + As Dictionary
extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
