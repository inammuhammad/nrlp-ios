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
    case receiverManagement
    case faqs
    case guide
    case languageSelection
    case contactUs
    case complaint
    case logout
 
    func getTitle() -> String {
        switch self {
        case .profile:
            return "Profile".localized
        case .changePassword:
            return "Change Password".localized
        case .receiverManagement:
            return "Remittance Receiver Management".localized
        case .faqs:
            return "FAQs".localized
        case .guide:
            return "Guide".localized
        case .languageSelection:
            return "Language Selection".localized
        case .contactUs:
            return "Contact Us".localized
        case .complaint:
            return "Complaint Management".localized
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
        case .receiverManagement:
            return UIImage(named: "remitter-receiver-side-menu") ?? UIImage()
        case .faqs:
            return #imageLiteral(resourceName: "faqs")
        case .guide:
            return UIImage(named: "guide-side-menu-2") ?? UIImage()
        case .languageSelection:
            return #imageLiteral(resourceName: "translateIcon")
        case .contactUs:
            return #imageLiteral(resourceName: "contactIcon")
        case .complaint:
            return UIImage(named: "complaints-side-menu") ?? UIImage()
        case .logout:
            return #imageLiteral(resourceName: "logout")
        }
    }
}
