//
//  HomeCellCardType.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

enum HomeCellCardType {
    case loyalty
    case manageBeneficiary
    case managePoints
    case viewStatement
    case nrlpBenefits
    case selfAward

    func getTitle() -> String {
        switch self {
        case .manageBeneficiary:
            return "Manage Beneficiary".localized
        case .managePoints:
            return "Transfer Points".localized
        case .viewStatement:
            return "View Statement".localized
        case .nrlpBenefits:
            return "View NRLP Benefits".localized
        case .selfAward:
            return "Self Award Points".localized
        default:
            return ""
        }
    }

    func getSectionImage() -> UIImage {
        switch self {
        case .manageBeneficiary:
            return #imageLiteral(resourceName: "home-beneficiaries")
        case .managePoints:
            return #imageLiteral(resourceName: "home-loyalty-points")
        case .viewStatement:
            return #imageLiteral(resourceName: "home-loyalty-statement")
        case .nrlpBenefits:
            return #imageLiteral(resourceName: "benefits")
        case .selfAward:
            return UIImage(named: "selfAwardPoints") ?? UIImage()
        default:
            return UIImage()
        }
    }
}
