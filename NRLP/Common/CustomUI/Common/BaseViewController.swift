//
//  BaseViewController.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTappingOutsideArea()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBackButton()
    }
    
    func setupNavigationBackButton() {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            setNavBackBarButton()
        }
    }

    func setNavBackBarButton() {
        var backButtonImage = #imageLiteral(resourceName: "backArrow")
        if (AppConstants.appLanguage == .urdu && !AppConstants.isSystemLanguageUrdu()) || AppConstants.appLanguage == .english && AppConstants.isSystemLanguageUrdu() {
            backButtonImage = backButtonImage.rotate(radians: .pi)
        }
        
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(back(sender:)))
        backButton.tintColor = UIColor.init(commonColor: .appGreen)
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        navigationItem.leftItemsSupplementBackButton = true
    }

    func showAlert(with alertViewModel: AlertViewModel) {
        DispatchQueue.main.async {
            AlertViewController.presentAlert(with: alertViewModel, from: self)
        }
    }

    func showAlert(with error: APIResponseError) {
        if case APIResponseError.sessionExpire = error {
            DispatchQueue.main.async {
                let alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: error.title, alertDescription: error.message, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: {
                    UIApplication.shared.keyWindow?.switchRoot(withRootController: LoginModuleBuilder().build())
                }))
                AlertViewController.presentAlert(with: alert, from: self)
            }
        } else {
            DispatchQueue.main.async {
                AlertViewController.presentAlert(with: error, from: self)
            }
        }
    }

    @objc
    func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }

}
