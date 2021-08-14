//
//  NavigationViewControllerExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 30/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        let reveredViewControllers = self.viewControllers.reversed()
        for currentViewController in reveredViewControllers {
            if currentViewController .isKind(of: toControllerType) {
                self.popToViewController(currentViewController, animated: true)
                break
            }
        }
    }
}
