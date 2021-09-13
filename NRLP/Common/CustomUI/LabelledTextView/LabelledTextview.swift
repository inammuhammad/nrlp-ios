//
//  LabelledTextView.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias TextFieldChangedCallBack = ((String?) -> Void)
typealias TextFieldTappedCallBack = (() -> Void)
typealias TextFieldFocusChangeCallBack = ((String?) -> Void)
typealias HelpButtonTappedCallBack = ((AlertViewModel) -> Void)

@IBDesignable
class LabelledTextview: CustomNibView {
    
    //IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private  weak var inputTextField: UITextFieldPadding!
    @IBOutlet private  weak var errorIconImageView: UIImageView!
    @IBOutlet private weak var trailingImageView: UIImageView!
    @IBOutlet private weak var bottomDescriptionLabel: UILabel!
    @IBOutlet private weak var helpLbl: UILabel!
    @IBOutlet private weak var helpBtn: UIButton!
    
    @IBAction func helpBtnAction(_ sender: Any) {
        let alert: AlertViewModel
        let okButton = AlertActionButtonModel(buttonTitle: "OK".localized, buttonAction: nil)
        alert = AlertViewModel(alertHeadingImage: .remitterInfo, alertTitle: helpLabelText, alertDescription: nil, alertAttributedDescription: nil, primaryButton: okButton, secondaryButton: nil)
        onHelpBtnPressed?(alert)
    }
    
    var onTextFieldChanged: TextFieldChangedCallBack?
    var onTextFieldTapped: TextFieldTappedCallBack?
    var onTextFieldFocusChange: TextFieldFocusChangeCallBack?
    var onHelpBtnPressed: HelpButtonTappedCallBack?
    
    private var tap: UITapGestureRecognizer?
    
    //Regex validator
    var formatValidator: FormatValidatorProtocol?
    
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
    
