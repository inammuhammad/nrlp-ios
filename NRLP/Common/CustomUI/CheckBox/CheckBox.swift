//
//  CheckBox.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias OnCheckBoxStateChangeCallBack = (Bool) -> Void

@IBDesignable
class CheckBox: CustomNibView {

    @IBOutlet private weak var checkboxImageView: UIImageView!
    @IBOutlet private weak var checkBoxTitleView: UILabel!

    @IBInspectable
    var titleColor: UIColor? {
        get {
            checkBoxTitleView.textColor
        } set {
            checkBoxTitleView.textColor = newValue
        }
    }

    var titleFont: UIFont? {
        get {
            checkBoxTitleView.font
        } set {
            checkBoxTitleView.font = newValue
        }
    }

    @IBInspectable
    var title: String? {
        get {
            checkBoxTitleView.text
        } set {
            checkBoxTitleView.text = newValue
        }
    }

    @IBInspectable
    var checkboxUncheckedImage: UIImage? = #imageLiteral(resourceName: "checkboxUnchecked")

    @IBInspectable
    var checkboxCheckedImage: UIImage? = #imageLiteral(resourceName: "checkboxChecked")

    @IBInspectable
    var isChecked: Bool = false {
        didSet {
            updateCheckBoxState()
        }
    }

    var onCheckBoxStateChange: OnCheckBoxStateChangeCallBack?

    override func setupView() {
        super.setupView()
        setupGesture()
        updateCheckBoxState()
        setupDefaultStyle()
    }

    private func setupDefaultStyle() {
        titleFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
        titleColor = .black
    }

    private func updateCheckBoxState() {
        if isChecked {
            checkboxImageView.image = checkboxCheckedImage
        } else {
            checkboxImageView.image = checkboxUncheckedImage
        }
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        isChecked = !isChecked
        onCheckBoxStateChange?(isChecked)
    }
}
