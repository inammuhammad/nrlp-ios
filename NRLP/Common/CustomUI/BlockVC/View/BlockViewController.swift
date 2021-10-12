//
//  BlockViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 12/10/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class BlockViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBlockScreen()
    }
    
    private func setupBlockScreen() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }

}

extension BlockViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.block
    }
    
}
