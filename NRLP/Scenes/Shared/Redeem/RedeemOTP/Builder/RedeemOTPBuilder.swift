import Foundation
import UIKit

class RedeemOTPBuilder {

    func build(with navigationController: UINavigationController?, transactionId: String, partner: Partner, user: UserModel) -> UIViewController {

        let viewController = RedeemOTPViewController.getInstance()

        let coordinator = RedeemOTPRouter(navigationController: navigationController)
        let viewModel = RedeemOTPViewModel(with: coordinator,
                                           transactionId: transactionId,
                                           partner: partner,
                                           service: RedeemService(),
                                           user: user)

        viewController.viewModel = viewModel

        return viewController
    }
}
