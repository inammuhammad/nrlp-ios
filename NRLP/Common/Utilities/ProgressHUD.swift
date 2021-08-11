//
//  ProgressHUD.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProgressHUD: NSObject {

    class func configureAppearance() {
        NRPLProgressHUD.set(foregroundColor: UIColor.init(commonColor: .appGreen))
    }

    class func show() {
        DispatchQueue.main.async {
            NRPLProgressHUD.set(defaultMaskType: .black)
            NRPLProgressHUD.show()
        }
    }

    class func show(message: String) {
        DispatchQueue.main.async {
            NRPLProgressHUD.set(defaultMaskType: .black)
            NRPLProgressHUD.show(withStatus: message)
        }
    }

    class func dismiss() {
        DispatchQueue.main.async {
            NRPLProgressHUD.dismiss()
        }
    }

}
