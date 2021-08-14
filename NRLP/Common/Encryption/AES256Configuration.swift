//
//  AES256Configuration.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 15/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

final class AESConfigs {
    static fileprivate let configuration = AES256Configuration()
    static var currentConfiguration: Configs = .normal
    enum Configs {
        case randomKey
        case normal
        case updateUUID
        case register
    }
    
    static var hasIV: Bool {
        return configuration.hasIV
    }
    
    static func setIV(iv: String) {
        configuration.setIV(iv: iv)
    }
    
    static func resetIV() {
        configuration.resetIV()
        RequestKeyGenerator.reset()
    }
    
    static func getCurrentConfigurations() -> (key: String, iv: String) {
        return keyConfigurationsFor(currentConfiguration)
    }
    
    static func keyConfigurationsFor(_ config: Configs) -> (key: String, iv: String) {
        switch config {
        case .randomKey:
            return configuration.randomKeyConfigurations()
        case .normal:
            return configuration.normal()
        case .register:
            return configuration.register()
        case .updateUUID:
            return configuration.updateUUID()
        }
    }
}

private final class AES256Configuration {
    private var iv: String = ""
    
    var hasIV: Bool {
        return !iv.isEmpty
    }
    
    var secret1: String {
        let key: [UInt8]
        if AppConstants.isDev {
            key = [97, 81, 69, 15, 49, 59, 10, 84, 36, 28, 63, 80, 39, 55, 63, 3, 6, 101, 32, 48, 4, 32, 16, 18, 7, 22, 10, 0, 30, 47, 38, 44, 29, 0, 69, 95, 58, 114, 86, 40, 2, 94, 37, 7, 10, 65, 36, 53, 41, 11, 92, 7, 26, 57, 2, 1, 15, 11, 60, 49, 0, 11, 12, 67]
        } else {
            key = []
        }
        return Replacer().deformatString(string: key)
    }
   
    var secret2: String {
        let key: [UInt8]
        if AppConstants.isDev {
            key = [1, 85, 74, 56, 6, 18, 35, 92, 55, 95, 37, 28, 93, 46, 40, 4, 92, 22, 23, 59, 61, 32, 34, 34, 15, 58, 122, 9, 43, 38, 40, 3, 34, 40, 61, 41, 20, 2, 47, 41, 11, 33, 57, 61, 45, 54, 19, 7, 30, 37, 32, 10, 36, 4, 32, 61, 29, 42, 62, 20, 41, 46, 50, 55]
        } else {
            key = []
        }
        return Replacer().deformatString(string: key)
    }
    
    var secret3: String {
        let key: [UInt8]
        if AppConstants.isDev {
            key = [23, 46, 40, 15, 71, 115, 36, 55, 10, 87, 25, 43, 57, 34, 33, 40, 60, 11, 11, 54, 20, 80, 37, 52, 34, 53, 121, 32, 92, 84, 91, 56, 27, 60, 64, 95, 71, 10, 12, 87, 38, 91, 41, 87, 10, 46, 15, 55, 25, 22, 85, 58, 46, 16, 45, 55, 54, 23, 30, 0, 14, 93, 25, 45]
        } else {
            key = []
        }
        return Replacer().deformatString(string: key)
    }
    
    var deviceID: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    func setIV(iv: String) {
        self.iv = iv
    }
    
    func resetIV() {
        iv = ""
    }
    
    func randomKeyConfigurations() -> (key: String, iv: String) {
        return (secret1.stringPrefix(32), secret1.stringSuffix(16))
    }
    
    func normal() -> (key: String, iv: String) {
        return (deviceID.stringPrefix(32), iv)
    }
    
    func register() -> (key: String, iv: String) {
        return(secret3.stringPrefix(32), iv)
    }
    
    func updateUUID() -> (key: String, iv: String) {
        return(secret2.stringPrefix(32), iv)
    }
}
