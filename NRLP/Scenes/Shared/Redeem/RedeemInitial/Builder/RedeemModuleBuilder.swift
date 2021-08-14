import UIKit
import Foundation

class RedeemModuleBuilder {
    func build(with navigationController: UINavigationController?, user: UserModel) -> UIViewController {

        let viewController = RedeemViewController.getInstance()

        let coordinator = RedeemRouter(navigationController: navigationController)
        let viewModel = RedeemViewModel(router: coordinator, user: user, service: RedeemService())

        viewController.viewModel = viewModel

        return viewController
    }

}
