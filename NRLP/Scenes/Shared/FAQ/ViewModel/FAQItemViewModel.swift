//
//  FAQItemViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct FAQItemViewModel {
    private var faq: FaqQuestion
    var question: String {
        return faq.question
    }

    lazy var description: NSAttributedString? = {
        if faq.answer.isHTML() {
            return faq.answer.getStringForHTMLContent()
        } else {

            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.baseWritingDirection = NSParagraphStyle.defaultWritingDirection(forLanguage: "en")
            paragraphStyle.lineSpacing = 1.23

            return NSAttributedString(string: faq.answer, attributes: [
                NSAttributedString.Key.font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.lightOnlyEnglish, size: .mediumFontSize),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
        }
    }()

    var faqExpandState: FAQExpandState = .collapsed

    init(faq: FaqQuestion) {
        self.faq = faq
    }
}

enum FAQExpandState {
    case shouldExpand
    case shouldCollapse
    case expanded
    case collapsed
}
