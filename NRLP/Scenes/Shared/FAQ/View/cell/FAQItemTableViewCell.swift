//
//  FAQItemTableViewCell.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class FAQItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var answerLabel: UILabel! {
        didSet {
            answerLabel.isHidden = true
            answerLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.lightOnlyEnglish, size: .mediumFontSize)
        }
    }
    @IBOutlet weak var questionContainer: UIView! {
        didSet {
            questionContainer.semanticContentAttribute = .forceLeftToRight
        }
    }
    @IBOutlet weak var faqItemStack: UIStackView! {
        didSet {
            faqItemStack.semanticContentAttribute = .forceLeftToRight
        }
    }
    @IBOutlet private weak var arrowIcon: UIImageView! {
        didSet {
            arrowIcon.image = #imageLiteral(resourceName: "downArrow-1")
        }
    }
    @IBOutlet private weak var questionLabel: UILabel! {
        didSet {
            questionLabel.textAlignment = .left
            questionLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize)
        }
    }

    private var viewModel: FAQItemViewModel!

    func populate(with data: FAQItemViewModel) {
        self.viewModel = data
        answerLabel.attributedText = viewModel.description
        questionLabel.text = viewModel.question

        switch viewModel.faqExpandState {
        case .shouldCollapse:
            answerLabel.isHidden = true
            self.arrowIcon.rotate(to: 0, fromValue: Double.pi)
        case .shouldExpand:
            answerLabel.isHidden = false
            self.arrowIcon.rotate(to: Double.pi, fromValue: 0)
        case .collapsed:
            answerLabel.isHidden = true
            self.arrowIcon.rotate(to: 0, fromValue: 0, duration: 0)
        case .expanded:
            answerLabel.isHidden = false
            self.arrowIcon.rotate(to: Double.pi, fromValue: Double.pi, duration: 0)
        }
    }
}
