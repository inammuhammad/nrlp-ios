//
//  TermsAndConditionsViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: BaseViewController {

    var viewModel: TermsAndConditionViewModelProtocol!

    @IBOutlet private weak var registerCTAButton: PrimaryCTAButton! {
        didSet {
            registerCTAButton.setTitle("Register".localized, for: .normal)
        }
    }
    @IBOutlet private weak var termsAndConditionCheckBox: CheckBox! {
        didSet {
            termsAndConditionCheckBox.title = "I agree to the Terms & Conditions".localized
            termsAndConditionCheckBox.onCheckBoxStateChange = { [weak self] currentState in
                guard let self = self else { return }
                self.viewModel.isTermsAccepted = currentState
            }
        }
    }
    @IBOutlet private weak var progressBar: ProgressBarView! {
        didSet {
            progressBar.completedPercentage = 1
        }
    }
    @IBOutlet private weak var termsAndConditionText: UILabel! {
        didSet {
            termsAndConditionText.textColor = .black
        }
    }
    @IBOutlet private weak var declineTermsAndConditionButton: SecondaryCTAButton! {
        didSet {
            declineTermsAndConditionButton.setTitle("Cancel".localized, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModelOutput()
        viewModel.viewModelDidLoad()
    }
    
    override func setupNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
    }
}

// MARK: BindView And SetupView
extension TermsAndConditionsViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .nextButtonState(let enableState):
                self.registerCTAButton.isEnabled = enableState
            case .showConfirmRegistrationDeclineAlert:
                self.showConfirmDeclineAlert()
            case .updateTermsAndCondition(let content):
                self.termsAndConditionText.attributedText = content
            case .showError(let error):
                self.showAlert(with: error)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            }
        }
    }

    private func setupView() {
        self.title = "Terms & Conditions".localized
    }

    private func showConfirmDeclineAlert() {
        let primaryButton = AlertActionButtonModel(buttonTitle: "Yes".localized) { [weak self] in
            guard let self = self else { return }
            self.viewModel.didConfirmedDeclinedRegistration()
        }
        let secondaryButton = AlertActionButtonModel(buttonTitle: "No".localized)
        let model = AlertViewModel(alertHeadingImage: .declineAlert, alertTitle: "Cancel Registration".localized, alertDescription: "Are you sure you want to cancel the registration process?".localized, primaryButton: primaryButton, secondaryButton: secondaryButton)
        showAlert(with: model)
    }
}

// MARK: IBOutlets
extension TermsAndConditionsViewController {

    @IBAction
    private func didTapRegisterButton(_ sender: Any) {
        viewModel.didTapRegisterButton()
    }

    @IBAction
    private func didTapDeclineTermsAndCondition(_ sender: Any) {
        viewModel.didTapDeclinedTermsAndCondition()
    }
}

extension TermsAndConditionsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.termsAndConditions
    }
}
