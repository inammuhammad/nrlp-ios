//
//  ComplaintTypes.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

enum ComplaintTypes: String {
    case unableToRegister
    case unableToReceiveOTP
    case others
    case unableToAddBeneficiary
    case unableToTransferPointsToBeneficiary
    case unableToSelfAwardPoints
    case redemptionIssues
    
    func getTitle() -> String {
        switch self {
        case .unableToRegister:
            return "Unable to register".localized
        case .unableToReceiveOTP:
            return "Unbale To receive OTP".localized
        case .others:
            return "Others".localized
        case .unableToAddBeneficiary:
            return "Unable to add beneficiary".localized
        case .unableToTransferPointsToBeneficiary:
            return "Unable to transfer points to beneficiary".localized
        case .unableToSelfAwardPoints:
            return "Unable to self award points".localized
        case .redemptionIssues:
            return "Redemption Issues".localized
        }
    }
    
    static func fromRaw(raw: String) -> ComplaintTypes {
        ComplaintTypes(rawValue: raw) ?? .others
    }
}
