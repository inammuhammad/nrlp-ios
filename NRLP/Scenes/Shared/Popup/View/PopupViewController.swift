//
//  PopupViewController.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 04/07/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class PopupViewController: BaseViewController {
    var viewModel: PopupViewModelProtocol!
    
    @IBOutlet private weak var messageLabel: UILabel! {
        didSet {
            messageLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    
    @IBOutlet private weak var okayBtn: PrimaryCTAButton! {
        didSet {
            okayBtn.setTitle("Okay".localized, for: .normal)
            okayBtn.setTitle("Okay".localized, for: .selected)
            okayBtn.setTitle("Okay".localized, for: .disabled)
            okayBtn.setTitle("Okay".localized, for: .highlighted)
            okayBtn.addTarget(self, action: #selector(okayBtnAction), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelOutput()
        viewModel.viewDidLoad()
    }
    
    @objc
    private func okayBtnAction() {
        viewModel.didTapOkayButton()
    }
}

// MARK: BindViewModel and View binding
extension PopupViewController {
    private func bindViewModelOutput() {
        viewModel.output = {  [unowned self] output in
            switch output {
            case .update(let message):
                self.messageLabel.text = message
            }
        }
    }
}

extension PopupViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        .popup
    }
}
