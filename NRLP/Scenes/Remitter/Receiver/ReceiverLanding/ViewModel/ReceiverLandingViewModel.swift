//
//  ReceiverLandingViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ReceiverLandingViewModelOutput = (ReceiverLandingViewModel.Output) -> Void

protocol ReceiverLandingViewModelProtocol {
    var output: ReceiverLandingViewModelOutput? { get set}
    
    func viewDidLoad()
    func skipButtonPressed()
    func nextButtonPressed()
}

class ReceiverLandingViewModel: ReceiverLandingViewModelProtocol {
    
    var output: ReceiverLandingViewModelOutput?
    private var router: ReceiverLandingRouter
    
    init(router: ReceiverLandingRouter) {
        self.router = router
    }

    enum Output {
        case showError(error: APIResponseError)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case setDescription(text: String)
        case setAttributedDescription(text: NSAttributedString)
    }
    
    func viewDidLoad() {
        let attrText = getAttributedString()
        output?(.setAttributedDescription(text: attrText))
    }
    
    func skipButtonPressed() {
        router.popToPreviousScreen()
    }
    
    func nextButtonPressed() {
        router.navigateToReceiverTypeScreen()
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
    private func getAttributedString() -> NSAttributedString {
        let finalString: NSMutableAttributedString = NSMutableAttributedString()
        
//        let underLineAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineColor: UIColor.init(commonColor: CommonColor.appGreen), NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.italic, size: .extraLargeFontSize), NSAttributedString.Key.foregroundColor: UIColor.init(commonColor: CommonColor.appGreen)]
        let regularAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.italic, size: .extraLargeFontSize), NSAttributedString.Key.foregroundColor: UIColor.init(commonColor: CommonColor.appGreen)]
        
        let startText: NSAttributedString = NSAttributedString(string: "Click Next to add your Remittance Receiver & get auto points into your account".localized, attributes: regularAttribute)
        finalString.append(startText)
//        let midText: NSAttributedString = NSAttributedString(string: "Next", attributes: underLineAttribute)
//        finalString.append(midText)
//        let endText: NSAttributedString = NSAttributedString(string: " to add\nyour Remittance\nand get\nauto points into\nyour account".localized, attributes: regularAttribute)
//        finalString.append(endText)
        return finalString
    }
}
