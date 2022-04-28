//
//  RedemptionPSIDViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class RedemptionPSIDViewController: BaseViewController {
    
    var viewModel: RedemptionPSIDViewModelProtocol!

    @IBOutlet weak var ponitsView: LoyaltyCardView!
    @IBOutlet weak var nextBtn: PrimaryCTAButton! {
        didSet {
            nextBtn.setTitle("Next".localized, for: .normal)
            nextBtn.setTitle("Next".localized, for: .selected)
            nextBtn.setTitle("Next".localized, for: .disabled)
            nextBtn.setTitle("Next".localized, for: .highlighted)
        }
    }
    @IBOutlet weak var cancelBtn: SecondaryCTAButton! {
        didSet {
            cancelBtn.setTitle("Cancel".localized, for: .normal)
            cancelBtn.setTitle("Cancel".localized, for: .selected)
            cancelBtn.setTitle("Cancel".localized, for: .disabled)
            cancelBtn.setTitle("Cancel".localized, for: .highlighted)
        }
    }
    @IBOutlet weak var psidTextView: LabelledTextview! {
        didSet {
            psidTextView.titleLabelText = "Enter PSID for Redemption".localized
            psidTextView.placeholderText = "Enter PSID".localized
            psidTextView.editTextKeyboardType = .asciiCapableNumberPad
            psidTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.psidText = updatedText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad()
        self.title = "Redeem".localized
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        viewModel.cancelButtonPressed()
    }
    
    private func bindViewModel() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .nextButtonState(enableState: let state):
                self.nextBtn.isEnabled = state
            case .updateLoyaltyPoints(viewModel: let viewModel):
                self.ponitsView.populate(with: viewModel)
            case .psidTextField(errorState: let state, error: let error):
                self.psidTextView.updateStateTo(isError: state, error: error)
            case .showAlert(alert: let alert):
                self.showAlert(with: alert)
            case .setupTextField(flowType: let flowType):
                if flowType == .OPF {
                    psidTextView.titleLabelText = "Enter Voucher Number for Redemption".localized
                    psidTextView.placeholderText = "Enter Voucher No".localized
                    psidTextView.editTextKeyboardType = .asciiCapable
                    psidTextView.inputFieldMinLength = 1
                    psidTextView.inputFieldMaxLength = 24
                    psidTextView.formatValidator = FormatValidator(regex: RegexConstants.alphanuericRegex, invalidFormatError: "Please enter a valid Voucher Number for Redemption.")
                    psidTextView.onTextFieldChanged = { [weak self] updatedText in
                        guard let self = self else { return }
                        self.viewModel.psidText = updatedText
                    }
                } else if flowType == .SLIC {
                    psidTextView.titleLabelText = "Enter your State Life Policy No.".localized
                    psidTextView.placeholderText = "Enter Policy No".localized
                    psidTextView.editTextKeyboardType = .asciiCapableNumberPad
                    psidTextView.inputFieldMinLength = 8
                    psidTextView.inputFieldMaxLength = 24
                    psidTextView.formatValidator = FormatValidator(regex: RegexConstants.alphanuericRegex, invalidFormatError: "Please enter a valid State Life Policy No.")
                    psidTextView.onTextFieldChanged = { [weak self] updatedText in
                        guard let self = self else { return }
                        self.viewModel.psidText = updatedText
                    }
                } else if flowType == .BEOE {
                    psidTextView.titleLabelText = "Enter your CNIC No.".localized
                    psidTextView.placeholderText = "CNIC Number".localized
                    psidTextView.inputFieldMinLength = 13
                    psidTextView.inputFieldMaxLength = 13
                    psidTextView.formatter = CNICFormatter()
                    psidTextView.editTextKeyboardType = .asciiCapableNumberPad
                    psidTextView.onTextFieldChanged = { [weak self] updatedText in
                        guard let self = self else { return }
                        self.viewModel.psidText = updatedText
                    }
                } else {
                    psidTextView.titleLabelText = "Enter PSID for Redemption".localized
                    psidTextView.inputFieldMinLength = 8
                    psidTextView.inputFieldMaxLength = 24
                    psidTextView.placeholderText = "Enter PSID".localized
                    psidTextView.editTextKeyboardType = .asciiCapableNumberPad
                    psidTextView.onTextFieldChanged = { [weak self] updatedText in
                        guard let self = self else { return }
                        self.viewModel.psidText = updatedText
                    }
                }
            case .showError(error: let error):
                self.showAlert(with: error)
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            }
        }
    }
    
}

extension RedemptionPSIDViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redemptionPSID
    }
}
