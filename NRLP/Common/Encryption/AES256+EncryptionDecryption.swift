//
//  AES256+EncryptionDecryption.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 06/01/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import CommonCrypto

struct AES256 {
    private var key: Data
    private var iv: Data
    
    public init(key: Data, iv: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw Error.badKeyLength
        }
        guard iv.count == kCCBlockSizeAES128 else {
            throw Error.badInputVectorLength
        }
        self.key = key
        self.iv = iv
    }
    
    public init(key: String, iv: String) throws {
        try self.init(key: key.data(using: .utf8)!, iv: iv.data(using: .utf8)!)
    }
    
    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }
    
    func encrypt(_ digest: Data) throws -> Data {
        return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }
    
    func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }
    
    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        if let cryptData = NSMutableData(length: Int(input.count) + kCCBlockSizeAES128) {
            let keyLength = size_t(kCCKeySizeAES256)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES)
            var numBytesEncrypted: size_t = 0
            status = CCCrypt(operation,
                             algoritm,
                             CCOptions(kCCOptionPKCS7Padding),
                             (key as NSData).bytes,
                             keyLength,
                             String(data: iv, encoding: .utf8),
                             (input as NSData).bytes,
                             input.count,
                             cryptData.mutableBytes,
                             cryptData.length,
                             &numBytesEncrypted)
            
            guard status == kCCSuccess else {
                throw Error.cryptoFailed(status: status)
            }
            cryptData.length = Int(numBytesEncrypted)
            return cryptData as Data
        }
        throw Error.cryptoFailed(status: status)
    }
}

// MARK: - AES256 base64Encoding Strings Enncryption and Decryption
extension AES256 {
    func encryptedString(for string: String) throws -> String {
        guard let digest = string.data(using: String.Encoding.utf8) else {return ""}
        let cryptData = try crypt(input: digest, operation: CCOperation(kCCEncrypt))
        let base64cryptString = cryptData.base64EncodedString(options: .init(rawValue: 0)).base64urlToBase64()
        return base64cryptString
    }
    
    func decrypedtString(for string: String) throws -> String {
        guard let encrypted = NSData(base64Encoded: string.base64ToBase64URL(), options: .ignoreUnknownCharacters) else {return ""}
        let unencryptedData = try crypt(input: encrypted as Data, operation: CCOperation(kCCDecrypt))
        let unencryptedMessage = String(data: unencryptedData, encoding: .utf8)
        return unencryptedMessage ?? ""
    }
}
