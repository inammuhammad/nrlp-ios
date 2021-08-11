//
//  PassportTypePickerItemModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 10/08/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

struct PassportTypePickerItemModel: PickerItemModel {
    var title: String
    var key: String

    var passportType: PassportType? {
        return PassportType(rawValue: key)
    }
}
