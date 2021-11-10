//
//  BeneficiaryInfoViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BeneficiaryInfoViewController: BaseViewController {

    var viewModel: BeneficiaryInfoViewModelProtocol!

    @IBOutlet private weak var cnicTextField: LabelledTextview! {
        didSet {
            cnicTextField.titleLabelText = "CNIC/NICOP".localized
            cnicTextField.placeholderText = "4250180532901".localized
            cnicTextField.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextField.formatter = CNICFormatter()
            cnicTextField.isEditable = false
            cnicTextField.inputText = viewModel.cnic
            cnicTextField.editTextColor = UIColor.init(commonColor: .disableGery)
        }
    }

    @IBOutlet private weak var aliasTextField: LabelledTextview! {
        didSet {
            aliasTextField.titleLabelText = "Full Name".localized
            aliasTextField.placeholderText = "Muhammad Ali".localized
            aliasTextField.isEditable = false
            aliasTextField.editTextKeyboardType = .asciiCapable
            aliasTextField.inputText = viewModel.name
            aliasTextField.editTextColor = UIColor.init(commonColor: .disableGery)
        }
    }

    @IBOutlet private weak var mobileTextField: LabelledTextview! {
        didSet {
            mobileTextField.titleLabelText = "Beneficiary Mobile Number".localized
            mobileTextField.placeholderText = "+xx xxx xxx xxxx".localized
            mobileTextField.editTextKeyboardType = .asciiCapableNumberPad
            mobileTextField.isEditable = false
            mobileTextField.inputText = viewModel.mobileNumber
            mobileTextField.editTextColor = UIColor.init(commonColor: .disableGery)
        }
    }
    
    @IBOutlet private weak var relationTextField: LabelledTextview! {
        didSet {
            relationTextField.titleLabelText = "Beneficiary Relation".localized
            relationTextField.placeholderText = "Enter Beneficiary Relation".localized
            relationTextField.editTextKeyboardType = .asciiCapableNumberPad
            relationTextField.isEditable = false
            relationTextField.inputText = viewModel.relation
            relationTextField.editTextColor = UIColor.init(commonColor: .disableGery)
        }
    }

    @IBOutlet private weak var deleteBeneficiaryButton: PrimaryCTAButton! {
        didSet {
            deleteBeneficiaryButton.setTitle("Delete Beneficiary".localized, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
    }

    private func setupUI() {
        self.title = "Beneficiary Details".localized
    }

}

// MARK: Setup View and Bindings
extension BeneficiaryInfoViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(let error):
                self.showAlert(with: error)
            case .deleteButtonState:
                self.deleteBeneficiaryButton.isEnabled = true
            case .showAlert(let alert):
                self.showAlert(with: alert)
            case .dismissAlert:
                print("Dismiss")
            case .showActivityIndicator(let show):
                DispatchQueue.main.async {
                    show ? ProgressHUD.show() : ProgressHUD.dismiss()
                }
            }
        }
    }
}

// MARK: IBActions
extension BeneficiaryInfoViewController {
    @IBAction
    private func deleteBeneficiaryPressed(_ sender: PrimaryCTAButton) {
        viewModel.deleteButtonPressed()
    }
}

extension BeneficiaryInfoViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.beneficiaryInfo
    }
}
