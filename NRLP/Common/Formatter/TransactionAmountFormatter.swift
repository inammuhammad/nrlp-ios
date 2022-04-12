//
//  TransactionAmountFormatter.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 12/04/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct TransactionAmountFormatter: FormatterProtocol {
    func format(string: String) -> String {

        if string.isBlank {
            return string
        }

        let cleanCurrency = string.replacingOccurrences(of: ",", with: "")
        let splitPart = cleanCurrency.split(separator: ".")

        let amount = String(splitPart.first ?? "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.allowsFloats = true
        formatter.notANumberSymbol = "NA"

        let formattedNumber = formatter.number(from: amount) ?? 0
        let formattedString = "\(formatter.string(from: formattedNumber)!)"

        return formattedString
    }

    func deFormat(string: String) -> String {
        return string.replacingOccurrences(of: ",", with: "")
    }

}
