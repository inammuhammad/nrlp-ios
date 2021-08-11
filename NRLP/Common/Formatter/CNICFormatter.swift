//
//  CNICFormatter.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct CNICFormatter: FormatterProtocol {

    func format(string: String) -> String {

        let cleanCNIC = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXXX - XXXXXXX - X"

        var result = ""
        var index = cleanCNIC.startIndex
        for character in mask where index < cleanCNIC.endIndex {
            if character == "X" {
                result.append(cleanCNIC[index])
                index = cleanCNIC.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }

    func deFormat(string: String) -> String {
        let cleanCNIC = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return cleanCNIC
    }
}
