//
//  RemitterVerificationViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class RemitterVerificationViewController: BaseViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet private weak var progressBar: ProgressBarView! {
        didSet {
            progressBar.completedPercentage = 0.5
        }
    }

    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "Enter your most recent Remittance Transaction Reference Number (transactions from last one year, starting 1st Oct 2021 are eligible)".localized
            descriptionLabel.textColor = .black
            descriptionLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }

    @IBOutlet private weak var referenceNumberLabelTextView: LabelledTextview! {
        didSet {
            referenceNumberLabelTextView.titleLabelText = "Reference Number".localized
            referenceNumberLabelTextView.placeholderText = "xxxxxxxxxxxxxx"
            referenceNumberLabelTextView.showHelpBtn = true
            referenceNumberLabelTextView.helpLabelText = "Transactions from last one year, starting 1st Oct 2021 are eligible".localized
            referenceNumberLabelTextView.inputFieldMaxLength = 25
            referenceNumberLabelTextView.editTextKeyboardType = .asciiCapable
            referenceNumberLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.referenceNumberRegex, invalidFormatError: StringConstants.ErrorString.referenceNumberError.localized)
            referenceNumberLabelTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.referenceNumber = updatedText
            }
            referenceNumberLabelTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }

    @IBOutlet private weak var transactionAmountLabelTextView: LabelledTextview! {
        didSet {
            transactionAmountLabelTextView.leadingTextColor = .black
            transactionAmountLabelTextView.editTextKeyboardType = .decimalPad
            transactionAmountLabelTextView.titleLabelText = "Transaction Amount".localized
            transactionAmountLabelTextView.placeholderText = "xx,xxx".localized
            transactionAmountLabelTextView.leadingText = "PKR ".localized
            transactionAmountLabelTextView.showHelpBtn = true
            transactionAmountLabelTextView.helpLabelText = "Enter exact amount as per you transaction receipt".localized
            transactionAmountLabelTextView.inputFieldMaxLength = 13
            transactionAmountLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.transactionAmountRegex, invalidFormatError: StringConstants.ErrorString.transactionAmountError.localized)
            transactionAmountLabelTextView.formatter = CurrencyFormatter()
            transactionAmountLabelTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.transactionAmount = updatedText
            }
            transactionAmountLabelTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }

    @IBOutlet private weak var nextButton: PrimaryCTAButton! {
        didSet {
            nextButton.setTitle("Next".localized, for: .normal)
        }
    }

    // MARK: Variables
    var viewModel: RemitterVerificationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
    }

    // MARK: Private Methods
    private func setupUI() {

        self.title = "Remitter Verification".localized

        referenceNumberLabelTextView.onTextFieldChanged = { [weak self] updatedText in
            guard let self = self else { return }
            self.viewModel.referenceNumber = updatedText
        }

        transactionAmountLabelTextView.onTextFieldChanged = { [weak self] updatedText in
            guard let self = self else { return }
            self.viewModel.transactionAmount = updatedText
        }
    }

    /// Bind the view controller with view model.
    private func bindViewModelOutput() {

        viewModel.output = { [unowned self] output in

            switch output {
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let state):
                self.nextButton.isEnabled = state
            case .referenceNumberLabelState(let state, let message):
                self.referenceNumberLabelTextView.updateStateTo(isError: state, error: message)
            case .transactionAmountLabelState(let state, let message):
                self.transactionAmountLabelTextView.updateStateTo(isError: state, error: message)
            }
        }
    }

}

// MARK: Button Actions
extension RemitterVerificationViewController {

    @IBAction
    private func nextButtonPressed(_ sender: UIButton) {
        viewModel.nextButtonPressed()
    }

}

extension RemitterVerificationViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.remitterVerification
    }
}
