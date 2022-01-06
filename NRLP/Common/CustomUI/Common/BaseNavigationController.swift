//
//  BaseNavigationController.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    func configureUI() {
        setupNavigationBarStyle()
        setNavTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewBasedOnLanguage()
    }

    func setupNavigationBarStyle() {
        self.navigationBar.barTintColor = .white
        self.navigationBar.isTranslucent = true
    }

    func hideShadow() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }

    func showShadow() {

        self.navigationBar.shadowImage = UIColor.init(commonColor: .appLightGray).image()
    }

    func setNavTitle() {

        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)]
    }
    
    private func setupViewBasedOnLanguage() {
        if AppConstants.appLanguage == .urdu || (AppConstants.appLanguage == nil && AppConstants.systemLanguage == .urdu) {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
