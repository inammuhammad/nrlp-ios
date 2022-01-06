//
//  HashRequestWrapper.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 13/01/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

struct HashRequestWrapper<T: Encodable>: Encodable {
    let payload: T
    private let hash: String
    
    init(payload: T) {
        self.payload = payload
        if let payloadDictionary = try? payload.asDictionary(), let data =  payloadDictionary.json().data(using: .utf8) {
            hash = data.sha256.aesEncrypted()
            print(data.sha256)
        } else {
            hash = ""
        }
    }
    
    func encode(to encoder: Encoder) throws {
        try payload.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hash, forKey: .hash)
    }

    enum CodingKeys: String, CodingKey {
        case hash
    }
}
