//
//  AppConstants.swift
//  1Link-NRLP
//
//  Created by VenD on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    
    private static var EncryptedBuildVersion: [UInt8] {
        let finalVersion = "\(sideMenuVersionNumber)".aesEncrypted(key: AESConfigs.keyConfigurationsFor(.randomKey).key, iv: AESConfigs.keyConfigurationsFor(.randomKey).iv)
        return Replacer().formatStringWithTerminator(string: finalVersion)
    }
    
    static var sideMenuVersionNumber: String {
        
         "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
    }
    
    static var versionNumber: String {
        var sign: [UInt8] = []
        if AppConstants.isDev {
            /// Dev Checksum (Previous checksum is commented)
//            sign = [51, 93, 20, 26, 65, 49, 90, 21, 122, 10, 87, 23, 91, 3, 7, 88, 3, 107, 1, 64, 30, 90, 10, 82, 56, 102, 36, 84, 14, 14, 13, 19] // g8fw2p4q9e9s2wn7m8d2h3i7v5k6dkng
            
            sign = [44, 86, 7, 8, 74, 39, 8, 23, 42, 87, 95, 10, 4, 71, 7, 8, 11, 36, 16, 69, 18, 88, 26, 16, 37, 59, 42, 17, 31, 0, 16, 13] // x3ue9ffsi81nm3ngewu7d1yukhesuesy
            
        } else {
            /// Prod Checksum (Previous checksum is commented)
            // sign = [48, 92, 25, 42, 63, 52, 13, 33, 57, 0, 43, 45, 62, 68, 42, 95, 25, 1, 63, 21, 32, 35, 13, 93, 55, 5, 26, 84, 35, 39, 13, 5]
            // d9kGLucEzoEIW0C0wRZgVJn8yVU6IBnq
            
            // sign = [98, 50, 40, 57, 35, 48, 12, 51, 118, 12, 23, 38, 25, 16, 36, 2, 87, 62, 82, 8, 38, 94, 34, 32, 28, 53, 25, 32, 1, 15, 1, 27]
            // 6WZTPqbW5cyBpdMm9m7zP7AERfVBkjbo
            
            sign = [99, 41, 69, 61, 37, 115, 93, 86, 46, 44, 43, 33, 47, 18, 49, 22, 58, 53, 86, 22, 16, 25, 83, 4, 123, 60, 57, 52, 90, 31, 50, 0]
            // 7L7PV232mCEEFfXyTf3dfp0a5ovV0zQt
        }

        return Replacer().deformatString(string: sign)
    }
    
    static var isDev: Bool {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path)
            if let env = dict?["Environment"] as? String,
                env == "Dev" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    static var environment: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path)
            if let env = dict?["Environment"] as? String {
                return env
            } else {
                return ""
            }
        }
        return ""
    }
    
    static var buildNumber: Int {
        return Int((Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1") ?? 1
    }
    
    static var aboutNRLPUrl: String {
//        "https://1link.net.pk/product-services/"
        "https://1link.net.pk/sohni-dharti/#1633123604420-798e6f70-2ecf"
    }

    static var osVersion: String {
        UIDevice.current.systemVersion
    }

    static var osName: String {
        "iOS"
    }
    
    static var deviceName: String {
        UIDevice.current.name
    }
    
    static var appLanguage: AppLanguage? {
        NRLPUserDefaults.shared.cachedSelectedLanguage
    }
    
    static var isAppLanguageUrdu: Bool {
        AppConstants.appLanguage == .urdu
    }
    
    static var systemLanguage: AppLanguage? {
        AppLanguage(rawValue: Locale.current.languageCode ?? "en") ?? .english
    }
    
    static func isSystemLanguageUrdu() -> Bool {
        return Locale.current.languageCode == "ur"
    }
    
    static var scaleRatio: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let standardSize = iPhone7Size
        let ratio = screenWidth / standardSize.width
        return ratio
    }
    
    public static var iPhone7Size: CGSize {
        return CGSize(width: 375, height: 667)
    }
}
