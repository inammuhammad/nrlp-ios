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
typealias AlertTextFieldCallBack = (String) -> ()

struct AlertViewModel {
    var alertHeadingImage: AlertIllustrationType
    var alertTitle: String?
    var alertDescription: String?
    var alertAttributedDescription: NSAttributedString?

    var primaryButton: AlertActionButtonModel
    var secondaryButton: AlertActionButtonModel?
    
    var topTextField: AlertTextFieldModel?
    var middleTextField: AlertTextFieldModel?
    var bottomTextField: AlertTextFieldModel?
}

struct AlertActionButtonModel {
    var buttonTitle: String
    var buttonAction: AlertActionButtonCallBack?
}

struct AlertTextFieldModel {
    var titleLabelText: String?
    var placeholderText: String?
    var inputText: String?
    var inputFieldMaxLength: Int?
    var inputFieldMinLength: Int?
    var editKeyboardType: UIKeyboardType?
    var formatValidator: FormatValidatorProtocol?
    var formatter: FormatterProtocol?
    var onTextFieldChanged: AlertTextFieldCallBack?
}
