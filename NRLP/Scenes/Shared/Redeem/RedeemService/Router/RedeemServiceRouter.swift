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
}
