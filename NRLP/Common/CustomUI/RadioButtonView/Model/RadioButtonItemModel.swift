//
//  RadioButtonItemModel.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct RadioButtonItemModel {
    var isSelected: Bool
    var title: String
    var key: String
    var itemStyle: RadioButtonItemStyle

    init(isSelected: Bool = false, title: String, key: String, itemStyle: RadioButtonItemStyle = .imageBeforeLabel) {
        self.isSelected = isSelected
        self.title = title
        self.key = key
        self.itemStyle = itemStyle
    }
}
