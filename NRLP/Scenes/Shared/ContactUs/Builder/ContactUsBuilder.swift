import UIKit
import Foundation

class ContactUsBuilder {
    func build() -> UIViewController {

        let viewController = ContactUsViewController.getInstance()
        let viewModel = ContactUsViewModel()

        viewController.viewModel = viewModel

        return viewController
    }

}
