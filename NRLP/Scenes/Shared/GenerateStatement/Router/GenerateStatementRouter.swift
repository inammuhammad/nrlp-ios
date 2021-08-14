import UIKit
import Foundation

class GenerateStatementRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSuccessScreen() {
        let vc = LoyaltyStatementSuccessBuilder().build(with: navigationController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
