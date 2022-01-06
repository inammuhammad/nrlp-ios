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
            //PROD KEY
//            key = [46, 47, 52, 56, 7, 24, 20, 30, 19, 41, 15, 5, 40, 34, 3, 43, 58, 3, 83, 58, 27, 90, 26, 92, 36, 36, 31, 84, 59, 80, 52, 30, 97, 81, 16, 41, 37, 25, 90, 48, 45, 31, 56, 51, 3, 22, 56, 8, 57, 9, 1, 55, 79, 35, 87, 34, 36, 50, 124, 10, 39, 35, 14, 55]
            
            //DEV KEY
            key = [97, 81, 69, 15, 49, 59, 10, 84, 36, 28, 63, 80, 39, 55, 63, 3, 6, 101, 32, 48, 4, 32, 16, 18, 7, 22, 10, 0, 30, 47, 38, 44, 29, 0, 69, 95, 58, 114, 86, 40, 2, 94, 37, 7, 10, 65, 36, 53, 41, 11, 92, 7, 26, 57, 2, 1, 15, 11, 60, 49, 0, 11, 12, 67]
        }
        return Replacer().deformatString(string: key)
    }
   
    var secret2: String {
        let key: [UInt8]
        if AppConstants.isDev {
            key = [1, 85, 74, 56, 6, 18, 35, 92, 55, 95, 37, 28, 93, 46, 40, 4, 92, 22, 23, 59, 61, 32, 34, 34, 15, 58, 122, 9, 43, 38, 40, 3, 34, 40, 61, 41, 20, 2, 47, 41, 11, 33, 57, 61, 45, 54, 19, 7, 30, 37, 32, 10, 36, 4, 32, 61, 29, 42, 62, 20, 41, 46, 50, 55]
        } else {
            //PROD KEY
//            key = [7, 93, 3, 15, 3, 10, 90, 23, 9, 36, 36, 0, 8, 50, 26, 7, 89, 42, 61, 57, 66, 62, 4, 18, 58, 6, 9, 22, 43, 60, 4, 14, 37, 1, 40, 7, 20, 16, 38, 35, 23, 61, 52, 29, 2, 56, 45, 13, 12, 11, 38, 33, 69, 19, 52, 83, 12, 24, 120, 84, 15, 51, 4, 39]
            
            //DEV KEY
            key = [1, 85, 74, 56, 6, 18, 35, 92, 55, 95, 37, 28, 93, 46, 40, 4, 92, 22, 23, 59, 61, 32, 34, 34, 15, 58, 122, 9, 43, 38, 40, 3, 34, 40, 61, 41, 20, 2, 47, 41, 11, 33, 57, 61, 45, 54, 19, 7, 30, 37, 32, 10, 36, 4, 32, 61, 29, 42, 62, 20, 41, 46, 50, 55]
        }
        return Replacer().deformatString(string: key)
    }
    
    var secret3: String {
        let key: [UInt8]
        if AppConstants.isDev {
            key = [23, 46, 40, 15, 71, 115, 36, 55, 10, 87, 25, 43, 57, 34, 33, 40, 60, 11, 11, 54, 20, 80, 37, 52, 34, 53, 121, 32, 92, 84, 91, 56, 27, 60, 64, 95, 71, 10, 12, 87, 38, 91, 41, 87, 10, 46, 15, 55, 25, 22, 85, 58, 46, 16, 45, 55, 54, 23, 30, 0, 14, 93, 25, 45]
        } else {
            //PROD KEY
//            key = [26, 43, 3, 47, 25, 55, 3, 15, 39, 62, 25, 30, 16, 17, 42, 39, 24, 96, 46, 10, 3, 57, 49, 41, 22, 9, 62, 15, 1, 45, 6, 7, 102, 38, 1, 35, 7, 59, 23, 37, 119, 1, 43, 20, 36, 63, 26, 10, 86, 2, 51, 62, 37, 14, 45, 82, 0, 10, 8, 1, 31, 53, 81, 55]
            
            //DEV KEY
            key = [23, 46, 40, 15, 71, 115, 36, 55, 10, 87, 25, 43, 57, 34, 33, 40, 60, 11, 11, 54, 20, 80, 37, 52, 34, 53, 121, 32, 92, 84, 91, 56, 27, 60, 64, 95, 71, 10, 12, 87, 38, 91, 41, 87, 10, 46, 15, 55, 25, 22, 85, 58, 46, 16, 45, 55, 54, 23, 30, 0, 14, 93, 25, 45]
        }
        return Replacer().deformatString(string: key)
    }
    
    var deviceID: String {
        if let deviceID = Defaults.persistanUUID {
            return deviceID
        } else {
            let newID = NSUUID().uuidString
            Defaults.persistanUUID = newID
            return newID
        }
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
