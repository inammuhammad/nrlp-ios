//
//  KeyChain.swift
//  NRLP
//
//  Created by Bilal Iqbal on 30/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import Security
import UIKit

class KeyChain {

    static let DeviceIDKey: String = "DEVICE_ID"
    
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
}

class Defaults {
    
    static private let SDRPNamePrefix: String = "SohniDhartiRemittanceProgram"
    
    static var persistanUUID : String?{
        set{
            UserDefaults.standard.set(newValue, forKey: SDRPNamePrefix + "persistanUUID")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: SDRPNamePrefix + "persistanUUID")
        }
    }
}

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