    var autoCapitalizationType: UITextAutocapitalizationType {
        get {
            inputTextField.autocapitalizationType
        } set {
            inputTextField.autocapitalizationType = newValue
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
    
    @IBInspectable
    var placeholderText: String? {
        get {
            inputTextField.placeholder
        } set {
            inputTextField.placeholder = newValue
        }
    }
    
    @IBInspectable
    var placeholderTextColor: UIColor? {
        get {
            inputTextField.placeHolderColor
        } set {
            inputTextField.placeHolderColor = newValue
        }
    }
    
    var placeholderFont: UIFont? {
        get {
            inputTextField.placeHolderFont
        } set {
            inputTextField.placeHolderFont = newValue
        }
    }
    
    var editTextFont: UIFont? {
        get {
            inputTextField.font
        } set {
            inputTextField.font = newValue
        }
    }
    
    @IBInspectable
    var editTextColor: UIColor? {
        didSet {
            inputTextField.textColor = editTextColor
        }
    }
    
    @IBInspectable
    var editTextCursorColor: UIColor? {
        get {
            inputTextField.tintColor
        } set {
            inputTextField.tintColor = newValue
        }
    }
    
    @IBInspectable
    var inputText: String? {
        get {
            inputTextField.text ?? ""
        } set {
            inputTextField.text = formatter?.format(string: newValue ?? "") ?? newValue
        }
    }
    
    @IBOutlet weak var errorIconLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorIconRightConstraint: NSLayoutConstraint!
    
    var editTextKeyboardType: UIKeyboardType {
        get {
            inputTextField.keyboardType
        } set {
            inputTextField.keyboardType = newValue
        }
    }
    
    @IBInspectable
    var secureEntry: Bool {
        get {
            inputTextField.isSecureTextEntry
        } set {
            inputTextField.isSecureTextEntry = newValue
        }
    }
    
    var firstResponder: Bool = false {
        didSet {
            _ = firstResponder ? inputTextField.becomeFirstResponder() : inputTextField.resignFirstResponder()
        }
    }
    
    var formatter: FormatterProtocol?
    
    var inputFieldMinLength: Int?
    var inputFieldMaxLength: Int?
    
    var leadingTextFont: UIFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize)
    
    var leadingTextColor: UIColor = UIColor.init(commonColor: .appLightGray)
    
    var leadingText: String? = nil {
        didSet {
            if leadingText == nil {
                inputTextField.leftView = nil
                inputTextField.leftViewMode = .never
                inputTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                return
            }
            
            let label = getLeadingLabel()
            inputTextField.padding = UIEdgeInsets(top: 0, left: label.frame.width + 20, bottom: 0, right: 16)
            
            let view = UIStackView(frame: CGRect(x: 0, y: 0, width: label.frame.width + 16, height: inputTextField.frame.height))
            view.translatesAutoresizingMaskIntoConstraints = false
            view.alignment = .fill
            view.bounds = view.frame.inset(by: UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0))
            view.heightAnchor.constraint(equalToConstant: inputTextField.frame.height).isActive = true
            view.addArrangedSubview(label)
            
            view.contentMode = .left
            inputTextField.leftView = view
            
            view.semanticContentAttribute = .forceLeftToRight
            label.semanticContentAttribute = .forceLeftToRight
            inputTextField.semanticContentAttribute = .forceLeftToRight
            
            inputTextField.leftViewMode = .always
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
    
    @IBInspectable
    var isEditable: Bool = true {
        didSet {
            updateTextViewStyle()
        }
    }
    
    @IBInspectable
    var isTappable: Bool = false {
        didSet {
            if isTappable {
                setupTextFieldGesture()
                updateTextViewStyle()
            } else {
                removeTextFieldGesture()
            }
        }
    }
    
    var isPasswordField: Bool = false {
        didSet {
            if isPasswordField {
                setupPasswordTextView()
            }
        }
    }
    
    var textViewDescription: String? = nil {
        didSet {
            setNormalState()
        }
    }
    
    @IBInspectable
    var errorIcon: UIImage = #imageLiteral(resourceName: "errorIcon")
    
    @IBInspectable
    var trailingIcon: UIImage? {
        get {
            trailingImageView.image
        } set {
            trailingImageView.image = newValue
        }
    }
    
    var inputTextFieldInputPickerView: UIView? {
        didSet {
            if let inputTextFieldInputPickerView = inputTextFieldInputPickerView {
                inputTextField.inputView = inputTextFieldInputPickerView
                guard let toolbar = (inputTextFieldInputPickerView as? PickerToolbarProtocol)?.toolbar else { return }
                inputTextField.inputAccessoryView = toolbar
            } else {
                inputTextField.inputView = nil
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        
        inputTextField.delegate = self
        inputTextField.autocorrectionType = .no
        setupDefaultTitleLabelStyle()
        setupDefaultTextViewStyle()
        setupDefaultErrorStyle()
        setupHelpLabelStyle()
        setNormalState()
        
        inputTextField.textAlignment = .left
        errorIconRightConstraint?.priority = .defaultHigh
        errorIconLeftConstraint?.priority = .defaultLow
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return inputTextField.becomeFirstResponder()
    }
    
    @objc private func showPassword() {
        secureEntry = !secureEntry
        if secureEntry {
            trailingIcon = #imageLiteral(resourceName: "showPassword")
        } else {
            trailingIcon = #imageLiteral(resourceName: "hidePassword")
        }
        trailingImageView.tintColor = UIColor.lightGray
        trailingImageView.image = trailingImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    private func setupPasswordTextView() {
        if secureEntry {
            trailingIcon = #imageLiteral(resourceName: "showPassword")
        } else {
            trailingIcon = #imageLiteral(resourceName: "hidePassword")
        }
        trailingImageView.isUserInteractionEnabled = true
        trailingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPassword)))
        trailingImageView.tintColor = UIColor.lightGray
        trailingImageView.image = trailingImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    private func updateTextViewStyle() {
        if isEditable || isTappable {
            self.inputTextField.textColor = editTextColor
        } else {
            self.inputTextField.textColor = UIColor.init(commonColor: .appLightGray)
        }
    }
    
    private func getLeadingLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 48))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = leadingText
        label.font = leadingTextFont
        label.textColor = leadingTextColor
        label.textAlignment = .right
        label.sizeToFit()
        return label
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
    
    private func setupDefaultTextViewStyle() {
        placeholderFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: CommonFontSizes.mediumFontSize)
        placeholderTextColor = UIColor.init(commonColor: .appLightGray)
        editTextFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: CommonFontSizes.mediumFontSize)
        editTextColor = UIColor.init(commonColor: .appDarkGray)
        editTextCursorColor = UIColor.init(commonColor: .appDarkGray)
    }
    
    private func setupDefaultErrorStyle() {
        errorLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
        errorLabelColor = UIColor.init(commonColor: .appErrorRed)
    }
    
    private func setupDefaultDescriptionStyle() {
        errorLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
        errorLabelColor = UIColor.init(commonColor: .disableGery)
    }
    
    func updateStateTo(isError: Bool, error: String? = nil) {
        if isError {
            setErrorState(error: error)
        } else {
            setNormalState()
        }
    }
    
    private func setErrorState(error: String?) {
        errorIconImageView.isHidden = false
        errorIconImageView.image = trailingIcon == nil ? errorIcon : UIImage()
        setTextViewBorder(with: UIColor.init(commonColor: .appErrorRed))
        bottomDescriptionLabel.text = error
        bottomDescriptionLabel.isHidden = error?.isBlank ?? true
        setupDefaultErrorStyle()
    }
    
    private func setNormalState() {
        errorIconImageView.isHidden = true
        errorIconImageView.image = UIImage()
        setTextViewBorder(with: UIColor.init(commonColor: .appLightGray))
        
        bottomDescriptionLabel.text = textViewDescription
        bottomDescriptionLabel.isHidden = textViewDescription?.isBlank ?? true
        setupDefaultDescriptionStyle()
    }
    
    func setTextViewBorder(with color: UIColor) {
        inputTextField.layer.borderColor = color.cgColor
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.cornerRadius = 4
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        let text = sender.text
        inputTextField.text = formatter?.format(string: text ?? "") ?? text
        
        let deformattedString = formatter?.deFormat(string: inputTextField.text ?? "") ?? text
        onTextFieldChanged?(deformattedString?.trim())
    }
    
    func setupTextFieldGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapTextField(_:)))
        inputTextField.addGestureRecognizer(tap!)
    }
    
    func removeTextFieldGesture() {
        guard let tap = tap else {
            return
        }
        inputTextField.removeGestureRecognizer(tap)
    }
    
    @objc func didTapTextField(_ sender: UITapGestureRecognizer? = nil) {
        onTextFieldTapped?()
    }
}

extension LabelledTextview: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        let unformattedString = formatter?.deFormat(string: newString) ?? newString
        return isEditable && (inputFieldMaxLength ?? Int.max) >= (unformattedString.count)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditable
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let formatValidator = formatValidator else { return }
        if textField.text?.isEmpty ?? true {
            setNormalState()
            return
        } else if let inputFieldLength = inputFieldMinLength,
            textField.text?.count ?? 0 < inputFieldLength {
            setErrorState(error: formatValidator.invalidFormatError)
            return
        }
        let deformattedString = formatter?.deFormat(string: inputTextField.text ?? "").trim() ?? textField.text?.trim()
        if formatValidator.isValid(for: deformattedString ?? "") {
            setNormalState()
        } else {
            setErrorState(error: formatValidator.invalidFormatError)
        }
        onTextFieldFocusChange?(deformattedString)
    }
}
