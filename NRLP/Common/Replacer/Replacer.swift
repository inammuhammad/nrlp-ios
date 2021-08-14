//
//  Replacer.swift
//  1Link-NRLP
//
//  Created by VenD on 21/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class Replacer {
    private var terminator: String

    init(with terminator: String = "\(String(describing: TermsAndConditionService.self))\(String(describing: NSObject.self))") {
        self.terminator = terminator
    }

    func formatStringWithTerminator(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let preFormat = [UInt8](self.terminator.utf8)
        let length = preFormat.count

        var formatedString = [UInt8]()
        for t in text.enumerated() {
            formatedString.append(cleanFormatedString(string: t.element, removalPart: preFormat[t.offset % length]))
        }
        return formatedString
    }

    func cleanFormatedString(string: UInt8, removalPart: UInt8) -> UInt8 {
        return string ^ removalPart
    }

    func deformatString(string: [UInt8]) -> String {
        let preFormat = [UInt8](self.terminator.utf8)
        let length = preFormat.count
        var deformatedString = [UInt8]()
        for k in string.enumerated() {
            deformatedString.append(cleanFormatedString(string: k.element, removalPart: preFormat[k.offset % length]))
        }
        return String(bytes: deformatedString, encoding: .utf8)!
    }
}
