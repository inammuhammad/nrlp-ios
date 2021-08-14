//
//  ForgotPasswordViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    lazy private var itemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.accountTypePickerViewModel
        return pickerView
    }()

    @IBOutlet private weak var nextButton: PrimaryCTAButton! {
        didSet {
            nextButton.setTitle("Send Code".localized, for: .normal)
        }
    }

    var viewModel: ForgotPasswordViewModelProtocol!

    @IBOutlet private weak var cnicTextView: LabelledTextview! {
        didSet {
            cnicTextView.titleLabelText = "CNIC/NICOP".localized
            cnicTextView.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextView.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            cnicTextView.formatter = CNICFormatter()
            cnicTextView.placeholderText = "xxxxx-xxxxxxx-x".localized
            cnicTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.cnic = updatedText
            }
        }
    }

    @IBOutlet private weak var accountTypeTextView: LabelledTextview! {
        didSet {
            accountTypeTextView.titleLabelText = "User Type".localized
            accountTypeTextView.editTextKeyboardType = .numberPad
            accountTypeTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            accountTypeTextView.placeholderText = "Select User Type".localized
            accountTypeTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            accountTypeTextView.inputTextFieldInputPickerView = itemPickerView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
    }

    private func setupUI() {
        self.title = "Forgot Password".localized
        self.nextButton.isEnabled = false
    }
}

extension ForgotPasswordViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let enableState):
                self.nextButton.isEnabled = enableState
            case .cnicTextField(let errorState, let errorMsg):
                self.cnicTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .accountTypeTextField(let errorState, let errorMsg):
                self.accountTypeTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .updateAccountType(let accountType):
                self.accountTypeTextView.inputText = accountType
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            }
        }
    }

    @IBAction private func nextButtonPressed(_ sender: PrimaryCTAButton) {
        self.viewModel.nextButtonPressed()
    }
}

extension ForgotPasswordViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        viewModel.didSelect(accountType: selectedItem as? AccountTypePickerItemModel)
        self.view.endEditing(true)
    }
}

extension ForgotPasswordViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.forgotPassword
    }
}
