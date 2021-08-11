//
//  FAQResponseModel.swift
//  1Link-NRLP
//
//  Created by VenD on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct FaqResponseModel: Codable {

    var message: String
    var data: FAQQuestions
}

struct FAQQuestions: Codable {
    var questions: [FaqQuestion]
}

struct FaqQuestion: Codable {
    var question: String
    var answer: String
}
