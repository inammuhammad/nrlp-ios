//
//  CurrencyFormatter.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct CurrencyFormatter: FormatterProtocol {
    func format(string: String) -> String {

        if string.isBlank {
            return string
        }

        let onlyPoint = string.last == "."
        let cleanCurrency = string.replacingOccurrences(of: ",", with: "")
        let splitPart = cleanCurrency.split(separator: ".")

        var decimal = splitPart.count == 2 ? String(splitPart.last ?? "") : ""
        let amount = String(splitPart.first ?? "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.allowsFloats = true
        formatter.notANumberSymbol = "NA"

        let formatedNumber = formatter.number(from: amount) ?? 0
        var formattedString = "\(formatter.string(from: formatedNumber)!)"

        if onlyPoint {
            formattedString += "."
        } else if !decimal.isBlank {
            decimal = String(decimal.prefix(2))
            formattedString += ".\(decimal)"
        }

        return formattedString
    }

    func deFormat(string: String) -> String {
        return string.replacingOccurrences(of: ",", with: "")
    }

}
