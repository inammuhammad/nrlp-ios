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
    
    static var sideMenuVersionNumber: String {
        
         "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
    }
    
    static var versionNumber: String {
        
         let sign: [UInt8] = [112, 87, 16, 73, 66, 113, 74, 54, 119, 37, 94, 54, 61, 19, 1, 0, 54, 23, 81, 51, 61, 39, 76, 38, 43, 60, 34, 59, 31, 29, 0, 37, 0, 45, 29, 21, 68, 20, 60, 41, 4, 94, 38, 43, 40, 71, 7, 5, 3, 58, 9, 34, 24, 26, 7, 46, 7, 53, 9, 49]
        //[112, 87, 16, 73, 66, 113, 74, 8, 5, 21, 22, 51, 14, 77, 58, 12, 1, 34, 82, 26, 71, 59, 25, 34, 24, 57, 27, 13, 37, 75, 52, 18, 23, 40, 25, 20, 67, 3, 88, 61, 5, 65, 31, 8, 92, 30, 88, 94, 55, 11, 15, 31, 89, 30, 83, 54, 41, 97, 6, 19]
        return Replacer().deformatString(string: sign)
       // "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
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
        "https://1link.net.pk/product-services/"
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
