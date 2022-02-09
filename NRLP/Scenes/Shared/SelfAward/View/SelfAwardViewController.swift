//
//  SelfAwardViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/08/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class SelfAwardViewController: BaseViewController {
    
    // MARK: Properties
    
    var remittanceDate: Date? {
        didSet {
            validateFields()
        }

    }
    var referenceNumber: String?
    var transactionAmount: String?
    var beneficaryCnic: String?
    var user: UserModel?
    
    var datePickerViewModel: CustomDatePickerViewModel {
        return CustomDatePickerViewModel(maxDate: Date())
    }
    
    private lazy var remittanceDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = datePickerViewModel
        return pickerView
    }()
    
    private var remittanceDateString: String? {
        if let date = remittanceDate {
            return DateFormat().formatDateString(to: date, formatter: .shortDateFormat)
        } else {
            return nil
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var proceedBtn: PrimaryCTAButton! {
        didSet {
            proceedBtn.isEnabled = false
            proceedBtn.setTitle("Proceed".localized, for: .normal)
            proceedBtn.setTitle("Proceed".localized, for: .selected)
            proceedBtn.setTitle("Proceed".localized, for: .disabled)
            proceedBtn.setTitle("Proceed".localized, for: .highlighted)
            proceedBtn.addTarget(self, action: #selector(proceedBtnAction), for: .touchUpInside)
        }
    }

    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.text = "Enter your remittance transaction reference number. Note: (Current year Transaction can only be used for Self-Awarding, applicable from 1st Oct 2021)".localized
        }
    }
    @IBOutlet private weak var referenceNumberLabelTextView: LabelledTextview! {
        didSet {
            referenceNumberLabelTextView.titleLabelText = "Transaction Reference No. / TT No.".localized
            referenceNumberLabelTextView.placeholderText = "xxxxxxxxxxxxxx"
            referenceNumberLabelTextView.showHelpBtn = true
            referenceNumberLabelTextView.helpLabelText = "Enter your remittance transaction reference number. Note: (Current year Transaction can only be used for Self-Awarding, applicable from 1st Oct 2021)".localized
            referenceNumberLabelTextView.helpPopupIcon = .selfAward
            referenceNumberLabelTextView.inputFieldMaxLength = 25
            referenceNumberLabelTextView.editTextKeyboardType = .asciiCapable
            referenceNumberLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.referenceNumberRegex, invalidFormatError: StringConstants.ErrorString.referenceNumberError.localized)
            referenceNumberLabelTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.referenceNumber = updatedText
                self.validateFields()
            }
            referenceNumberLabelTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }

    @IBOutlet private weak var transactionAmountLabelTextView: LabelledTextview! {
        didSet {
            transactionAmountLabelTextView.editTextKeyboardType = .decimalPad
            transactionAmountLabelTextView.titleLabel.numberOfLines = 0
            transactionAmountLabelTextView.titleLabelText = "Transaction Amount \nEnter exact amount as per your transaction receipt".localized
            transactionAmountLabelTextView.placeholderText = "xx,xxx".localized
            transactionAmountLabelTextView.leadingText = "PKR ".localized
            transactionAmountLabelTextView.showHelpBtn = true
            transactionAmountLabelTextView.helpPopupIcon = .selfAward
            transactionAmountLabelTextView.helpLabelText = "Enter exact amount as per you transaction receipt".localized
            transactionAmountLabelTextView.inputFieldMaxLength = 13
            transactionAmountLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.transactionAmountRegex, invalidFormatError: StringConstants.ErrorString.transactionAmountError.localized)
            transactionAmountLabelTextView.formatter = CurrencyFormatter()
            transactionAmountLabelTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.transactionAmount = updatedText
                self.validateFields()
            }
            transactionAmountLabelTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    @IBOutlet weak var remittanceDateTextView: LabelledTextview! {
        didSet {
            remittanceDateTextView.titleLabelText = "Date of Remittance".localized
            remittanceDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            remittanceDateTextView.placeholderText = "YYYY-MM-DD".localized
            remittanceDateTextView.showHelpBtn = true
            remittanceDateTextView.helpLabelText = "Enter date on which transaction is made".localized
            remittanceDateTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            remittanceDateTextView.inputTextFieldInputPickerView = remittanceDatePicker
            remittanceDateTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var beneficaryCnicTextView: LabelledTextview! {
        didSet {
            beneficaryCnicTextView.titleLabelText = "Beneficiary Account Number/ IBAN/CNIC".localized
            beneficaryCnicTextView.placeholderText = "xxxxxxxxxxxxx".localized
            beneficaryCnicTextView.editTextKeyboardType = .default
            beneficaryCnicTextView.inputFieldMinLength = 1
            beneficaryCnicTextView.showHelpBtn = true
            beneficaryCnicTextView.isEditable = true
            beneficaryCnicTextView.helpPopupIcon = .selfAward
            beneficaryCnicTextView.helpLabelText = "Enter Beneficiary Account Number/ IBAN/CNIC  on which remittance is sent".localized
            beneficaryCnicTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.beneficaryCnic = updatedText
                self.validateFields()
            }
            beneficaryCnicTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        showInitialAlert()
        setupUI()
    }
    
    private func setupUI() {
        self.title = "Self Award Points".localized
        if (AppConstants.appLanguage == .urdu && !AppConstants.isSystemLanguageUrdu()) || AppConstants.appLanguage == .english && AppConstants.isSystemLanguageUrdu() {
            titleLbl.textAlignment = .right
        } else {
            titleLbl.textAlignment = .left
        }
    }
    
    private func showInitialAlert() {
        let alert: AlertViewModel
        let okButton = AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil)
        alert = AlertViewModel(alertHeadingImage: .selfAward, alertTitle: "Dear Remitter,\nIf you have not been awarded\npoints against your remittance\ntransaction automatically,\nplease wait at least 05\n working days after your\nremittance has been\nprocessed to self-award\n points.".localized, alertDescription: "For further assistance, you may contact +92-21-111-116757".localized, alertAttributedDescription: nil, primaryButton: okButton, secondaryButton: nil)
        self.showAlert(with: alert)
    }
    
    private func validateFields() {
        if let referenceNo = referenceNumber, let transactionAmount = transactionAmount, let cnic = beneficaryCnic, let date = self.remittanceDateString {
            if referenceNo.isEmpty || transactionAmount.isEmpty || cnic.isEmpty || date.isEmpty {
                proceedBtn.isEnabled = false
            } else {
                proceedBtn.isEnabled = true
            }
        } else {
            proceedBtn.isEnabled = false
        }
    }
    
    @objc private func proceedBtnAction() {
        if let amount = self.transactionAmount, let referenceNo = self.referenceNumber, let cnic = self.beneficaryCnic, let date = self.remittanceDateString {
            showActivityIndicator(show: true)
            let service = SelfAwardOTPService()
            let model = SelfAwardModel(amount: amount, referenceNo: referenceNo, beneficiaryCnic: cnic, remittanceDate: date)

            service.validateTransaction(requestModel: model) {[weak self] (result) in
                self?.showActivityIndicator(show: false)
                switch result {
                case .success(let response):
                    guard let user = self?.user else { return }
                    self?.navigateToOTPScreen(model: model, user: user, responseModel: response)
                case .failure(let error):
                    switch error {
                    case .server(let response):
                        if response?.errorCode.lowercased() == "AUTH-VRN-06".lowercased() {
                            self?.showAlert(with: AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Oh Snap!".localized, alertDescription: "transactionNotFoundError".localized, alertAttributedDescription: nil, primaryButton: .init(buttonTitle: "Okay".localized, buttonAction: nil), secondaryButton: nil, topTextField: nil, middleTextField: nil, bottomTextField: nil))
                        } else {
                            self?.showAlert(with: error)
                        }
                    default:
                        self?.showAlert(with: error)
                    }
               }
            }
        }
    }
    
    private func showActivityIndicator(show: Bool) {
        show ? ProgressHUD.show() : ProgressHUD.dismiss()
    }
    
    private func navigateToOTPScreen(model: SelfAwardModel, user: UserModel, responseModel: SelfAwardValidateResponseModel) {
        let vc = SelfAwardOTPViewController.getInstance()
        vc.viewModel = SelfAwardOTPViewModel(model: model, navigationController: self.navigationController ?? UINavigationController(), user: user, responseModel: responseModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension SelfAwardViewController: CustomDatePickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }
    
    func didTapDoneButton(picker: CustomDatePickerView, date: Date) {
        self.view.endEditing(true)
        switch picker {
        case self.remittanceDatePicker:
            self.remittanceDate = date
            self.remittanceDateTextView.inputText = remittanceDateString
        default:
            break
        }
    }
}

extension SelfAwardViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.selfAward
    }
}
