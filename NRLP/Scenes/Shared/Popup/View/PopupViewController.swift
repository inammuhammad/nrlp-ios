//
//  PopupViewController.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 04/07/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class PopupViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PopupViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        .popup
    }
}
