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
    
    var date: String?
    var referenceNumber: String?
    var transactionAmount: String?
    
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
            titleLbl.text = "Transaction within 1 year is eligible for self awarding".localized
        }
    }
    @IBOutlet private weak var referenceNumberLabelTextView: LabelledTextview! {
        didSet {
            referenceNumberLabelTextView.titleLabelText = "Remitter Transaction Reference No".localized
            referenceNumberLabelTextView.placeholderText = "xxxxxxxxxxxxxx"
            referenceNumberLabelTextView.showHelpBtn = true
            referenceNumberLabelTextView.helpLabelText = "Transaction within 1 year is eligible for self awarding".localized
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
            transactionAmountLabelTextView.leadingText = "PKR "
            transactionAmountLabelTextView.showHelpBtn = true
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
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
            remittanceDateTextView.inputTextFieldInputPickerView = datePicker
            remittanceDateTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
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
    }
    
    private func showInitialAlert() {
        let alert: AlertViewModel
        let okButton = AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil)
        alert = AlertViewModel(alertHeadingImage: .selfAward, alertTitle: "Dear Remitter,\nIf you have not been awarded\npoints against your remittance\ntransaction automatically,\nplease wait at least 05\n working days after your\nremittance has been\nprocessed to self-award\n points.", alertDescription: "For further assistance, you may contact +92-21-111-116757", alertAttributedDescription: nil, primaryButton: okButton, secondaryButton: nil)
        self.showAlert(with: alert)
    }
    
    private func validateFields() {
        if let referenceNo = referenceNumber, let transactionAmount = transactionAmount {
            if referenceNo == "" || transactionAmount == "" {
                proceedBtn.isEnabled = false
            } else {
                proceedBtn.isEnabled = true
            }
        } else {
            proceedBtn.isEnabled = false
        }
    }
    
    @objc private func dateSelected(_ sender: UIDatePicker) {
        let dateSelected = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: dateSelected)
        self.date = dateStr
        remittanceDateTextView.inputText = dateStr
        validateFields()
    }
    
    @objc private func proceedBtnAction() {
        if let amount = self.transactionAmount, let referenceNo = self.referenceNumber {
            showActivityIndicator(show: true)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let newDate = dateFormatter.date(from: date)
//            let dateFormatterOutput = DateFormatter()
//            dateFormatterOutput.dateFormat = "yyyyMMdd"
//            let newDateStr = dateFormatterOutput.string(from: newDate ?? Date())
            let service = SelfAwardOTPService()
            let model = SelfAwardModel(amount: amount, referenceNo: referenceNo)

            service.validateTransaction(requestModel: model) {[weak self] (result) in
                self?.showActivityIndicator(show: false)
                switch result {
                case .success(_):
                    self?.navigateToOTPScreen(model: model)
                case .failure(let error):
                    self?.showAlert(with: error)
               }
            }
        }
    }
    
    private func showActivityIndicator(show: Bool) {
        show ? ProgressHUD.show() : ProgressHUD.dismiss()
    }
    
    private func navigateToOTPScreen(model: SelfAwardModel) {
        let vc = SelfAwardOTPViewController.getInstance()
        vc.viewModel = SelfAwardOTPViewModel(model: model, navigationController: self.navigationController ?? UINavigationController())
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension SelfAwardViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.selfAward
    }
}
