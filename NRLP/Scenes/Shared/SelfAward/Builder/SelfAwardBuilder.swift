//
//  SelfAwardBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 20/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class SelfAwardBuilder {
    func build(with navigationController: UINavigationController?, userModel: UserModel) -> UIViewController {

        let viewController = SelfAwardViewController.getInstance()
        viewController.user = userModel

        return viewController
    }
}
