//
//  ReceiverSuccessViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ReceiverSuccessViewController: BaseViewController {

    // MARK: - Properties
    
    var viewModel: ReceiverSuccessViewModel!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var doneBtn: PrimaryCTAButton! {
        didSet {
            doneBtn.setTitle("Done".localized, for: .normal)
        }
    }
    @IBOutlet weak var successLbl: UILabel! {
        didSet {
            successLbl.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.extraUltraLargeFontSize.rawValue)
            successLbl.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        setupUI()
        bindViewModelOutput()
        viewModel.viewDidLoad()
        super.viewDidLoad()
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
            case .setSuccessMessage(text: let text):
                self.successLbl.text = text
            }
        }
    }
    
    // MARK: - IBActions

    @IBAction func doneBtnAction(_ sender: Any) {
        viewModel.doneButtonPressed()
    }
}

// MARK: Extension - Initializable

extension ReceiverSuccessViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.receiverSuccess
    }
}
