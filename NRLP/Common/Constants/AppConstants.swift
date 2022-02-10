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
//            sign = [57, 12, 2, 29, 69, 57, 20, 1, 113, 10, 8, 6, 0, 16, 17, 30, 95, 43, 29, 30, 3, 13, 90, 92, 126, 41, 120, 10, 83, 20, 27, 65] // mipp6xze2efbidxq1xxlud990z7h9qx5
            
            sign = [62, 4, 75, 88, 1, 120, 8, 84, 115, 8, 87, 92, 93, 22, 80, 8, 5, 42, 31, 65, 5, 26, 27, 2, 56, 43, 40, 10, 19, 1, 25, 23] // ja95r9f00g984b9gkyz3ssxgvxghydzc
            
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
