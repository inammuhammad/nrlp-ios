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
        guard let fatherName = fatherName, fatherName.count >= 3 else {
            return
        }

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
        output?(.showActivityIndicator(show: true))
        logoutService.logoutUser { [weak self] (_) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            self.router.navigateToLoginScreen()
        }
    }
    
    enum Output {
        case nextButtonState(enableState: Bool)
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
    }
}

extension FatherNameViewModel {
    private func validateRequiredFields() {
        guard let fatherName = fatherName else {
            output?(.nextButtonState(enableState: false))
            return
        }
        
        if fatherName.count < 3 || !(fatherName.isValid(for: RegexConstants.nameRegex)) {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
}
