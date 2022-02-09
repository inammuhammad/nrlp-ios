//
//  ComplaintUserTypeViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ComplaintUserTypeViewController: BaseViewController {
    
    var viewModel: ComplaintUserTypeViewModelProtocol!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Complaint Management".localized
            titleLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraUltraLargeFontSize)
            titleLabel.textColor = UIColor.init(commonColor: .appGreen)
        }
    }
    
    @IBOutlet weak var accountLabel: UILabel! {
        didSet {
            accountLabel.text = "Select User Type".localized
            accountLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraUltraLargeFontSize)
            accountLabel.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    
    @IBOutlet weak var accountTypeRadioButton: RadioButtonView! {
        didSet {
            accountTypeRadioButton.alignment = .vertical
            accountTypeRadioButton.setRadioButtonItems(items: viewModel.accountTypeItemModel)
            accountTypeRadioButton.setRadioItemSelected(at: 0, isSelected: true)
            accountTypeRadioButton.didUpdatedSelectedItem = { [weak self] item in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.viewModel.accountType = item.key
            }
        }
    }
    
    @IBOutlet weak var nextButton: PrimaryCTAButton! {
        didSet {
            nextButton.setTitle("Next".localized, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        bindViewModelOutput()
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .nextButtonState(state: let state):
                self.nextButton.isEnabled = state
            }
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
}

extension ComplaintUserTypeViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.complaintUserType
    }
}
