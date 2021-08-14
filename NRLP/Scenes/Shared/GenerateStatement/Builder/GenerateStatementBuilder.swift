import UIKit
import Foundation

class GenerateStatementBuilder {
    
    func build(with navigationController: UINavigationController, userModel: UserModel) -> UIViewController {
        
        let viewController = GenerateStatementViewController.getInstance()
        let coordinator = GenerateStatementRouter(navigationController: navigationController)
        let viewModel = GenerateStatementViewModel(userModel: userModel, router: coordinator, service: LoyaltyPointsService())
        
        viewController.viewModel = viewModel

        return viewController
    }
}
