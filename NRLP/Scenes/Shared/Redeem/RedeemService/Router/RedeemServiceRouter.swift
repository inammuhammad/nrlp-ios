import UIKit
import Foundation

class RedeemServiceRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func gotoOTPScreen(transactionId: String, partner: Partner?, user: UserModel) {
        guard partner != nil else { return }
        self.navigationController?.pushViewController(RedeemOTPBuilder().build(with: self.navigationController, transactionId: transactionId, partner: partner!, user: user), animated: true)
    }
    
    func navigateToFBR(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .FBR), animated: true)
    }
    
    func navigateToPIA(partner: Partner, user: UserModel, category: Category) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .PIA, category: category), animated: true)
    }
    
    func navigateToNadra(partner: Partner, user: UserModel, category: Category) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .Nadra, category: category), animated: true)
    }
    
    func navigateToUSC(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .USC), animated: true)
    }
    
    func navigateToOPF(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionPSIDBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .OPF, category: nil), animated: true)
    }
    
    func navigateToSLIC(partner: Partner, user: UserModel, category: Category) {
        self.navigationController?.pushViewController(RedemptionPSIDBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .SLIC, category: category), animated: true)
    }
    
    func navigateToBEOE(partner: Partner, user: UserModel, category: Category) {
        self.navigationController?.pushViewController(RedemptionPSIDBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .BEOE, category: category), animated: true)
    }
    
    func navigateToOTPScreen(transactionID: String, partner: Partner, user: UserModel, inputModel: InitRedemptionTransactionModel, flowType: RedemptionFlowType) {
        let vc = RedemptionOTPBuilder().build(with: self.navigationController, transactionId: transactionID, partner: partner, user: user, inputModel: inputModel, flowType: flowType)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
