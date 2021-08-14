import Foundation
import UIKit

class RedeemConfirmBuilder {

    func build(with navigationController: UINavigationController?, transactionId: String, partner: Partner) -> UIViewController {

        let viewController = RedeemConfirmViewController.getInstance()

        let coordinator = RedeemConfirmRouter(navigationController: navigationController)
        let viewModel = RedeemConfirmViewModel(with: coordinator,
                                               transactionId: transactionId,
                                               partner: partner,
                                               service: RedeemService())
        viewController.viewModel = viewModel

        return viewController
    }
}
