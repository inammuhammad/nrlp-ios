import Foundation
import UIKit

class RedeemOTPRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func goToAgentScreen(transactionId: String, partner: Partner) {
        self.navigationController?.pushViewController(RedeemConfirmBuilder().build(with: navigationController, transactionId: transactionId, partner: partner), animated: true)
    }
}
