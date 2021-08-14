//
//  BeneficiaryVerificationViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BeneficiaryVerificationViewController: BaseViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet private weak var descriptionLable: UILabel! {
        didSet {
            descriptionLable.text = "Please enter registration code received on SMS".localized
            descriptionLable.textColor = .black
            descriptionLable.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    @IBOutlet private weak var verificationCodeErrorLabel: UILabel! {
        didSet {
            verificationCodeErrorLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
            verificationCodeErrorLabel.textColor = UIColor(commonColor: .appErrorRed)
        }
    }

    @IBOutlet private var codeTextFields: [CodeVerifyTextField]!
    @IBOutlet private weak var registrationCodeLabel: UILabel! {
        didSet {
            registrationCodeLabel.text = "Registration Code".localized
            registrationCodeLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.smallFontSize.rawValue)
            registrationCodeLabel.textColor = UIColor.init(commonColor: .appGreen)
        }
    }
    @IBOutlet private weak var progressBar: ProgressBarView! {
        didSet {
            progressBar.completedPercentage = 0.66
        }
    }
    @IBOutlet private weak var nextButton: PrimaryCTAButton! {
        didSet {
            nextButton.setTitle("Next".localized, for: .normal)
        }
    }
    @IBOutlet weak var otpItemStack: UIStackView!
    
    // MARK: Variables
    var viewModel: BeneficiaryVerificationViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()

    }

    // MARK: Private Methods
    private func setupUI() {

        self.title = "Beneficiary Verification".localized
        setupPinCodeFields()
        
        otpItemStack.semanticContentAttribute = .forceLeftToRight
        codeTextFields.forEach { (textField) in
            textField.semanticContentAttribute = .forceLeftToRight
        }
    }

    private func setupPinCodeFields() {

        codeTextFields.forEach { $0.codeDelegate = self}

        for textfields in codeTextFields {
            textfields.codeDelegate = self
            textfields.placeholder = "x"
            textfields.setTextViewBorder(with: UIColor(commonColor: .appBottomBorderViewShadow))
        }
        codeTextFields.first?.becomeFirstResponder()
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
            case .showOTPInvalidFormatError(let show, let error):
                self.verificationCodeErrorLabel.isHidden = !show
                self.verificationCodeErrorLabel.text = error ?? ""
            }
        }
    }

}

// MARK: Button Actions
extension BeneficiaryVerificationViewController {

    @IBAction
    private func nextButtonPressed(_ sender: UIButton) {
        self.viewModel.nextButtonPressed()
    }

}

extension BeneficiaryVerificationViewController: KWTextFieldDelegate {

    func moveToNext(_ textFieldView: CodeVerifyTextField) {
        let validIndex = codeTextFields.firstIndex(of: textFieldView) == codeTextFields.count - 1 ? codeTextFields.firstIndex(of: textFieldView)! : codeTextFields.firstIndex(of: textFieldView)! + 1
        textFieldView.setTextViewBorder(with: UIColor(commonColor: .appGreen))
        codeTextFields[validIndex].activate()
    }

    func moveToPrevious(_ textFieldView: CodeVerifyTextField, oldCode: String) {
        if codeTextFields.last == textFieldView && oldCode != " " {
            return
        }
        textFieldView.setTextViewBorder(with: UIColor(commonColor: .appBottomBorderViewShadow))

        if textFieldView.text == " " {
            let validIndex = codeTextFields.firstIndex(of: textFieldView)! == 0 ? 0 : codeTextFields.firstIndex(of: textFieldView)! - 1
            codeTextFields[validIndex].activate()
            codeTextFields[validIndex].reset()
        }
    }

    func didChangeCharacters() {
        var enteredDigits = 0
        let maxDigits = 4

        var verificationCodeString = ""
        var verificationCode =  [Int?]()
        for textFieldView in codeTextFields {

            let value =  Int(textFieldView.text ?? "") ?? nil
            verificationCode.append(value)
            verificationCodeString.append(textFieldView.text ?? "")
            if value != nil {
                enteredDigits += 1
            }
        }
        if enteredDigits == maxDigits {
            self.view.endEditing(true)
        }
        viewModel.validateOTPString(string: verificationCodeString)
        viewModel.otpCode = verificationCode
    }
}

extension BeneficiaryVerificationViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.beneficiaryVerification
    }
}
