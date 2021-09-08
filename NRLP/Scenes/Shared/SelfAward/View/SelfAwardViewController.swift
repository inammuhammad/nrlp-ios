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
            proceedBtn.setTitle("Proceed", for: .normal)
            proceedBtn.setTitle("Proceed", for: .selected)
            proceedBtn.setTitle("Proceed", for: .disabled)
            proceedBtn.setTitle("Proceed", for: .highlighted)
            proceedBtn.addTarget(self, action: #selector(proceedBtnAction), for: .touchUpInside)
        }
    }

    @IBOutlet private weak var referenceNumberLabelTextView: LabelledTextview! {
        didSet {
            referenceNumberLabelTextView.titleLabelText = "Reference Number".localized
            referenceNumberLabelTextView.placeholderText = "xxxxxxxxxxxxxx"
            referenceNumberLabelTextView.inputFieldMaxLength = 25
            referenceNumberLabelTextView.editTextKeyboardType = .asciiCapable
            referenceNumberLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.referenceNumberRegex, invalidFormatError: StringConstants.ErrorString.referenceNumberError.localized)
            referenceNumberLabelTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.referenceNumber = updatedText
                self.validateFields()
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
            transactionAmountLabelTextView.inputFieldMaxLength = 13
            transactionAmountLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.transactionAmountRegex, invalidFormatError: StringConstants.ErrorString.transactionAmountError.localized)
            transactionAmountLabelTextView.formatter = CurrencyFormatter()
            transactionAmountLabelTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.transactionAmount = updatedText
                self.validateFields()
            }
        }
    }
    
    @IBOutlet weak var remittanceDateTextView: LabelledTextview! {
        didSet {
            remittanceDateTextView.titleLabelText = "Date of Remittance".localized
            remittanceDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            remittanceDateTextView.placeholderText = "YYYY-MM-DD".localized
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        self.title = "Self Award Points".localized
    }
    
    private func validateFields() {
        if let date = date, let referenceNo = referenceNumber, let transactionAmount = transactionAmount {
            if date == "" || referenceNo == "" || transactionAmount == "" {
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
        if let amount = self.transactionAmount, let date = self.date, let referenceNo = self.referenceNumber {
            showActivityIndicator(show: true)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newDate = dateFormatter.date(from: date)
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "yyyyMMdd"
            let newDateStr = dateFormatterOutput.string(from: newDate ?? Date())
            let service = SelfAwardOTPService()
            let model = SelfAwardModel(amount: amount, referenceNo: referenceNo, transactionDate: newDateStr)

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
