//
//  NadraVerificationViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias NadraVerificationViewModelOutput = (NadraVerificationViewModel.Output) -> Void

protocol NadraVerificationViewModelProtocol {
    var output: NadraVerificationViewModelOutput? { get set }
    
    func nextButtonPressed()
    func cancelButtonPressed()
}

class NadraVerificationViewModel: NadraVerificationViewModelProtocol {
    
    private var router: NadraVerificationRouter
    private var logoutService: LogoutServiceProtocol
    private var userModel: UserModel
    
    var output: NadraVerificationViewModelOutput?
    
    init(router: NadraVerificationRouter, logoutService: LogoutServiceProtocol = LogoutService(), userModel: UserModel) {
        self.router = router
        self.logoutService = logoutService
        self.userModel = userModel
    }
    
    func nextButtonPressed() {
        router.navigateToNadraVerificatonForm(userModel: self.userModel)
    }
    
    func cancelButtonPressed() {
        let alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "", alertDescription: "Without providing verification, you will not be able to login\nAre you sure, you want to exit the Application?".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Yes".localized, buttonAction: {
            self.logoutUser()
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "No".localized))
        output?(.showAlert(alertModel: alert))
    }
    
    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case showAlert(alertModel: AlertViewModel)
    }
    
    private func logoutUser() {
        output?(.showActivityIndicator(show: true))
        logoutService.logoutUser { [weak self] (_) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            self.router.navigateToLoginScreen()
        }
    }
    
}
