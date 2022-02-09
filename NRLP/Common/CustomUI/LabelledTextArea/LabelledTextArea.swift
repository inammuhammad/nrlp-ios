//
//  LabelledTextArea.swift
//  NRLP
//
//  Created by Bilal Iqbal on 27/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias TextAreaChangedCallBack = ((String?) -> Void)
typealias TextAreaTappedCallBack = (() -> Void)
typealias TextAreaFocusChangeCallBack = ((String?) -> Void)

@IBDesignable
class LabelledTextArea: CustomNibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private  weak var inputTextArea: UITextViewPadding!
    @IBOutlet private weak var bottomDescriptionLabel: UILabel!
    
    var onTextAreaChanged: TextAreaChangedCallBack?
    var onTextAreaTapped: TextAreaTappedCallBack?
    var onTextAreaFocusChange: TextAreaFocusChangeCallBack?
    
    private var tap: UITapGestureRecognizer?
    
    //Regex validator
    var formatValidator: FormatValidatorProtocol?
    
    var editTextKeyboardType: UIKeyboardType {
        get {
            inputTextArea.keyboardType
        } set {
            inputTextArea.keyboardType = newValue
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return inputTextArea.becomeFirstResponder()
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
            inputTextArea.autocapitalizationType
        } set {
            inputTextArea.autocapitalizationType = newValue
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
    
    var editTextFont: UIFont? {
        get {
            inputTextArea.font
        } set {
            inputTextArea.font = newValue
        }
    }
    
    @IBInspectable
    var editTextColor: UIColor? {
        didSet {
            inputTextArea.textColor = editTextColor
        }
    }
    
    @IBInspectable
    var editTextCursorColor: UIColor? {
        get {
            inputTextArea.tintColor
        } set {
            inputTextArea.tintColor = newValue
        }
    }
    
    @IBInspectable
    var inputText: String? {
        get {
            inputTextArea.text ?? ""
        } set {
            inputTextArea.text = formatter?.format(string: newValue ?? "") ?? newValue
        }
    }
    
    var firstResponder: Bool = false {
        didSet {
            _ = firstResponder ? inputTextArea.becomeFirstResponder() : inputTextArea.resignFirstResponder()
        }
    }
    
    var formatter: FormatterProtocol?
    
    var inputTextAreaMinLength: Int?
    var inputTextAreaMaxLength: Int?
    
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
    
    var inputTextAreaInputPickerView: UIView? {
        didSet {
            if let inputTextAreaInputPickerView = inputTextAreaInputPickerView {
                inputTextArea.inputView = inputTextAreaInputPickerView
                guard let toolbar = (inputTextAreaInputPickerView as? PickerToolbarProtocol)?.toolbar else { return }
                inputTextArea.inputAccessoryView = toolbar
            } else {
                inputTextArea.inputView = nil
            }
        }
    }
    
    var textViewDescription: String? = nil {
        didSet {
            setNormalState()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        inputTextArea.delegate = self
        inputTextArea.autocorrectionType = .no
        setupDefaultTitleLabelStyle()
        setupDefaultTextViewStyle()
        setupDefaultErrorStyle()
        setNormalState()
        
        inputTextArea.textAlignment = .left
    }
    
    private func updateTextViewStyle() {
        if isEditable || isTappable {
            self.inputTextArea.textColor = editTextColor
        } else {
            self.inputTextArea.textColor = UIColor.init(commonColor: .appLightGray)
        }
    }
    
    private func setupDefaultTitleLabelStyle() {
        //Need to use Dimens
        titleLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.smallFontSize.rawValue)
        titleLabelTextColor = UIColor.init(commonColor: .appGreen)
    }
    
    func setupTextFieldGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapTextArea(_:)))
        inputTextArea.addGestureRecognizer(tap!)
    }
    
    private func setupDefaultTextViewStyle() {
        editTextFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: CommonFontSizes.mediumFontSize)
        editTextColor = UIColor.init(commonColor: .appDarkGray)
        editTextCursorColor = UIColor.init(commonColor: .appDarkGray)
    }

    func removeTextFieldGesture() {
        guard let tap = tap else {
            return
        }
        inputTextArea.removeGestureRecognizer(tap)
    }
    
    @objc func didTapTextArea(_ sender: UITapGestureRecognizer? = nil) {
        onTextAreaTapped?()
    }
    
    private func setNormalState() {
        setTextAreaBorder(with: UIColor.init(commonColor: .appLightGray))
        
        bottomDescriptionLabel.text = textViewDescription
        bottomDescriptionLabel.isHidden = textViewDescription?.isBlank ?? true
        setupDefaultDescriptionStyle()
    }
    
    func setTextAreaBorder(with color: UIColor) {
        inputTextArea.layer.borderColor = color.cgColor
        inputTextArea.layer.borderWidth = 1
        inputTextArea.layer.cornerRadius = 4
    }
    
    private func setupDefaultDescriptionStyle() {
        errorLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
        errorLabelColor = UIColor.init(commonColor: .disableGery)
    }
    
    private func setupDefaultErrorStyle() {
        errorLabelFont = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
        errorLabelColor = UIColor.init(commonColor: .appErrorRed)
    }
    
    func updateStateTo(isError: Bool, error: String? = nil) {
        if isError {
            setErrorState(error: error)
        } else {
            setNormalState()
        }
    }
    
    private func setErrorState(error: String?) {
        setTextAreaBorder(with: UIColor.init(commonColor: .appErrorRed))
        bottomDescriptionLabel.text = error
        bottomDescriptionLabel.isHidden = error?.isBlank ?? true
        setupDefaultErrorStyle()
    }
}

extension LabelledTextArea: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        inputTextArea.text = formatter?.format(string: text ?? "") ?? text
        
        let deformattedString = formatter?.deFormat(string: inputTextArea.text ?? "") ?? text
        onTextAreaChanged?(deformattedString?.trim())
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = ((textView.text ?? "") as NSString).replacingCharacters(in: range, with: text)
        let unformattedString = formatter?.deFormat(string: newString) ?? newString
        return isEditable && (inputTextAreaMaxLength ?? Int.max) >= (unformattedString.count)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return isEditable
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let formatValidator = formatValidator else { return }
        if textView.text?.isEmpty ?? true {
            setNormalState()
            return
        } else if let inputFieldLength = inputTextAreaMinLength, textView.text?.count ?? 0 < inputFieldLength {
            setErrorState(error: formatValidator.invalidFormatError)
            return
        }
        let deformattedString = formatter?.deFormat(string: inputTextArea.text ?? "").trim() ?? textView.text?.trim()
        if formatValidator.isValid(for: deformattedString ?? "") {
            setNormalState()
        } else {
            setErrorState(error: formatValidator.invalidFormatError)
        }
        onTextAreaFocusChange?(deformattedString)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
