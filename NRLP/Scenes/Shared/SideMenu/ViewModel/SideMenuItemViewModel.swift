//
//  SideMenuItemViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 17/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

enum SideMenuItem: Int {
    
    case profile
    case changePassword
    case faqs
    case languageSelection
    case contactUs
    case logout
 
    func getTitle() -> String {
        switch self {
        case .profile:
            return "Profile".localized
        case .changePassword:
            return "Change Password".localized
        case .faqs:
            return "FAQs".localized
        case .languageSelection:
            return "Language Selection".localized
        case .contactUs:
            return "Contact Us".localized
        case .logout:
            return "Logout".localized
        }
    }

    func getIcon() -> UIImage {
        switch self {
        case .profile:
            return #imageLiteral(resourceName: "editProfile")
        case .changePassword:
            return #imageLiteral(resourceName: "changePassword")
        case .faqs:
            return #imageLiteral(resourceName: "faqs")
        case .languageSelection:
            return #imageLiteral(resourceName: "translateIcon")
        case .contactUs:
            return #imageLiteral(resourceName: "contactIcon")
        case .logout:
            return #imageLiteral(resourceName: "logout")
        }
    }
}
