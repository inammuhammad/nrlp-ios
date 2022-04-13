import UIKit
import Foundation

class RedeemRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToCategory(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedeemServiceBuilder().build(with: self.navigationController, partner: partner, user: user), animated: true)
    }
    
    func navigateToFBR(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .FBR), animated: true)
    }
    
    func navigateToPIA(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .PIA), animated: true)
    }
    
    func navigateToNadra(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .Nadra), animated: true)
    }
    
    func navigateToUSC(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .USC), animated: true)
    }
    
    func navigateToOPF(partner: Partner, user: UserModel) {
        self.navigationController?.pushViewController(RedemptionPSIDBuilder().build(with: self.navigationController, partner: partner, model: user, flowType: .OPF, category: nil), animated: true)
    }
}
