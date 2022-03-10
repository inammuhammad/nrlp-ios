//
//  ReceiverDetailsViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ReceiverDetailsViewController: BaseViewController {

    // MARK: - Properties
    
    var viewModel: ReceiverDetailsViewModel!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var deleteBtn: PrimaryCTAButton! {
        didSet {
            deleteBtn.setTitle("Delete Receiver".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var fullNameTextView: LabelledTextview! {
        didSet {
            fullNameTextView.titleLabelText = "Full Name *".localized
            fullNameTextView.placeholderText = "Please enter Receiver Information".localized
            fullNameTextView.autoCapitalizationType = .words
            fullNameTextView.inputFieldMaxLength = 50
            fullNameTextView.isEditable = false
        }
    }
    
    @IBOutlet private weak var motherNameTextView: LabelledTextview! {
        didSet {
            motherNameTextView.titleLabelText = "Mother Maiden Name *".localized
            motherNameTextView.placeholderText = "Please enter Receiver Information".localized
            motherNameTextView.autoCapitalizationType = .words
            motherNameTextView.inputFieldMaxLength = 50
            motherNameTextView.isEditable = false
            motherNameTextView.isHidden = true
        }
    }
    
    @IBOutlet private weak var cnicTextView: LabelledTextview! {
        didSet {
            cnicTextView.titleLabelText = "CNIC/NICOP *".localized
            cnicTextView.placeholderText = "Please enter Receiver Information".localized
            cnicTextView.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextView.inputFieldMinLength = 13
            cnicTextView.inputFieldMaxLength = 13
            cnicTextView.isEditable = false
        }
    }
    
    @IBOutlet private weak var cnicIssueDateTextView: LabelledTextview! {
        didSet {
            cnicIssueDateTextView.titleLabelText = "CNIC/NICOP Issuance Date *".localized
            cnicIssueDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            cnicIssueDateTextView.placeholderText = "Please enter Receiver Information".localized
            cnicIssueDateTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            cnicIssueDateTextView.isEditable = false
            cnicIssueDateTextView.isTappable = false
            cnicIssueDateTextView.isHidden = true
        }
    }
    
    @IBOutlet private weak var birthPlaceTextView: LabelledTextview! {
        didSet {
            birthPlaceTextView.titleLabelText = "Place of Birth *".localized
            birthPlaceTextView.placeholderText = "Please enter Receiver Information".localized
            birthPlaceTextView.isEditable = false
            birthPlaceTextView.isTappable = false
            birthPlaceTextView.isHidden = true
        }
    }
    
    @IBOutlet private weak var countryTextView: LabelledTextview! {
        didSet {
            countryTextView.titleLabelText = "Country of Residence *".localized
            countryTextView.placeholderText = "Select Country".localized
            countryTextView.isEditable = false
            countryTextView.isTappable = false
            countryTextView.isHidden = true
        }
    }
    
    @IBOutlet private weak var mobileNumberTextView: LabelledTextview! {
        didSet {
            mobileNumberTextView.titleLabelText = "Mobile Number *".localized
            mobileNumberTextView.placeholderText = "Please enter Receiver Information".localized
            mobileNumberTextView.isEditable = false
        }
    }
    
    @IBOutlet private weak var bankNameTextView: LabelledTextview! {
        didSet {
            bankNameTextView.titleLabelText = "Bank Name *".localized
            bankNameTextView.placeholderText = "Please enter Receiver Information".localized
            bankNameTextView.isEditable = false
        }
    }
    
    @IBOutlet private weak var bankNumberTextView: LabelledTextview! {
        didSet {
            bankNumberTextView.titleLabelText = "Bank Number / IBAN *".localized
            bankNumberTextView.placeholderText = "Please enter Receiver Information".localized
            bankNumberTextView.isEditable = false
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModelOutput()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        self.title = "Remittance Receiver Management".localized
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showAlert(let alertViewModel):
                self.showAlert(with: alertViewModel)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .showBankFields(hidden: let hidden):
                self.bankNameTextView.isHidden = hidden
                self.bankNumberTextView.isHidden = hidden
            case .setUser(model: let model):
                setUserDetails(model: model)
            case .showDeleteButton(show: let show):
                deleteBtn.isHidden = !show
            }
        }
    }
    
    private func setUserDetails(model: ReceiverModel) {
        // SET USER DETAILS HERE
        fullNameTextView.inputText = model.receiverName
        cnicTextView.inputText = model.formattedReceiverCNIC
        mobileNumberTextView.inputText = model.receiverMobileNumber
        bankNameTextView.inputText = model.receiverBankName
        bankNumberTextView.inputText = model.receiverBankNumber
    }
    
    // MARK: - IBActions

    @IBAction func deleteBtnAction(_ sender: Any) {
        viewModel.deleteButtonPressed()
    }
}

extension ReceiverDetailsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.receiverDetails
    }
}
