//
//  AccountTypePickerItemModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct AccountTypePickerItemModel: PickerItemModel {
    var title: String
    var key: String

    var accountType: AccountType? {
        return AccountType(rawValue: key)
    }
}
