//
//  ComplaintSuccessViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ComplaintSuccessViewController: BaseViewController {
    
    var viewModel: ComplaintSuccessViewModelProtocol!

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
            complaintLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraLargeFontSize)
            complaintLabel.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    
    @IBOutlet private weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var nextButton: PrimaryCTAButton! {
        didSet {
            nextButton.setTitle("Done".localized, for: .normal)
            nextButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        bindViewModelOutput()
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.didTapDoneButton()
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [weak self] output in
            guard let self = self else {return}
            switch output {
            case .setText(attributedText: let attrString):
                self.subtitleLabel.attributedText = attrString
            case .setNormalText(text: let text):
                self.subtitleLabel.text = text
            }
        }
    }

}

extension ComplaintSuccessViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        UIStoryboard.Name.complaintSuccess
    }
}
