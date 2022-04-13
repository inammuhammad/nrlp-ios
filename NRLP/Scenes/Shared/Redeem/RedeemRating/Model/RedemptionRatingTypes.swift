//
//  RedemptionRatingTypes.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//

import Foundation

enum RedemptionRatingTypes: String {
    case good
    case satisfactory
    case unsatisfactory
    
    func getTitle() -> String {
        switch self {
        case .good:
            return "Good".localized
        case .satisfactory:
            return "Satisfactory".localized
        case .unsatisfactory:
            return "Unsatisfactory".localized
        }
    }
    
    func getComplaintTypeCode() -> Int {
        switch self {
        case .good:
            return 1
        case .satisfactory:
            return 2
        case .unsatisfactory:
            return 3
        }
    }
    
    static func fromRaw(raw: String) -> RedemptionRatingTypes {
        RedemptionRatingTypes(rawValue: raw) ?? .good
    }
}
