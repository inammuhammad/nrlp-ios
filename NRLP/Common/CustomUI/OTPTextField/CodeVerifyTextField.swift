//
//  CodeVerifyTextField.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

protocol KWTextFieldDelegate: class {
    func moveToNext(_ textFieldView: CodeVerifyTextField)
    func moveToPrevious(_ textFieldView: CodeVerifyTextField, oldCode: String)
    func didChangeCharacters()
}

class CodeVerifyTextField: UITextField, UITextFieldDelegate {

    private var characterLimit: Int?
    weak var codeDelegate: KWTextFieldDelegate?
    private let maxCharactersLength = 1
    var bottomLayer: CALayer?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.keyboardType = .asciiCapableNumberPad
        delegate =  self
        setTextViewBorder(with: UIColor(commonColor: .appBottomBorderViewShadow))
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: self)
        font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.boldOnlyEnglish, size: CommonFontSizes.extraUltraLargeFontSize)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }

    @objc func textFieldDidChange(_ notification: Foundation.Notification) {
        if self.text?.isEmpty ?? true {
            self.text = " "
        }
    }

    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentString = textField.text!
        let newString = currentString.replacingCharacters(in: textField.text!.range(from: range)!, with: string)

        if newString.count >= maxCharactersLength {
            codeDelegate?.moveToNext(textField as! CodeVerifyTextField)
            textField.text = string
        } else if newString.isEmpty {
            codeDelegate?.moveToPrevious(textField as! CodeVerifyTextField, oldCode: textField.text!)
            textField.text = " "
        }

        codeDelegate?.didChangeCharacters()

        return newString.count <= maxCharactersLength
    }

    public func activate() {
        self.becomeFirstResponder()
        if self.text?.isEmpty ?? true {
            self.text = " "
        }
    }

    public func deactivate() {
        self.resignFirstResponder()
    }

    public func reset() {
        self.text = " "
    }

    func updateForError() {

        self.textColor = UIColor(commonColor: .appErrorRed)
        updateLayer(with: UIColor(commonColor: .appErrorRed))
    }

    func updateForNormal() {

        self.textColor = UIColor(commonColor: .appDarkGray)
        updateLayer(with: UIColor(commonColor: .appDarkGray))
    }

    func clear() {
        updateForNormal()
        text = ""
    }

    func setupBottomLayer() {
        let layerColor = UIColor(commonColor: .appDarkGray)
        bottomLayer = createBorder(side: .bottom, thickness: 2.0, color: layerColor)
    }

    func updateLayer(with color: UIColor) {
        bottomLayer?.backgroundColor = color.cgColor
    }

    func setTextViewBorder(with color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 3
    }
}
