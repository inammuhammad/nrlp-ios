//
//  RadioButtonItemView.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias RadioButtonItemUpdateCallBack = ((Int, RadioButtonItemModel) -> Void)

enum RadioButtonItemStyle {
    case imageBeforeLabel
    case labelBeforeImage
}

@IBDesignable
class RadioButtonItemView: CustomNibView {

    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet private weak var radioButtonImageView: UIImageView! {
        didSet {
            radioButtonImageView.image = #imageLiteral(resourceName: "radioButtonUnselected")
        }
    }
    @IBOutlet private weak var radioButtonTitleView: UILabel!

    var itemStyle: RadioButtonItemStyle = .imageBeforeLabel {
        didSet {
            updateLayoutStyle()
        }
    }
    
    var didUpdatedItemState: RadioButtonItemUpdateCallBack?

    private var isSelected: Bool = false {
        didSet {
            if oldValue == isSelected {
                return
            }
            setupView(for: isSelected)
            self.itemModel?.isSelected = isSelected
            if let itemModel = itemModel {
                didUpdatedItemState?(self.tag, itemModel)
            }
            updateItemIcon()
        }
    }

    var itemModel: RadioButtonItemModel? {
        didSet {
            radioButtonTitleView.text = itemModel?.title
            isItemSelected = itemModel?.isSelected ?? false
            itemStyle = itemModel?.itemStyle ?? .imageBeforeLabel
        }
    }

    var titleViewSelectedStateFont: UIFont? = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize) {
        didSet {
            if titleViewUnselectedStateFont == nil {
                titleViewUnselectedStateFont = titleViewSelectedStateFont
            }
            setupView(for: isSelected)
        }
    }

    var titleViewSelectedStateColor: UIColor? {
        didSet {
            if titleViewUnselectedStateColor == nil {
                titleViewUnselectedStateColor = titleViewSelectedStateColor
            }
            setupView(for: isSelected)
        }
    }

    var titleViewUnselectedStateFont: UIFont? {
        didSet {
            setupView(for: isSelected)
        }
    }

    var titleViewUnselectedStateColor: UIColor? {
        didSet {
            setupView(for: isSelected)
        }
    }

    var isItemSelected: Bool {
        get {
            return isSelected
        } set {
            isSelected = newValue
        }
    }

    func toggleState() {
        isSelected = !isSelected
    }

    override func setupView() {
        super.setupView()
        setDefaultStyle()
        setupGesture()
        setupView(for: isSelected)
    }

    private func updateItemIcon() {
        if isSelected {
            radioButtonImageView.image = #imageLiteral(resourceName: "radioButtonSelected")
        } else {
            radioButtonImageView.image = #imageLiteral(resourceName: "radioButtonUnselected")
        }
    }

    private func setDefaultStyle() {
        titleViewUnselectedStateFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        titleViewSelectedStateFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
        titleViewSelectedStateColor = UIColor.init(commonColor: .appDarkGray)
        titleViewUnselectedStateColor = UIColor.init(commonColor: .appDarkGray)
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if !(itemModel?.isSelected ?? false) {
            toggleState()
        }
    }

    private func setupView(for state: Bool) {
        if isItemSelected {
            setSelectedState()
        } else {
            setUnselectedState()
        }
    }

    private func setSelectedState() {
        //Need to update Image -- later provided by mawis
        radioButtonTitleView.font = titleViewSelectedStateFont
        radioButtonTitleView.textColor = titleViewSelectedStateColor
    }

    private func setUnselectedState() {
        //Need to update Image -- later provided by mawis
        radioButtonTitleView.font = titleViewUnselectedStateFont
        radioButtonTitleView.textColor = titleViewUnselectedStateColor
    }
    
    private func updateLayoutStyle() {
        switch itemStyle {
        case .imageBeforeLabel:
            if let firstItem = contentStackView.subviews.first,
                firstItem is UILabel {
                contentStackView.removeArrangedSubview(firstItem)
                firstItem.removeFromSuperview()
                contentStackView.addArrangedSubview(firstItem)
            }
        case .labelBeforeImage:
            if let firstItem = contentStackView.subviews.first,
                firstItem is UIImageView {
                contentStackView.removeArrangedSubview(firstItem)
                firstItem.removeFromSuperview()
                contentStackView.addArrangedSubview(firstItem)
            }
        }
    }
}
