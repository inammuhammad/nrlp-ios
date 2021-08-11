//
//  RequestConvertable.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

protocol ObjectTranslatable {
    func toMap<T: Encodable>(withModel model: T) throws -> [String: Any]?
    func toObject<T: Decodable>(withData data: Data) throws -> T
    func toData<T: Encodable>(withModel model: T) throws -> Data
    func toData<T: Encodable>(withModel model: [T]) throws -> Data
}

struct JSONTranslation: ObjectTranslatable {

    func toMap<T: Encodable>(withModel model: T) throws -> [String: Any]? {
        let encodedData = try JSONEncoder().encode(model)
        return try JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any]
    }

    func toObject<T: Decodable>(withData data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    func toData<T: Encodable>(withModel model: T) throws -> Data {
        return try JSONEncoder().encode(model)
    }

    func toData<T: Encodable>(withModel model: [T]) throws -> Data {
           return try JSONEncoder().encode(model)
       }
}
