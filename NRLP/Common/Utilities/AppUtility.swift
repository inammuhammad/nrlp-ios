//
//  AppUtility.swift
//  1Link-NRLP
//
//  Created by VenD on 17/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

typealias OnUtilityFailure = (String) -> Void

final class AppUtility {
    static func goToDialer(phoneNumber: String, onFailture: OnUtilityFailure) {
        if let url = URL(string: "tel://\(phoneNumber)"),
        UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10, *) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            onFailture("Can't open Dialer")
        }
    }
    
    static func goToEmail(email: String, onFailture: OnUtilityFailure) {
        if let emailURL = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        } else {
            onFailture("Can't open Email client")
        }
    }
    
    static func goToWebsite(url: String, onFailture: OnUtilityFailure) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        } else {
           onFailture("Cant open Website")
       }
    }
    
    static func getPrettyJson(data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self)
        } else {
            return "json data malformed"
        }
    }
}
