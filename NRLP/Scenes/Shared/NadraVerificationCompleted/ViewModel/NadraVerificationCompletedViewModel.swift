//
//  NadraVerificationCompletedViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 04/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

class NadraVerificationCompletedViewModel: OperationCompletedViewModelProtocol {
    
    private var userModel: UserModel
    private var router: NadraVerificationCompletedRouter
    private var operationCompletedType: OperationCompletedType!

    lazy var description = operationCompletedType.getDescription()
    lazy var title: String =  operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    init(with router: NadraVerificationCompletedRouter, userModel: UserModel) {
        self.userModel = userModel
        self.router = router
        self.operationCompletedType = .nadraVerification
    }

    func didTapCTAButton() {
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        let userProfileService = UserProfileService()
        userProfileService.getUserProfile { [weak self] (response) in
            switch response {
            case .success(let response):
                if let data = response.data {
                    self?.userModel.update(from: data)
                    self?.router.navigateToHomeScreen(user: self?.userModel ?? UserModel())
                }
            case .failure(let error):
                print("Request Fail With Error: \(error)")
//                self?.output?(.showError(error: error))
            }
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
