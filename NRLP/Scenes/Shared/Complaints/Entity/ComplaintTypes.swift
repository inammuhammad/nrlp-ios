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
    case unableToReceiveRegistrationCode
    case unableToReceiveOTP
    case unableToAddBeneficiary
    case unableToTransferPointsToBeneficiary
    case unableToSelfAwardPoints
    case redemptionIssues
    case others
    
    func getTitle() -> String {
        switch self {
        case .unableToRegister:
            return "Unable to register".localized
        case .unableToReceiveRegistrationCode:
            return "Unable to receive Registration Code".localized
        case .unableToReceiveOTP:
            return "Unbale To receive OTP".localized
        case .unableToAddBeneficiary:
            return "Unable to add beneficiary".localized
        case .unableToTransferPointsToBeneficiary:
            return "Unable to transfer points to beneficiary".localized
        case .unableToSelfAwardPoints:
            return "Unable to self award points".localized
        case .redemptionIssues:
            return "Redemption Issues".localized
        case .others:
            return "Others".localized
        }
    }
    
    func getComplaintTypeCode() -> Int {
        switch self {
        case .unableToRegister:
            return 1
        case .unableToReceiveRegistrationCode:
            return 2
        case .unableToReceiveOTP:
            return 3
        case .unableToAddBeneficiary:
            return 4
        case .unableToTransferPointsToBeneficiary:
            return 5
        case .unableToSelfAwardPoints:
            return 6
        case .redemptionIssues:
            return 7
        case .others:
            return 8
        }
    }
    
    static func fromRaw(raw: String) -> ComplaintTypes {
        ComplaintTypes(rawValue: raw) ?? .others
    }
}
