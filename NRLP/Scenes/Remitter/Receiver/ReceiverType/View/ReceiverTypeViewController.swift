//
//  ReceiverTypeViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ReceiverTypeViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: ReceiverTypeViewModelProtocol!
    
    private lazy var receiverTypeItemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.receiverTypeItemPickerViewModel
        return pickerView
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.extraLargeFontSize.rawValue)
            titleLbl.textColor = UIColor.init(commonColor: .appDarkGray)
            titleLbl.text = "+ Add Receiver".localized
        }
    }
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var nextBtn: PrimaryCTAButton! {
        didSet {
            nextBtn.setTitle("Next".localized, for: .normal)
        }
    }
    @IBOutlet weak var noteLbl: UILabel! {
        didSet {
            noteLbl.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.largeFontSize.rawValue)
            noteLbl.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    @IBOutlet weak var receiverTypeTextView: LabelledTextview! {
        didSet {
            receiverTypeTextView.titleLabelText = "Receiver Type".localized
            receiverTypeTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            receiverTypeTextView.placeholderText = "Select Receiver Type".localized
            receiverTypeTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            receiverTypeTextView.inputTextFieldInputPickerView = receiverTypeItemPickerView
        }
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        setupUI()
        bindViewModelOutput()
        viewModel.viewDidLoad()
        super.viewDidLoad()
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        self.title = "Remittance Receiver Management".localized
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showAlert(let alertViewModel):
                self.showAlert(with: alertViewModel)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .setNoteLbl(text: let text):
                self.noteLbl.text = text
            case .buttonState(enabled: let enabled):
                self.nextBtn.isEnabled = enabled
            case .setReceiverType(text: let text):
                self.receiverTypeTextView.inputText = text
            }
        }
    }
    
    // MARK: - IBActions

    @IBAction func nextBtnAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
}

// MARK: Extension - ItemPickerViewDelegate

extension ReceiverTypeViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        guard let type = selectedItem as? RemitterReceiverTypePickerItemModel else { return }
        viewModel.didSelect(receiverType: type)
        self.view.endEditing(true)
    }
}

// MARK: Extension - Initializable

extension ReceiverTypeViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.receiverType
    }
}
