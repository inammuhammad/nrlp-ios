//
//  ErrorConstants.swift
//  1Link-NRLP
//
//  Created by VenD on 29/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

enum ErrorConstants: String, CaseIterable {
    case sessionExpire = "GEN-ERR-08"
    case deviceNotRegistered = "AUTH-LOG-02"
    
    case auth_cp_01 = "AUTH-CP-01"
    case auth_cp_02 = "AUTH-CP-02"
    case auth_cp_03 = "AUTH-CP-03"
    case auth_cp_04 = "AUTH-CP-04"
    case auth_cp_05 = "AUTH-CP-05"
    case auth_cp_06 = "AUTH-CP-06"
    
    var localized: String {
        self.rawValue.localized
    }
}
