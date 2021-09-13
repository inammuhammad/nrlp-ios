//
//  RelationshipTypePickerItemModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 13/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

struct RelationshipTypePickerItemModel: PickerItemModel {
    var title: String
    var key: String

    var relationshipType: RelationshipType? {
        return RelationshipType(rawValue: key)
    }
}

enum RelationshipType: String {
    case mother
    case father
    case child
    case friend
    case spouse
    case other

    func getTitle() -> String {
        switch self {
        case .mother:
            return "Mother".localized
        case .father:
            return "Father".localized
        case .child:
            return "Child".localized
        case .friend:
            return "Friend".localized
        case .spouse:
            return "Spouse".localized
        case .other:
            return "Other".localized
        }
    }
    
    static func fromRaw(raw: String) -> RelationshipType {
        RelationshipType(rawValue: raw) ?? .mother
    }
}
