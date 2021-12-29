//
//  CardImageButton.swift
//  NRLP
//
//  Created by Bilal Iqbal on 27/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ButtonTappedCallBack = (() -> Void)

class CardImageButton: CustomNibView {
    
    var onTapped: ButtonTappedCallBack?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    
    var titleLabelText: String? {
        get {
            titleLabel.text
        } set {
            titleLabel.text = newValue
        }
    }
    
    var titleLabelAttributedString: NSAttributedString? {
        get {
            titleLabel.attributedText
        } set {
            titleLabel.attributedText = newValue
        }
    }
    
    var titleLabelTextColor: UIColor? {
        get {
            titleLabel.textColor
        } set {
            titleLabel.textColor = newValue
        }
    }
    
    var titleLabelFont: UIFont? {
        get {
            titleLabel.font
        } set {
            titleLabel.font = newValue
        }
    }
    
    var imageHeight: CGFloat? {
        get {
            imageHeightConstraint.constant
        } set {
            imageHeightConstraint.constant = newValue ?? 50.0
        }
    }
    
    var image: UIImage? {
        get {
            imageView.image
        } set {
            imageView.image = newValue
        }
    }
    
    override func setupView() {
        setupDefaultTitleLabelStyle()
    }
    
    private func setupDefaultTitleLabelStyle() {
        titleLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.smallFontSize.rawValue)
        titleLabelTextColor = UIColor.init(commonColor: .appGreen)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        onTapped?()
    }
    
}
