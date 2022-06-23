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
            // sign = [48, 7, 23, 92, 17, 34, 13, 80, 122, 13, 90, 81, 95, 16, 81, 94, 94, 99, 85, 20, 70, 81, 85, 85, 42, 107, 41, 3, 95, 81, 91, 71]
            // dbe1bcc49b456d81000f0860d8fa5483
            
            // sign = [33, 47, 25, 94, 21, 56, 27, 46, 32, 87, 15, 80, 62, 32, 80, 9, 39, 39, 80, 30, 47, 62, 11, 48, 26, 1, 9, 27, 28, 7, 50, 39]
            // uJk3fyuJc8a4WT9fIt5lYWhUTRFyvbQS
            
            sign = [103, 53, 38, 5, 32, 44, 63, 12, 25, 59, 39, 48, 91, 26, 31, 21, 58, 32, 63, 2, 27, 15, 14, 92, 10, 55, 127, 19, 26, 50, 16, 54]
            // 3PThSmQhZTIT2nvzTsZpmfm9Dd0qpWsB
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
