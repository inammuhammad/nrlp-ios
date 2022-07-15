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
    
    @IBOutlet private weak var alertContainerView: UIView! {
        didSet {
            alertContainerView.cornerRadius = CommonDimens.unit1x.rawValue
        }
    }
    
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            messageTextView.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
            messageTextView.text = message
        }
    }
    
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var okayBtn: PrimaryCTAButton! {
        didSet {
            okayBtn.setTitle("Okay".localized, for: .normal)
            okayBtn.setTitle("Okay".localized, for: .selected)
            okayBtn.setTitle("Okay".localized, for: .disabled)
            okayBtn.setTitle("Okay".localized, for: .highlighted)
            okayBtn.addTarget(self, action: #selector(okayBtnAction), for: .touchUpInside)
        }
    }
    
    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // bindViewModelOutput()
        // viewModel.viewDidLoad()
        alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        self.view.backgroundColor = UIColor.init(commonColor: .appBackgroundDarkOverlay)
        
        let contentHeight = messageTextView.contentSize.height
        messageHeight.constant = contentHeight > view.bounds.height * 0.2 ? view.bounds.height * 0.2 : contentHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.3, animations: {
            self.alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            }
        })
    }
    
    @objc
    private func okayBtnAction() {
        dismiss {
            self.onDismiss?()
        }
        // viewModel.didTapOkayButton()
    }
    
    private var onDismiss: (() -> Void)?
}

// MARK: BindViewModel and View binding
extension PopupViewController {
    private func bindViewModelOutput() {
        viewModel.output = {  [unowned self] output in
            switch output {
            case .update(let message):
                self.messageTextView.text = message
            }
        }
    }
}

extension PopupViewController {
    private static func presentPopup(on controller: UIViewController) -> PopupViewController {
        let alertVC = PopupViewController.getInstance()

        alertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        DispatchQueue.main.async {
            controller.present(alertVC, animated: true, completion: nil)
        }
        return alertVC
    }

    private func dismiss(with completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertContainerView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.alertContainerView.alpha = 0
        }, completion: { (_) in
            self.dismiss(animated: true, completion: {
                completion()
            })
        })
    }

    static func presentPopup(with message: String, from controller: UIViewController, onDismiss: @escaping () -> Void) {
        let popupVC = presentPopup(on: controller)
        popupVC.message = message
        popupVC.onDismiss = onDismiss
    }
}

extension PopupViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        .popup
    }
}
