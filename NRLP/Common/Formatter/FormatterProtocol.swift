//
//  FormatterProtocol.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

protocol FormatterProtocol {
    func format(string: String) -> String
    func deFormat(string: String) -> String
}
