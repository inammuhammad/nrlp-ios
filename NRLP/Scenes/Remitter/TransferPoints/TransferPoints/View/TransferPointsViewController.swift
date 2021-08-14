//
//  TransferPointsViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class TransferPointsViewController: BaseViewController {

    var viewModel: TransferPointsViewModelProtocol!

    @IBOutlet weak var notFoundDescription: UILabel! {
        didSet {
            notFoundDescription.text = "Your beneficiary has not activated the account yet. Once the account is active you will be able to transfer the points.".localized
            notFoundDescription.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    @IBOutlet weak var notFoundTitle: UILabel! {
        didSet {
            notFoundTitle.text = "No Beneficiary found.".localized
            notFoundTitle.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
        }
    }
    @IBOutlet weak var notFoundView: UIView! {
        didSet {
            notFoundView.isHidden = true
        }
    }
    lazy var itemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.beneficiaryPickerViewModel
        return pickerView
    }()

    @IBOutlet weak var loyaltyPointsView: LoyaltyCardView!

    @IBOutlet weak var beneficiaryDropdown: LabelledTextview! {
        didSet {
            beneficiaryDropdown.titleLabelText = "Select Beneficiary".localized
            beneficiaryDropdown.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            beneficiaryDropdown.editTextKeyboardType = .asciiCapable
            beneficiaryDropdown.placeholderText = "Muhammad Ali".localized
            beneficiaryDropdown.editTextCursorColor = .init(white: 1, alpha: 0)
            beneficiaryDropdown.inputTextFieldInputPickerView = itemPickerView
        }
    }

    @IBOutlet weak var transferButton: PrimaryCTAButton! {
        didSet {
            transferButton.setTitle("Transfer".localized, for: .normal)
        }
    }

    @IBOutlet weak var pointsAmountTextArea: LabelledTextview! {
        didSet {
            pointsAmountTextArea.editTextKeyboardType = .asciiCapableNumberPad
            pointsAmountTextArea.titleLabelText = "Enter Points".localized
            pointsAmountTextArea.placeholderText = "xxxx"
            pointsAmountTextArea.formatValidator = FormatValidator(regex: RegexConstants.loyaltyPointsRegex, invalidFormatError: StringConstants.ErrorString.loyaltyPointsError.localized)
            pointsAmountTextArea.formatter = PointsFormatter()
            pointsAmountTextArea.inputFieldMaxLength = 13
            pointsAmountTextArea.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.transferPoints = updatedText
            }
            pointsAmountTextArea.onTextFieldFocusChange = { [weak self] text in
                guard let self = self else { return }
                self.viewModel.transferPoints = text
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModelOutput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewModelWillAppear()
    }
}

// MARK: Setup View and Bindings
extension TransferPointsViewController {
    func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let enableState):
                self.transferButton.isEnabled = enableState
            case .updateBeneficiary(let beneficiary):
                self.beneficiaryDropdown.inputText = beneficiary
            case .transferPointsTextField(let errorState, let error):
                self.pointsAmountTextArea.updateStateTo(isError: errorState, error: error)
            case .beneficiaryTextField(let errorState, let error):
                self.beneficiaryDropdown.updateStateTo(isError: errorState, error: error)
            case .showAlert(let alert):
                self.showAlert(with: alert)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .reloadBeneficiaries:
                self.itemPickerView.viewModel.setData(data: self.viewModel.beneficiaryItems)
            case .updateLoyaltyCard(let viewModel):
                self.loyaltyPointsView.populate(with: viewModel)
            case .showNoBeneficiary(let show):
                self.notFoundView.isHidden = show
                self.pointsAmountTextArea.isHidden = !show
                self.beneficiaryDropdown.isHidden = !show
                self.loyaltyPointsView.isHidden = !show
            }
        }
    }

    func setupView() {
        self.title = "Transfer Points".localized
    }

}

extension TransferPointsViewController: ItemPickerViewDelegate {
    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        viewModel.didSelect(beneficiaryItem: selectedItem as? BeneficiaryPickerItemModel)
        self.view.endEditing(true)
    }

    func didTapCancelButton() {
        self.view.endEditing(true)
    }

}

// MARK: Button Actions
extension TransferPointsViewController {
    @IBAction func transferButtonPressed(_ sender: PrimaryCTAButton) {
        viewModel.didTapTransferButton()
    }
}

extension TransferPointsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.transferPoints
    }
}
