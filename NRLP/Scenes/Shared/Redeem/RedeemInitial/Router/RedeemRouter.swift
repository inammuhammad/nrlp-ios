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
    
    func navigateToFBR(user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, model: user, flowType: .FBR), animated: true)
    }
    
    func navigateToPIA(user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, model: user, flowType: .PIA), animated: true)
    }
    
    func navigateToNadra(user: UserModel) {
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, model: user, flowType: .Nadra), animated: true)
    }
}
