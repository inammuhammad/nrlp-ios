//
//  RegexConstants.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct RegexConstants {
    static let nameRegex = "^[\\p{L}][\\p{L} ]{0,50}$" // "^[A-Z][a-z]+(\\s[A-Z][a-z]+)*$" //"^[\\p{L}'-][\\p{L}' -]{0,50}$"
    static let cnicRegex = "^\\d{13}$"
    static let emailRegex = "|[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    //"^|[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    static let loginPaasswordRegex = "^(.){8,}$"
    static let paasswordRegex = "^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\\d]){1,})(?=(.*[\\W]){1,})(?!.*\\s).{8,}$"
    static let passportRegex = "^(?!^0+$)[a-zA-Z0-9]{9,20}$"
    static let registrationCodeRegex = "^([a-zA-Z0-9_-]){5,}$"
    static let referenceNumberRegex = "^(\\S{1,25})$"
    static let transactionAmountRegex = "^\\d*\\.?\\d*$"
    static let mobileNumberRegex = "^[0-9]+$"
    static let otpValidateRegex = "^[0-9]*$"
    static let loyaltyPointsRegex = "^\\d{1,13}$"
    static let agentPointsRegex = "^[a-zA-Z0-9_]{6}$"
    static let htmlRegex = "</?\\w+((\\s+\\w+(\\s*=\\s*(?:\".*?\"|'.*?'|[\\^'\">\\s]+))?)+\\s*|\\s*)/?>"
    static let ibanRegex = "^[a-zA-Z0-9]{1,14}\\d{10}$"
    static let residentId = "^[a-zA-Z0-9]{1,}$"
    static let beneficiaryRelation = "[a-zA-Z]+( [a-zA-Z]+)*$"
}
