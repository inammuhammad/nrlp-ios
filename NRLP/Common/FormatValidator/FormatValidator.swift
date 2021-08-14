//
//  FormatValidatorProtocol.swift
//  1Link-NRLP
//
//  Created by VenD on 13/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

protocol FormatValidatorProtocol {
    var regex: String { get }
    var invalidFormatError: String { get }
    
    func isValid(for string: String) -> Bool
}

struct FormatValidator: FormatValidatorProtocol {
    var regex: String
    var invalidFormatError: String
    
    func isValid(for string: String) -> Bool {
        return string.isValid(for: regex)
    }
}

struct CNICFormatValidator: FormatValidatorProtocol {
    var regex: String
    var invalidFormatError: String
    
    func isValid(for string: String) -> Bool {
        let set = Set(string)
        return set.count > 1 && string.isValid(for: regex)
    }
}
