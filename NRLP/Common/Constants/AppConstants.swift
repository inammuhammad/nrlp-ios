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
            
//            let sign: [UInt8] = [49, 1, 23, 12, 21, 37, 93, 93, 32, 10, 12, 7, 94, 21, 15, 95, 88, 100, 1, 67, 21, 80, 80, 3, 119, 48, 120, 80, 82, 83, 2, 16] // edeafd39cebc7af067d1c93f9c7286ad
            sign = [45, 13, 10, 1, 67, 53, 0, 8, 39, 86, 87, 92, 10, 30, 17, 14, 90, 36, 8, 4, 6, 89, 18, 3, 63, 99, 119, 27, 92, 13, 20, 67] // yhxl0tnld998cjxa4wmvp0qfq08y6hw7
        } else {
            /// Prod Checksum (Previous checksum is commented)
            
//            let sign: [UInt8] = [49, 1, 23, 12, 21, 37, 93, 93, 32, 10, 12, 7, 94, 21, 15, 95, 88, 100, 1, 67, 21, 80, 80, 3, 119, 48, 120, 80, 82, 83, 2, 16] // edeafd39cebc7af067d1c93f9c7286ad
            sign = [39, 84, 0, 91, 9, 34, 28, 16, 44, 9, 86, 0, 31, 17, 4, 91, 86, 43, 28, 27, 20, 91, 6, 86, 36, 36, 56, 3, 5, 87, 82, 13] // s1r6zcrtof8dvem48xyib2e3jwwao21y
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
