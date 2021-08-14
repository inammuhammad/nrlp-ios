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
         let sign: [UInt8] = [49, 1, 23, 12, 21, 37, 93, 93, 32, 10, 12, 7, 94, 21, 15, 95, 88, 100, 1, 67, 21, 80, 80, 3, 119, 48, 120, 80, 82, 83, 2, 16]
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
