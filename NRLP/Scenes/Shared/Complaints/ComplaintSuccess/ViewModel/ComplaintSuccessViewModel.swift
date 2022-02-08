//
//  ComplaintSuccessViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ComplaintSuccessViewModelOutput = (ComplaintSuccessViewModel.Output) -> Void

protocol ComplaintSuccessViewModelProtocol {
    
    var output: ComplaintSuccessViewModelOutput? { get set }
    
    func viewDidLoad()
    func didTapDoneButton()
}

class ComplaintSuccessViewModel: ComplaintSuccessViewModelProtocol {
    
    var output: ComplaintSuccessViewModelOutput?
    
    private var router: ComplaintSuccessRouter
    
    private var complaintID: String
        
    init (complaintID: String, router: ComplaintSuccessRouter) {
        self.complaintID = complaintID
        self.router = router
    }
    
    enum Output {
        case setText(attributedText: NSAttributedString)
        case setNormalText(text: String)
        
    }
    
    func viewDidLoad() {
        let text = getAttributedText()
        output?(.setText(attributedText: text))
    }
    
    func didTapDoneButton() {
        router.navigateToHome()
    }
    
    private func getAttributedText() -> NSAttributedString {
        let finalString: NSMutableAttributedString = NSMutableAttributedString()
        
        let boldAttribute = [NSAttributedString.Key.font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .extraLargeFontSize)]
        let regularAttribute = [NSAttributedString.Key.font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraLargeFontSize)]
        
        let startText: NSAttributedString = NSAttributedString(string: "Dear Customer,\n\nYour complaint has been logged\nplease note the Tracking number".localized, attributes: regularAttribute)
        finalString.append(startText)
        let midText: NSAttributedString = NSAttributedString(string: " \(complaintID) ", attributes: boldAttribute)
        finalString.append(midText)
        let endText: NSAttributedString = NSAttributedString(string: "issue will be resolved within 3 working days, incase complaint remains unsolved, you may contact at\nsdrpsupport@1link.net.pk\n111-116-757".localized, attributes: regularAttribute)
        finalString.append(endText)
        return finalString
    }
}
