//
//  TermsAndConditionResponseModel.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct TermsAndConditionResponseModel: Codable {
    var message: String
    var data: TermsAndConditionContentModel?
}

struct TermsAndConditionContentModel: Codable {
    var content: String
}

struct TermsAndConditionRequestModel: Codable {
    let lang: String

    enum CodingKeys: String, CodingKey {
        case lang = "lang"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lang, forKey: .lang)
    }
}
