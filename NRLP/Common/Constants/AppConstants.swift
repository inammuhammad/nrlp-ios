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
            
////            sign = [45, 93, 21, 20, 69, 42, 30, 82, 51, 90, 10, 0, 16, 21, 28, 92, 3, 42, 19, 75, 19, 30, 80, 31, 127, 38, 125, 27, 88, 6, 10, 66] // y8gy6kp6p5ddyau3myv9ew3z1u2y2ci6 (iXGuard)
//            sign = [53, 6, 23, 14, 1, 43, 15, 84, 117, 31, 11, 5, 24, 67, 13, 3, 29, 100, 3, 19, 64, 0, 91, 1, 118, 41, 58, 90, 27, 31, 21, 67]// acecrja06peaq7dls7fa6i8d8zu8qzv7 (Without iXGuard)
            
            sign = [45, 13, 10, 1, 67, 53, 0, 8, 39, 86, 87, 92, 10, 30, 17, 14, 90, 36, 8, 4, 6, 89, 18, 3, 63, 99, 119, 27, 92, 13, 20, 67] // yhxl0tnld998cjxa4wmvp0qfq08y6hw7
        } else {
            /// Prod Checksum (Previous checksum is commented)
//            sign = [39, 84, 0, 91, 9, 34, 28, 16, 44, 9, 86, 0, 31, 17, 4, 91, 86, 43, 28, 27, 20, 91, 6, 86, 36, 36, 56, 3, 5, 87, 82, 13] // s1r6zcrtof8dvem48xyib2e3jwwao21y
            
            sign = [54, 19, 24, 0, 65, 37, 10, 3, 32, 93, 23, 22, 95, 70, 19, 88, 94, 58, 28, 7, 78, 91, 12, 14, 63, 36, 43, 5, 93, 86, 81, 18] // bvjm2ddgc2yr62z70iyu82okqwdg732f
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
