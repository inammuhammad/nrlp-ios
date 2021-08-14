//
//  UIKit+UIWindow.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    static func getVisibleViewControllerFrom(_ vController: UIViewController?) -> UIViewController? {
        var finalVController: UIViewController?
        if let navController = vController as? UINavigationController {
            finalVController = UIWindow.getVisibleViewControllerFrom(navController.visibleViewController)
        } else if let tabbarController = vController as? UITabBarController {
            finalVController = UIWindow.getVisibleViewControllerFrom(tabbarController.selectedViewController)
        } else {
            if let presentedVController = vController?.presentedViewController {
                finalVController = UIWindow.getVisibleViewControllerFrom(presentedVController)
            } else {
                finalVController = vController
            }
        }
        while let topVController = finalVController?.presentedViewController {
            finalVController = topVController
        }
        return finalVController
    }
}
