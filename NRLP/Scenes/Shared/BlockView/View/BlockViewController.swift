//
//  BlockViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/08/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class BlockViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        checkInterfaceMode()
    }
    
    
    private func checkInterfaceMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                // light mode detected
                self.view.backgroundColor = UIColor.white
            case .dark:
            // dark mode detected
                self.view.backgroundColor = UIColor.black
            @unknown default:
                self.view.backgroundColor = UIColor.white
            }
        } else {
            // Fallback on earlier versions
            self.view.backgroundColor = UIColor.white
        }
    }
    
}
