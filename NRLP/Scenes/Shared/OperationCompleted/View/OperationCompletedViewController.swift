//
//  OperationCompletedViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class OperationCompletedViewController: BaseViewController {

    var viewModel: OperationCompletedViewModelProtocol!
    @IBOutlet private weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.attributedText = viewModel.description
            subtitleLabel.textColor = .black
        }
    }
    @IBOutlet private weak var headerTitleLabel: UILabel! {
        didSet {
            headerTitleLabel.text = viewModel.title
            headerTitleLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .ultraLargeFontSize)
        }
    }
    @IBOutlet private weak var doneRegistrationButton: PrimaryCTAButton! {
        didSet {
            doneRegistrationButton.setTitle(viewModel.ctaButtonTitle, for: .normal)
        }
    }
    @IBOutlet private weak var illustrationImageView: UIImageView! {
        didSet {
            illustrationImageView.image = UIImage(named: viewModel.illustrationImageName)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension OperationCompletedViewController {
    @IBAction
    private func didTapDoneRegistrationButton(_ sender: Any) {
        viewModel.didTapCTAButton()
    }
}

extension OperationCompletedViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.operationCompleted
    }
}
