//
//  NadraVerificationViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class NadraVerificationViewController: BaseViewController {
    
    var viewModel: NadraVerificationViewModelProtocol!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nextBtn: PrimaryCTAButton! {
        didSet {
            nextBtn.setTitle("Accept".localized, for: .normal)
            nextBtn.setTitle("Accept".localized, for: .selected)
            nextBtn.setTitle("Accept".localized, for: .disabled)
            nextBtn.setTitle("Accept".localized, for: .highlighted)
        }
    }
    @IBOutlet weak var cancelBtn: SecondaryCTAButton! {
        didSet {
            cancelBtn.setTitle("Cancel".localized, for: .normal)
            cancelBtn.setTitle("Cancel".localized, for: .selected)
            cancelBtn.setTitle("Cancel".localized, for: .disabled)
            cancelBtn.setTitle("Cancel".localized, for: .highlighted)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModelOutput()
    }

    @IBAction func nextBtnAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        viewModel.cancelButtonPressed()
    }
    
    private func setupUI() {
        titleLbl.text = "Dear Customer, Your Verification is required to proceed further. Please click  accept for verification".localized
    }
    
    private func bindViewModelOutput() {
        self.viewModel.output = {[unowned self] output in
            switch output {
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(error: let error):
                self.showAlert(with: error)
            case .showAlert(alertModel: let alertModel):
                self.showAlert(with: alertModel)
            }
        }
    }
}

extension NadraVerificationViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.nadraVerification
    }
}
