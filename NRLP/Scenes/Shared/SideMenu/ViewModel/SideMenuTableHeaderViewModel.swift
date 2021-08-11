//
//  SideMenuTableHeaderViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 28/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct SideMenuTableHeaderViewModel {
    var name: String
    private var cnic: String

    var formattedCNIC: String {
        return CNICFormatter().format(string: cnic)
    }

    init(name: String, cnic: String) {
        self.name = name
        self.cnic = cnic
    }
}
