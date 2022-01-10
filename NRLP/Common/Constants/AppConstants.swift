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
//            sign = [54, 19, 24, 0, 65, 37, 10, 3, 32, 93, 23, 22, 95, 70, 19, 88, 94, 58, 28, 7, 78, 91, 12, 14, 63, 36, 43, 5, 93, 86, 81, 18] // bvjm2ddgc2yr62z70iyu82okqwdg732f
            
            sign = [54, 9, 2, 1, 67, 115, 30, 19, 54, 24, 93, 85, 94, 76, 29, 9, 23, 53, 21, 65, 3, 26, 82, 81, 61, 32, 46, 9, 2, 85, 13, 26] // blpl02pwuw3178tfyfp3us14ssakh0nn
            
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
