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
    
    var transactionType: TransactionType? {
        didSet {
            cnicTextView.isHidden = true
            ibanTextView.isHidden = true
            
            if transactionType == .cnic {
                cnicTextView.isHidden = false
            } else if transactionType == .bank {
                ibanTextView.isHidden = false
            }
            
            validateFields()
        }
    }
    
    var remittanceDate: Date? {
        didSet {
            validateFields()
        }
        
    }
    var referenceNumber: String?
    var transactionAmount: String?
    var iban: String?
    var cnic: String?
    var user: UserModel?
    
    var datePickerViewModel: CustomDatePickerViewModel {
        var datePickerViewModel = CustomDatePickerViewModel()
        datePickerViewModel.maxDate = Date().adding(days: -3) ?? Date()
        datePickerViewModel.minDate = DateFormat().formatDate(dateString: "20211001", formatter: .advanceStatementFormat)
        
        return datePickerViewModel
    }
    
    private lazy var remittanceDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.isSelfAward = true
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
    
    private lazy var itemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = transactionTypePickerViewModel
        return pickerView
    }()
    
    private var transactionTypePickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(
            data: [
                TransactionTypePickerItemModel(
                    title: TransactionType.cnic.getTitle(),
                    key: TransactionType.cnic.rawValue
                ),
                TransactionTypePickerItemModel(
                    title: TransactionType.bank.getTitle(),
                    key: TransactionType.bank.rawValue
                )
            ]
        )
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
            referenceNumberLabelTextView.inputFieldMinLength = 5
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
            transactionAmountLabelTextView.formatter = TransactionAmountFormatter()
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
    @IBOutlet weak var transactionTypeTextView: LabelledTextview! {
        didSet {
            transactionTypeTextView.titleLabelText = "Remittance Transaction Type".localized
            transactionTypeTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            transactionTypeTextView.placeholderText = "Select Transaction Type".localized
            transactionTypeTextView.showHelpBtn = true
            transactionTypeTextView.helpPopupIcon = .selfAward
            transactionTypeTextView.helpLabelText = "Enter Beneficiary Account Number/ IBAN/CNIC  on which remittance is sent".localized
            transactionTypeTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            transactionTypeTextView.inputTextFieldInputPickerView = itemPickerView
            transactionTypeTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var ibanTextView: LabelledTextview! {
        didSet {
            ibanTextView.titleLabelText = "Beneficiary Account Number/ IBAN".localized
            ibanTextView.placeholderText = "xxxxxxxxxxxxx".localized
            ibanTextView.editTextKeyboardType = .default
            ibanTextView.inputFieldMinLength = 1
            ibanTextView.inputFieldMaxLength = 24
            ibanTextView.isEditable = true
            ibanTextView.formatValidator = FormatValidator(regex: RegexConstants.ibanRegex, invalidFormatError: "Please enter a valid Account Number/IBAN".localized)
            ibanTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.iban = updatedText
                self.validateFields()
            }
            ibanTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var cnicTextView: LabelledTextview! {
        didSet {
            cnicTextView.titleLabelText = "Beneficiary CNIC".localized
            cnicTextView.placeholderText = "xxxxx-xxxxxxx-x".localized
            cnicTextView.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextView.inputFieldMinLength = 13
            cnicTextView.inputFieldMaxLength = 13
            cnicTextView.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            cnicTextView.formatter = CNICFormatter()
            cnicTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.cnic = updatedText
                self.validateFields()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        showInitialAlert()
        setupUI()
    }
    
    private func setupUI() {
        self.title = "Self Award Points".localized
        if (AppConstants.appLanguage == .urdu && !AppConstants.isSystemLanguageUrdu()) || AppConstants.appLanguage == .english && AppConstants.isSystemLanguageUrdu() {
            titleLbl.textAlignment = .right
        } else {
            titleLbl.textAlignment = .left
        }
        
        ibanTextView.isHidden = true
        cnicTextView.isHidden = true
    }
    
    private func showInitialAlert() {
        let alert: AlertViewModel
        let okButton = AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil)
        alert = AlertViewModel(alertHeadingImage: .selfAward, alertTitle: "".localized, alertDescription: "1. For self- awarding of points, please wait for 3 working days after your remittance is credited in the account or received by your beneficiary.\n\n2. RDA customers shall only be eligible for auto awarding of points against the amount which is consumed locally and cannot be repatriated.".localized, alertAttributedDescription: nil, primaryButton: okButton, secondaryButton: nil)
        self.showAlert(with: alert)
    }
    
    private func validateFields() {
        guard let referenceNumber = referenceNumber,
              let transactionAmount = transactionAmount,
              let remittanceDateString = remittanceDateString,
              let transactionType = transactionType
        else {
            proceedBtn.isEnabled = false
            return
        }
        
        if  referenceNumber.isBlank ||
                referenceNumber.count < 5 ||
                referenceNumber.count > 25 ||
                transactionAmount.isBlank ||
                remittanceDateString.isBlank {
            proceedBtn.isEnabled = false
        } else {
            if transactionType == .cnic, !(cnic?.isBlank ?? true) {
                // do cnic stuff
                if !(cnic?.isBlank ?? true), cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
                    proceedBtn.isEnabled = true
                } else {
                    proceedBtn.isEnabled = false
                }
                
            } else if transactionType == .bank, !(iban?.isBlank ?? true) {
                // do bank stuff
                if !(iban?.isBlank ?? true), iban?.isValid(for: RegexConstants.ibanRegex) ?? false {
                    ibanTextView.updateStateTo(isError: false)
                    proceedBtn.isEnabled = true
                } else {
                    ibanTextView.updateStateTo(isError: true, error: "Please enter a valid Account Number/IBAN".localized)
                    proceedBtn.isEnabled = false
                }
            } else {
                // do nothing stuff
                ibanTextView.updateStateTo(isError: false)
                proceedBtn.isEnabled = false
            }
        }
    }
    
    @objc private func proceedBtnAction() {
        if let amount = self.transactionAmount, let referenceNo = self.referenceNumber, let date = self.remittanceDateString {
            showActivityIndicator(show: true)
            let service = SelfAwardOTPService()
            
            var model = SelfAwardModel(amount: amount, referenceNo: referenceNo, beneficiaryCnic: "-", remittanceDate: date, type: transactionType == .cnic ? "COC" : "ACC")
            
            if transactionType == .cnic, let cnic = cnic {
                model.beneficiaryCnic = cnic
            } else if transactionType == .bank, let iban = iban {
                model.beneficiaryCnic = iban
            }
            
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
    
    func didSelect(transactionType: TransactionTypePickerItemModel) {
        self.transactionType = transactionType.transactionType
        setTransactionType(text: self.transactionType?.getTitle() ?? "")
    }
    
    func setTransactionType(text: String) {
        self.transactionTypeTextView.inputText = text
    }
}

extension SelfAwardViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }
    
    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        if let item = selectedItem as? TransactionTypePickerItemModel {
            didSelect(transactionType: item)
        } else {
            self.transactionType = nil
        }
        self.view.endEditing(true)
    }
}

extension SelfAwardViewController: CustomDatePickerViewDelegate {
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
