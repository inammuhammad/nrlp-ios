import UIKit
import Foundation

class RedeemServiceBuilder {
    func build(with navigationController: UINavigationController?, partner: Partner, user: UserModel) -> UIViewController {

        let viewController = RedeemServiceViewController.getInstance()

        let coordinator = RedeemServiceRouter(navigationController: navigationController)
        let viewModel = RedeemServiceViewModel(router: coordinator, partner: partner, user: user, service: RedeemService())

        viewController.viewModel = viewModel

        return viewController
    }

}
