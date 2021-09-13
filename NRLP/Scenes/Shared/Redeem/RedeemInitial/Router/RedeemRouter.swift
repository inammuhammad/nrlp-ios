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
        self.navigationController?.pushViewController(RedemptionFBRBuilder().build(with: self.navigationController, model: user), animated: true)
    }
}
