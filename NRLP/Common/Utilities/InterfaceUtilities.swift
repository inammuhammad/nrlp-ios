//
//  InterfaceUtilities.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class InterfaceUtilities: NSObject {

    class func getTopViewController () -> UIViewController {
        if let viewController = UIApplication.shared.keyWindow?.visibleViewController {
            return viewController
        }
        return UIViewController()
    }
}
