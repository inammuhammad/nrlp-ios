//
//  FatherNameViewController.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 05/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class FatherNameViewController: BaseViewController {
    var viewModel: FatherNameViewModel!
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
            titleLbl.text = "To update your profile please provide below mentioned information.".localized
        }
    }

    @IBOutlet private weak var fatherNameTextView: LabelledTextview! {
        didSet {
            fatherNameTextView.titleLabelText = "Father Name *".localized
            fatherNameTextView.autoCapitalizationType = .words
            fatherNameTextView.inputFieldMaxLength = 50
            fatherNameTextView.inputFieldMinLength = 3
            fatherNameTextView.editTextKeyboardType = .asciiCapable
            fatherNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.fatherPopupError.localized)
            fatherNameTextView.onTextFieldChanged = { text in
                self.viewModel.fatherName = text
            }
        }
    }

    @IBOutlet weak var nextBtn: PrimaryCTAButton! {
        didSet {
            nextBtn.setTitle("Next".localized, for: .normal)
            nextBtn.setTitle("Next".localized, for: .selected)
            nextBtn.setTitle("Next".localized, for: .disabled)
            nextBtn.setTitle("Next".localized, for: .highlighted)
            nextBtn.isEnabled = false
            nextBtn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var cancelBtn: SecondaryCTAButton! {
        didSet {
            cancelBtn.setTitle("Cancel".localized, for: .normal)
            cancelBtn.setTitle("Cancel".localized, for: .selected)
            cancelBtn.setTitle("Cancel".localized, for: .disabled)
            cancelBtn.setTitle("Cancel".localized, for: .highlighted)
            cancelBtn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        if (AppConstants.appLanguage == .urdu && !AppConstants.isSystemLanguageUrdu()) || AppConstants.appLanguage == .english && AppConstants.isSystemLanguageUrdu() {
            titleLbl.textAlignment = .right
        } else {
            titleLbl.textAlignment = .left
        }
        
        bindViewModel()
    }
    
    @objc
    private func nextButtonTapped() {
        viewModel.nextTapped()
    }
    
    @objc
    private func cancelButtonTapped() {
        viewModel.cancelTapped()
    }
}

extension FatherNameViewController {
    private func bindViewModel() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(error: let error):
                self.showAlert(with: error)
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .nextButtonState(enableState: let enableState):
                nextBtn.isEnabled = enableState
            case .showAlert(let alertModel):
                self.showAlert(with: alertModel)
            }
        }
    }
}

extension FatherNameViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        .fatherName
    }
}
