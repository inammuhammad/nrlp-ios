//
//  TransactionType.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 06/04/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct TransactionTypePickerItemModel: PickerItemModel {
    var title: String
    var key: String

    var transactionType: TransactionType? {
        return TransactionType(rawValue: key)
    }
}
