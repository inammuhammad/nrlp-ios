//
//  ProfileVerificationViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ProfileVerificationViewController: BaseViewController {
    
    var viewModel: ProfileVerificationViewModelProtocol!
    
    @IBOutlet private weak var nextButton: PrimaryCTAButton! {
        didSet {
            nextButton.setTitle("Next".localized, for: .normal)
        }
    }
    @IBOutlet private weak var motherNameTextView: LabelledTextview! {
        didSet {
            motherNameTextView.titleLabelText = "Mother Maiden Name *".localized
            motherNameTextView.placeholderText = "Kaneez Fatima".localized
            motherNameTextView.autoCapitalizationType = .words
            motherNameTextView.inputFieldMaxLength = 50
            motherNameTextView.editTextKeyboardType = .asciiCapable
            motherNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
            motherNameTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.motherName = updatedText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
    }
    
    private func bindViewModelOutput() {
        self.viewModel.output = { [weak self] ouput in
            guard let self = self else { return }
            switch ouput {
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(error: let error):
                self.showAlert(with: error)
            case .nextButtonState(let enableState):
                self.nextButton.isEnabled = enableState
            case .updateMotherTextFieldState(errorState: let errorState, errorMessage: let errorMessage):
                self.motherNameTextView.updateStateTo(isError: errorState, error: errorMessage)
            case .showAlert(alert: let model):
                self.showAlert(with: model)
            }
        }
    }
    
    private func setupUI() {
        self.title = "Verification".localized
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
    
}

extension ProfileVerificationViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.profileVerification
    }
}
