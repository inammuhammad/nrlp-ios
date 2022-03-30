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
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject?

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
    static private let keyPersistantUUID = SDRPNamePrefix + "persistanUUID"
    
    static var persistanUUID: String? {
        get {
            var deviceId =  UserDefaults.standard.string(forKey: keyPersistantUUID)

            if deviceId == nil {
                // Get Device Id from Keychain
                if let data = KeyChain.load(key: keyPersistantUUID) {
                    deviceId = String(data: data, encoding: .utf8)
                    
                    UserDefaults.standard.set(deviceId, forKey: keyPersistantUUID)
                    UserDefaults.standard.synchronize()
                }
            }
            
            return deviceId
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyPersistantUUID)
            UserDefaults.standard.synchronize()
            
            // Update in Keychain
            let status = KeyChain.save(key: keyPersistantUUID, data: Data((newValue ?? "").utf8))
            if status == noErr {
                print("device id saved in keychain")
            } else {
                print("failed to save device id in keychain")
            }
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
