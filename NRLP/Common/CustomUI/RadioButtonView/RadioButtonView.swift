//
//  RadioButtonView.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias OnItemSelectedCallBack = ((RadioButtonItemModel) -> Void)

class RadioButtonView: CustomNibView {

    @IBOutlet private weak var titleView: UILabel!
    @IBOutlet private weak var itemStack: UIStackView!

    private var items: [RadioButtonItemView] = []

    var didUpdatedSelectedItem: OnItemSelectedCallBack?

    @IBInspectable
    var titleViewText: String? {
        get {
            titleView.text
        } set {
            titleView.text = newValue
        }
    }

    var titleViewFont: UIFont? {
        get {
            titleView.font
        } set {
            titleView.font = newValue
        }
    }

    @IBInspectable
    var titleViewColor: UIColor? {
        get {
            titleView.textColor
        } set {
            titleView.textColor = newValue
        }
    }

    var alignment: RadioButtonAlignment = .horizontal
    
    private var selectedItemView: RadioButtonItemView?

    var selectedItem: RadioButtonItemModel? {
        return selectedItemView?.itemModel
    }

    override func setupView() {
        super.setupView()
        setDefaultStyle()
    }
    
    private func setupTitleViewAlignment() {
        if (AppConstants.appLanguage == .urdu && !AppConstants.isSystemLanguageUrdu()) || AppConstants.appLanguage == .english && AppConstants.isSystemLanguageUrdu() {
            self.titleView.textAlignment = .right
        } else {
            self.titleView.textAlignment = .left
        }
        
    }

    private func setDefaultStyle() {
        titleViewFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
        titleViewColor = UIColor.init(commonColor: .appGreen)
    }

    func setRadioButtonItems(items: [RadioButtonItemModel]) {
        setupViewBasedOn(alignment: alignment, items: items)
    }

    private func setupViewBasedOn(alignment: RadioButtonAlignment, items: [RadioButtonItemModel]) {
        itemStack.removeAllArrangedSubviews()
        switch alignment {
        case .horizontal:
            setupHorizontallyAlignedItems(items: items)
        case .vertical:
            setupVerticallyAlignedItems(items: items)
        }
    }

    private func setupHorizontallyAlignedItems(items: [RadioButtonItemModel]) {
        for index in stride(from: 0, to: items.count, by: 2) {
            let hStack = UIStackView()

            hStack.axis = .horizontal
            hStack.distribution = .fillEqually
            hStack.spacing = CommonDimens.unit4x.rawValue

            for itemIndex in stride(from: index, to: min(index + 2, items.count), by: 1) {
                let item = setupButtonItemView(for: items[itemIndex], index: itemIndex)
                self.items.append(item)
                hStack.addArrangedSubview(item)
            }

            itemStack.addArrangedSubview(hStack)
        }
    }

    private func setupButtonItemView(for model: RadioButtonItemModel, index: Int) -> RadioButtonItemView {
        let item = RadioButtonItemView()
        item.tag = index
        item.itemModel = model
        item.didUpdatedItemState = { [weak self] tag, itemModel in
            guard let self = self else { return }
            self.setRadioItemSelected(at: tag, isSelected: itemModel.isSelected)

        }
        return item
    }

    func setRadioItemSelected(at index: Int, isSelected: Bool) {

        self.selectedItemView?.isItemSelected = false

        self.items[index].isItemSelected = isSelected
        self.selectedItemView = nil

        if let viewModel = self.items[index].itemModel,
            isSelected {
            self.selectedItemView = self.items[index]
            self.didUpdatedSelectedItem?(viewModel)
        }
    }

    private func setupVerticallyAlignedItems(items: [RadioButtonItemModel]) {
        for index in stride(from: 0, to: items.count, by: 1) {
            let item = setupButtonItemView(for: items[index], index: index)
            self.items.append(item)
            itemStack.addArrangedSubview(item)
        }
    }
}

enum RadioButtonAlignment {
    case horizontal
    case vertical
}
