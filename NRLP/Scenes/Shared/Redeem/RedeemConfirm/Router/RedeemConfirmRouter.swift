import Foundation
import UIKit

class RedeemConfirmRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func goToFinishScreen(transactionId: String, partner: Partner) {
        let finishScreen = RedeemSuccessBuilder().build(with: navigationController, transactionId: transactionId, partner: partner)
        self.navigationController?.pushViewController(finishScreen, animated: true)
    }
}
