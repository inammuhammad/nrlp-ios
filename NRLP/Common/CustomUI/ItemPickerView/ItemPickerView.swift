//
//  ItemPickerView.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

protocol ItemPickerViewDelegate: class {
    func didTapCancelButton()
    func didTapDoneButton(with selectedItem: PickerItemModel?)
}

class ItemPickerView: UIPickerView, PickerToolbarProtocol {

    private(set) var toolbar: UIToolbar?
    weak var toolbarDelegate: ItemPickerViewDelegate?
    var viewModel: ItemPickerViewModel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        self.bindViewModelOutput()
    }

    private func commonInit() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
        setupPicker()
    }

    private func setupPicker() {
        self.delegate = self
        self.dataSource = self
    }

    @objc func doneTapped() {
        toolbarDelegate?.didTapDoneButton(with: viewModel?.getPickerModel(at: self.selectedRow(inComponent: 0)))
    }

    @objc func cancelTapped() {
        toolbarDelegate?.didTapCancelButton()
    }
}

extension ItemPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        viewModel?.numberOfRows ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel?.getItemTitle(at: row) ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension ItemPickerView {
    func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .reloadData:
                    self.reloadComponent(0)
            }
        }
    }
}
