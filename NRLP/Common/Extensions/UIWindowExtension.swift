//
//  UIWindowExtension.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {

    func switchRoot(withRootController newRootVC: UIViewController,
                    isAnimated animation: Bool = true,
                    completion:(()->Void)?=nil ) {

        if animation {

            UIView.transition(with: self,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {[unowned self] in

                                let oldState = UIView.areAnimationsEnabled
                                UIView.setAnimationsEnabled(false)
                                self.rootViewController = newRootVC
                                UIView.setAnimationsEnabled(oldState)

            }, completion: { _ in

                completion?()
            })

        } else {

            rootViewController = newRootVC
        }
    }

}
