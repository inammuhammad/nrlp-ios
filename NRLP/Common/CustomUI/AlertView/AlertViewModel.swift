//
//  AlertViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias AlertActionButtonCallBack = () -> Void

struct AlertViewModel {
    var alertHeadingImage: AlertIllustrationType
    var alertTitle: String?
    var alertDescription: String?
    var alertAttributedDescription: NSAttributedString?

    var primaryButton: AlertActionButtonModel
    var secondaryButton: AlertActionButtonModel?
}

struct AlertActionButtonModel {
    var buttonTitle: String
    var buttonAction: AlertActionButtonCallBack?
}
