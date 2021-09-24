//
//  NadraTrackingIDViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class NadraTrackingIDViewController: BaseViewController {
    
    var viewModel: NadraTrackingIDViewModelProtocol!

    @IBOutlet weak var pointsView: LoyaltyCardView!
    @IBOutlet weak var trackingIDTextField: LabelledTextview! {
        didSet {
            trackingIDTextField.titleLabelText = "Enter Tracking ID for Redemption".localized
            trackingIDTextField.placeholderText = "Tracking ID Number".localized
            trackingIDTextField.editTextKeyboardType = .asciiCapableNumberPad
            trackingIDTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.trackingID = updatedText
            }
        }
    }
    @IBOutlet weak var cnicTextField: LabelledTextview! {
        didSet {
            cnicTextField.titleLabelText = "Enter CNIC for Redemption".localized
            cnicTextField.placeholderText = "xxxxx-xxxxxxx-x".localized
            cnicTextField.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextField.inputFieldMinLength = 13
            cnicTextField.inputFieldMaxLength = 13
            cnicTextField.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            cnicTextField.formatter = CNICFormatter()
            cnicTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.cnic = updatedText
            }
        }
    }
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
                self.pointsView.populate(with: viewModel)
            case .showAlert(alert: let alert):
                self.showAlert(with: alert)
            case .trackingIDTextField(errorState: let errorState, error: let error):
                trackingIDTextField.updateStateTo(isError: errorState, error: error)
            case .cnicTextField(errorState: let errorState, error: let error):
                cnicTextField.updateStateTo(isError: errorState, error: error)
            }
        }
    }
}

extension NadraTrackingIDViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.nadraTrackingID
    }
}
