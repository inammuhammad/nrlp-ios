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
    private var flowType: RedemptionFlowType
    private var partner: Partner
    private var category: Category
    
    var output: RedemptionFBRViewModelOutput?
    
    init(router: RedemptionFBRRouter, partner: Partner, user: UserModel, flowType: RedemptionFlowType, category: Category) {
        self.router = router
        self.user = user
        self.flowType = flowType
        self.partner = partner
        self.category = category
    }
    
    func nextButtonPressed() {
        if flowType == .Nadra {
            router.navigateToTrackingIDScreen(userModel: self.user, flowType: flowType, category: category, partner: partner)
        } else {
            if flowType == .USC || flowType == .PIA {
                router.navigateToPSIDScreen(partner: partner, user: self.user, flowType: flowType, category: nil)
            } else {
                router.navigateToPSIDScreen(partner: partner, user: self.user, flowType: flowType, category: category)
            }
        }
    }
    
    func cancelButtonPressed() {
        router.navigateBack()
    }
    
    func viewDidLoad() {
        output?(.updateLoyaltyPoints(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)", user: self.user)))
        setTitle(type: flowType)
        setDescription(type: flowType)
    }
    
    enum Output {
        case updateLoyaltyPoints(viewModel: LoyaltyCardViewModel)
        case setTitle(text: String)
        case setDescription(text: String)
    }
    
    func setTitle(type: RedemptionFlowType) {
        var title = ""
        switch type {
        case .FBR:
            title = "Federal Board of Revenue".localized
        case .PIA:
            title = "PIA".localized
        case .Nadra:
            title = "NADRA".localized
        case .USC:
            title = "Utility Stores".localized
        case .OPF:
            title = "".localized
        default:
            ()
        }
        output?(.setTitle(text: title))
    }
    
    func setDescription(type: RedemptionFlowType) {
        var desc = ""
        switch type {
        case .FBR:
            desc = "To redeem your points for NRLP Benefits offered by FBR, please visit www.fbr.gov.pk to generate Payment Slip ID (PSID) for your selected service.\n\nIf you already have a PSID,please continue.".localized
        case .PIA:
            desc = "To redeem your points for NRLP Benefits offered by PIA, please visit www.piac.com.pk to generate Payment Slip ID (PSID) for your selected service.\n\nIf you already have a PSID please continue.".localized
        case .Nadra:
            desc = "To redeem your points for SDRP Benefits offered by NADRA, please visit www.nadra.gov.pk to generate Tracking Number for your selected service.\n\nIf you already have a Tracking Number please continue.".localized
        case .USC:
            desc = "To redeem your points for NRLP Benefits at Utility Stores, please visit Utility Store outlet to get Payment Slip ID (PSID) for your purchases.\n\nIf you already have a PSID please continue.".localized
        case .OPF:
            desc = "".localized
        default:
            ()
        }
        output?(.setDescription(text: desc))
    }
}

enum RedemptionFlowType {
    case FBR
    case PIA
    case Nadra
    case USC
    case OPF
    case DGIP
    case SLIC
    case BEOE
}
