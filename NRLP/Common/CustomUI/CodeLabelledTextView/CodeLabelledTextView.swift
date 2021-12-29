//
//  CodeLabelledTextView.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class CodeLabelledTextView: CustomNibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private var codeTextFields: [CodeVerifyTextField]!
    @IBOutlet private weak var bottomDescriptionLabel: UILabel!
    @IBOutlet private weak var helpLbl: UILabel!
    @IBOutlet private weak var helpBtn: UIButton!
    @IBOutlet weak var otpItemStack: UIStackView!
    
    @IBAction func helpBtnAction(_ sender: Any) {
        let alert: AlertViewModel
        let okButton = AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil)
        alert = AlertViewModel(alertHeadingImage: helpPopupIcon, alertTitle: helpLabelText, alertDescription: nil, alertAttributedDescription: nil, primaryButton: okButton, secondaryButton: nil)
        onHelpBtnPressed?(alert)
    }
    
    var onTextFieldChanged: TextFieldChangedCallBack?
    var onHelpBtnPressed: HelpButtonTappedCallBack?
    
    //IBInspectable
    @IBInspectable
    var showHelpBtn: Bool = false {
        didSet {
            if showHelpBtn {
                helpBtn.isHidden = false
            } else {
                helpBtn.isHidden = true
            }
        }
    }
    
    var helpPopupIcon: AlertIllustrationType = .remitterInfo
    
    @IBInspectable
    var helpLabelText: String? {
        get {
            helpLbl.text
        } set {
            helpLbl.text = newValue
        }
    }
    
    @IBInspectable
    var titleLabelText: String? {
        get {
            titleLabel.text
        } set {
            titleLabel.text = newValue
        }
    }
    
    var titleLabelAttributedString: NSAttributedString? {
        get {
            titleLabel.attributedText
        } set {
            titleLabel.attributedText = newValue
        }
    }
    
    @IBInspectable
    var titleLabelTextColor: UIColor? {
        get {
            titleLabel.textColor
        } set {
            titleLabel.textColor = newValue
        }
    }
    
    var titleLabelFont: UIFont? {
        get {
            titleLabel.font
        } set {
            titleLabel.font = newValue
        }
    }
    
    @IBInspectable
    var helpLabelTextColor: UIColor? {
        get {
            helpLbl.textColor
        } set {
            helpLbl.textColor = newValue
        }
    }
    
    var helpLabelFont: UIFont? {
        get {
            helpLbl.font
        } set {
            helpLbl.font = newValue
        }
    }
    
    var errorLabelFont: UIFont? {
        get {
            bottomDescriptionLabel.font
        } set {
            bottomDescriptionLabel.font = newValue
        }
    }
    
    @IBInspectable
    var errorLabelColor: UIColor? {
        didSet {
            bottomDescriptionLabel.textColor  = errorLabelColor
        }
    }
    
    var textViewDescription: String? = nil {
        didSet {
            setNormalState()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        setupDefaultTitleLabelStyle()
        setupDefaultErrorStyle()
        setupHelpLabelStyle()
        setNormalState()
        
        setupPinCodeFields()
        otpItemStack.semanticContentAttribute = .forceLeftToRight
        codeTextFields.forEach { (textField) in
            textField.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    private func setupPinCodeFields() {
        
        codeTextFields.forEach { $0.codeDelegate = self }
        
        for textfields in codeTextFields {
            textfields.codeDelegate = self
            textfields.placeholder = "x"
            textfields.setTextViewBorder(with: UIColor(commonColor: .appBottomBorderViewShadow))
        }
    }
    
    private func setupDefaultTitleLabelStyle() {
        //Need to use Dimens
        titleLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.smallFontSize.rawValue)
        titleLabelTextColor = UIColor.init(commonColor: .appGreen)
    }
    
    private func setupHelpLabelStyle() {
        //Need to use Dimens
        helpLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.smallFontSize.rawValue)
        helpLabelTextColor = UIColor.init(commonColor: .appDarkGray)
    }
    
    private func setupDefaultErrorStyle() {
        errorLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
        errorLabelColor = UIColor.init(commonColor: .appErrorRed)
    }
    
    private func setupDefaultDescriptionStyle() {
        errorLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
        errorLabelColor = UIColor.init(commonColor: .disableGery)
    }
    
    private func setNormalState() {        
        bottomDescriptionLabel.text = textViewDescription
        bottomDescriptionLabel.isHidden = textViewDescription?.isBlank ?? true
        setupDefaultDescriptionStyle()
    }
    
    private func clearInputFields() {
        codeTextFields.forEach { (textField) in
            textField.clear()
            textField.resignFirstResponder()
        }
    }
    
    func validateOTPString(string: String) -> Bool {
        let verifyString = string.trim()
        return verifyString.isValid(for: RegexConstants.otpValidateRegex)
    }
    
    func updateStateTo(isError: Bool, error: String? = nil) {
        if isError {
            setErrorState(error: error)
        } else {
            setNormalState()
        }
    }
    
    private func setErrorState(error: String?) {
        bottomDescriptionLabel.text = error
        bottomDescriptionLabel.isHidden = error?.isBlank ?? true
        setupDefaultErrorStyle()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return ((codeTextFields.first?.becomeFirstResponder()) != nil)
    }
}
 
extension CodeLabelledTextView: KWTextFieldDelegate {
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
            codeTextFields.forEach { (textField) in
                textField.resignFirstResponder()
            }
        }
        if validateOTPString(string: verificationCodeString) {
            onTextFieldChanged?(verificationCodeString)
        }
    }
    
}
