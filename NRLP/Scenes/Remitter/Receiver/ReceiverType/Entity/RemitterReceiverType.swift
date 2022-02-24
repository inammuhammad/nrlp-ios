//
//  RemitterReceiverType.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

enum RemitterReceiverType: String {
    case cnic
    case bank

    func getTitle() -> String {
        switch self {
        case .cnic:
            return "Remittance sent to CNIC".localized
        case .bank:
            return "Remittance sent to Bank Account".localized
        }
    }
    
    static func fromRaw(raw: String) -> RemitterReceiverType {
        RemitterReceiverType(rawValue: raw) ?? .cnic
    }
}

struct RemitterReceiverTypePickerItemModel: PickerItemModel {
    var title: String
    var key: String

    var receiverType: RemitterReceiverType? {
        return RemitterReceiverType(rawValue: key)
    }
}
