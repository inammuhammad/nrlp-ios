//
//  RedeemServiceRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 02/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
@testable import NRLP


class RedeemServiceRouterMock: RedeemServiceRouter {
 
    var inNavigatedToOTPScreen: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override func gotoOTPScreen(transactionId: String, partner: Partner?, user: UserModel) {
        inNavigatedToOTPScreen = true
        super.gotoOTPScreen(transactionId: transactionId, partner: partner, user: user)
    }
}
