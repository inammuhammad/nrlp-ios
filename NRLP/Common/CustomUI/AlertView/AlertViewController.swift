//
//  AlertViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AlertViewController: UIViewController {

    @IBOutlet private weak var alertContainerView: UIView! {
        didSet {
            alertContainerView.cornerRadius = CommonDimens.unit1x.rawValue
        }
    }
    @IBOutlet private weak var alertImageView: UIImageView!
    @IBOutlet private weak var alertTitleLabel: UILabel! {
        didSet {
            alertTitleLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
        }
    }
    @IBOutlet private weak var alertDescriptionLabel: UILabel! {
           didSet {
            alertDescriptionLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
           }
       }
    @IBOutlet private weak var primaryCTAButton: PrimaryCTAButton!
    @IBOutlet private weak var secondaryCTAButton: SecondaryCTAButton!
    
    @IBOutlet weak var topTextField: LabelledTextview!
    @IBOutlet weak var middleTextField: LabelledTextview!
    @IBOutlet weak var bottomTextField: LabelledTextview!
    @IBOutlet weak var textFieldStackView: UIStackView!
    
    private var alertViewModel: AlertViewModel!
    private var error: APIResponseError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.3, animations: {
            self.alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            }
        }) 
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

// MARK: Alert Present/Dismiss Methods
extension AlertViewController {
    private static func presentAlert(on controller: UIViewController) -> AlertViewController {
        let alertVC = AlertViewController.getInstance()

        alertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        DispatchQueue.main.async {
            controller.present(alertVC, animated: true, completion: nil)
        }
        return alertVC
    }

