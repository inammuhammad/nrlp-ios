//
//  FatherNameViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 05/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias FatherNameViewModelOutput = (FatherNameViewModel.Output) -> Void

protocol FatherNameViewModelProtocol {
    var output: FatherNameViewModelOutput? { get set }
    var fatherName: String? { get set }
    
    func nextTapped()
    func cancelTapped()
}

class FatherNameViewModel: FatherNameViewModelProtocol {
    var output: FatherNameViewModelOutput?
    
    var fatherName: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    private let userModel: UserModel
    private let router: FatherNameRouter
    private let fatherNameService: FatherNameServiceProtocol
    private let logoutService: LogoutServiceProtocol
    
    init(
        userModel: UserModel,
        router: FatherNameRouter,
        fatherNameService: FatherNameServiceProtocol = FatherNameService(),
        logoutService: LogoutServiceProtocol = LogoutService()
    ) {
        self.userModel = userModel
        self.fatherNameService = fatherNameService
        self.logoutService = logoutService
        self.router = router
    }
    
    func nextTapped() {
        guard validatedWithRegex() else { return }
        guard let fatherName = fatherName else { return }

        output?(.showActivityIndicator(show: true))
        fatherNameService.updateFatherName(
            model: FatherNameRequestModel(fatherName: fatherName)) { response in
                self.output?(.showActivityIndicator(show: false))
                switch response {
                case .success(_):
                    self.router.navigateToHomeScreen(userModel: self.userModel)
                case .failure(let error):
                    self.output?(.showError(error: error))
                }
            }
    }
    
    func cancelTapped() {
        let alertModel = AlertViewModel(
            alertHeadingImage: .comingSoon,
            alertTitle: "Logout".localized,
            alertDescription: "Without providing verification, you will not be able to login. Are you sure, you want to exit the Application?".localized,
            alertAttributedDescription: nil,
            primaryButton: AlertActionButtonModel(
                buttonTitle: "Yes".localized,
                buttonAction: {
                    self.output?(.showActivityIndicator(show: true))
                    self.logoutService.logoutUser { [weak self] (_) in
                        guard let self = self else { return }
                        self.output?(.showActivityIndicator(show: false))
                        self.router.navigateToLoginScreen()
                    }
                }
            ),
            secondaryButton: AlertActionButtonModel(
                buttonTitle: "No".localized,
                buttonAction: nil
            )
        )
        
        output?(.showAlert(alertModel: alertModel))
    }
    
    enum Output {
        case nextButtonState(enableState: Bool)
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case showAlert(alertModel: AlertViewModel)
    }
}

extension FatherNameViewModel {
    private func validateRequiredFields() {
        if fatherName?.isEmpty ?? true {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
        
//        guard let fatherName = fatherName else {
//            output?(.nextButtonState(enableState: false))
//            return
//        }
//
//        if fatherName.count < 3 || !(fatherName.isValid(for: RegexConstants.nameRegex)) {
//            output?(.nextButtonState(enableState: false))
//        } else {
//            output?(.nextButtonState(enableState: true))
//        }
    }
    
    private func validatedWithRegex() -> Bool {
        guard let fatherName = fatherName else { return false }
        
        var isValid = true
        
        if fatherName.count < 3 || !(fatherName.isValid(for: RegexConstants.nameRegex)) {
            isValid = false
        }
        
        return isValid
    }
}
