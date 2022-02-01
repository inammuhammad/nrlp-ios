//
//  ComplaintTypeViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ComplaintTypeViewController: BaseViewController {
    
    var viewModel: ComplaintTypeViewModelProtocol!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Complaint Management".localized
            titleLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraUltraLargeFontSize)
            titleLabel.textColor = UIColor.init(commonColor: .appGreen)
        }
    }
    
    @IBOutlet weak var complaintLabel: UILabel! {
        didSet {
            complaintLabel.text = "Complaint Type".localized
            complaintLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraUltraLargeFontSize)
            complaintLabel.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    
    @IBOutlet weak var complaintTypeRadioButton: RadioButtonView! {
        didSet {
            complaintTypeRadioButton.alignment = .vertical
            complaintTypeRadioButton.setRadioButtonItems(items: viewModel.complaintTypeItemModel)
            complaintTypeRadioButton.setRadioItemSelected(at: 0, isSelected: true)
            complaintTypeRadioButton.didUpdatedSelectedItem = { [weak self] item in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.viewModel.complaintType = ComplaintTypes(rawValue: item.key)
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

extension ComplaintTypeViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.complaintType
    }
}