    private func dismiss(with completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.alertContainerView.alpha = 0
        }, completion: { (_) in
            self.dismiss(animated: true, completion: {
                completion()
            })
        }) 
    }

    class func presentAlert(with alertViewModel: AlertViewModel,
                            from controller: UIViewController) {

        let alertVC = presentAlert(on: controller)
        alertVC.alertViewModel = alertViewModel
    }
    
    private func setupFonts() {

        func setOnlyEnglishFont() {
            alertTitleLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .largeFontSize)
            alertDescriptionLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.lightOnlyEnglish, size: .mediumFontSize)
        }
        
        func setUrduBaseFont() {
            alertTitleLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .largeFontSize)
        }
        
        if alertViewModel.alertTitle == StringConstants.ErrorString.serverErrorTitle {
            alertTitleLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .largeFontSize)
        } else if AppConstants.appLanguage == .urdu {
            setUrduBaseFont()
        }
        
        switch error {
        case .requestError, .server:
            setOnlyEnglishFont()
        default:
            break
        }
    }

    class func presentAlert(with error: APIResponseError,
                            from controller: UIViewController) {

        let alertVC = presentAlert(on: controller)
        alertVC.alertViewModel = AlertViewModel(alertHeadingImage: error.illustrationImage, alertTitle: error.title, alertDescription: error.message, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized))
        alertVC.error = error
    }

    private func setupView() {
        if alertViewModel.alertHeadingImage.rawValue.lowercased() == AlertIllustrationType.noImage.rawValue.lowercased() {
            alertImageView.isHidden = true
        } else {
            alertImageView.isHidden = false
        }
        alertImageView.image = UIImage(named: alertViewModel.alertHeadingImage.rawValue)
        if let description = alertViewModel.alertDescription {
            alertDescriptionLabel.text = description
        } else {
            alertDescriptionLabel.attributedText = alertViewModel.alertAttributedDescription
        }
        self.view.backgroundColor = UIColor.init(commonColor: .appBackgroundDarkOverlay)

        setupAlertTitleLabel()
        setupAlertPrimaryActionButtons()
        setupAlertSecondaryActionButtons()
        setupFonts()
        setupTextFields()
    }

    private func setupAlertTitleLabel() {
        if let title = alertViewModel?.alertTitle {
            alertTitleLabel.text = title
            alertTitleLabel.isHidden = false
        } else {
            alertTitleLabel.isHidden = true
        }
    }

    private func setupAlertPrimaryActionButtons() {
        primaryCTAButton.setTitle(alertViewModel.primaryButton.buttonTitle, for: .normal)
    }

    private func setupAlertSecondaryActionButtons() {
        if let secondaryButton = alertViewModel?.secondaryButton {
            secondaryCTAButton.setTitle(secondaryButton.buttonTitle, for: .normal)
            secondaryCTAButton.isHidden = false
        } else {
            secondaryCTAButton.isHidden = true
        }
    }
    
    private func setupTextFields() {
        topTextField.isHidden = true
        middleTextField.isHidden = true
        bottomTextField.isHidden = true
        
        if alertViewModel.topTextField != nil {
            topTextField.isHidden = false
            topTextField.titleLabelText = alertViewModel.topTextField?.titleLabelText
            topTextField.placeholderText = alertViewModel.topTextField?.placeholderText
            topTextField.inputText = alertViewModel.topTextField?.inputText
            topTextField.inputFieldMaxLength = alertViewModel.topTextField?.inputFieldMaxLength
            topTextField.inputFieldMinLength = alertViewModel.topTextField?.inputFieldMinLength
            topTextField.editTextKeyboardType = alertViewModel.topTextField?.editKeyboardType ?? .alphabet
            topTextField.formatValidator = alertViewModel.topTextField?.formatValidator
            topTextField.onTextFieldChanged = { [weak self] text in
                self?.alertViewModel.topTextField?.onTextFieldChanged?(text ?? "")
            }
            topTextField.formatter = alertViewModel.topTextField?.formatter
        }
        
        if alertViewModel.middleTextField != nil {
            middleTextField.isHidden = false
            middleTextField.titleLabelText = alertViewModel.middleTextField?.titleLabelText
            middleTextField.placeholderText = alertViewModel.middleTextField?.placeholderText
            middleTextField.inputText = alertViewModel.middleTextField?.inputText
            middleTextField.inputFieldMaxLength = alertViewModel.middleTextField?.inputFieldMaxLength
            middleTextField.inputFieldMinLength = alertViewModel.middleTextField?.inputFieldMinLength
            middleTextField.editTextKeyboardType = alertViewModel.middleTextField?.editKeyboardType ?? .alphabet
            middleTextField.formatValidator = alertViewModel.middleTextField?.formatValidator
            middleTextField.onTextFieldChanged = { [weak self] text in
                self?.alertViewModel.middleTextField?.onTextFieldChanged?(text ?? "")
            }
            middleTextField.formatter = alertViewModel.middleTextField?.formatter
        }
        
        if alertViewModel.bottomTextField != nil {
            bottomTextField.isHidden = false
            bottomTextField.titleLabelText = alertViewModel.bottomTextField?.titleLabelText
            bottomTextField.placeholderText = alertViewModel.bottomTextField?.placeholderText
            bottomTextField.inputText = alertViewModel.bottomTextField?.inputText
            bottomTextField.inputFieldMaxLength = alertViewModel.bottomTextField?.inputFieldMaxLength
            bottomTextField.inputFieldMinLength = alertViewModel.bottomTextField?.inputFieldMinLength
            bottomTextField.editTextKeyboardType = alertViewModel.bottomTextField?.editKeyboardType ?? .alphabet
            bottomTextField.formatValidator = alertViewModel.bottomTextField?.formatValidator
            bottomTextField.onTextFieldChanged = { [weak self] text in
                self?.alertViewModel.bottomTextField?.onTextFieldChanged?(text ?? "")
            }
            bottomTextField.formatter = alertViewModel.bottomTextField?.formatter
        }
    }
}

// MARK: IBOutlet actions
extension AlertViewController {
    @IBAction func didTapPrimaryButton(_: Any) {
        dismiss {
            self.alertViewModel.primaryButton.buttonAction?()
        }
    }

    @IBAction func didTapSecondaryButton(_: Any) {
        dismiss {
            self.alertViewModel.secondaryButton?.buttonAction?()
        }
    }

}

extension AlertViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.alert
    }
}
