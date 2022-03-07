//
//  ReceiverLandingViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ReceiverLandingViewController: BaseViewController {

    // MARK: - Properties
    
    var viewModel: ReceiverLandingViewModelProtocol!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var nextBtn: PrimaryCTAButton! {
        didSet {
            nextBtn.setTitle("Next".localized, for: .normal)
        }
    }
    @IBOutlet weak var skipBtn: PrimaryCTAButton! {
        didSet {
            skipBtn.setTitle("Skip".localized, for: .normal)
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        bindViewModelOutput()
        viewModel.viewDidLoad()
        setupUI()
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
            case .setDescription(text: let text):
                self.descriptionLbl.text = text
            case .setAttributedDescription(text: let text):
                self.descriptionLbl.attributedText = text
            }
        }
    }

    // MARK: - IBActions
    
    @IBAction func nextBtnAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
        viewModel.skipButtonPressed()
    }
}

// MARK: Extension - Initializable

extension ReceiverLandingViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.receiverLanding
    }
}
