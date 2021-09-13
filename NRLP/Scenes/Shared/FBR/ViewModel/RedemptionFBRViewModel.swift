//
//  RedemptionFBRViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

typealias RedemptionFBRViewModelOutput = (RedemptionFBRViewModel.Output) -> Void

protocol RedemptionFBRViewModelProtocol {
    var output: RedemptionFBRViewModelOutput? { get set }
    
    func nextButtonPressed()
    func cancelButtonPressed()
    func viewDidLoad()
}

class RedemptionFBRViewModel: RedemptionFBRViewModelProtocol {
    
    private var router: RedemptionFBRRouter
    private var user: UserModel
    
    var output: RedemptionFBRViewModelOutput?
    
    init(router: RedemptionFBRRouter, user: UserModel) {
        self.router = router
        self.user = user
    }
    
    func nextButtonPressed() {
        router.navigateToPSIDScreen(user: self.user)
    }
    
    func cancelButtonPressed() {
        router.navigateBack()
    }
    
    func viewDidLoad() {
        output?(.updateLoyaltyPoints(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)")))
    }
    
    enum Output {
        case updateLoyaltyPoints(viewModel: LoyaltyCardViewModel)
    }
    
}
