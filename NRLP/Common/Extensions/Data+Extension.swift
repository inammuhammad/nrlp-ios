//
//  Data+Extension.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 26/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoKit

private func hexStringMime(_ iterator: Array<UInt8>.Iterator) -> String {
    return iterator.map { String(format: "%02x", $0) }.joined()
}

// Data + SHA256
extension Data {
    
    public var sha256: String {
        if #available(iOS 13.0, *) {
            return hexStringMime(SHA256.hash(data: self).makeIterator())
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            self.withUnsafeBytes { bytes in
                _ = CC_SHA256(bytes.baseAddress, CC_LONG(self.count), &digest)
            }
            return hexStringMime(digest.makeIterator())
        }
    }
    
}
