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
//        let text = getAttributedText()
//        output?(.setText(attributedText: text))
        let text = "Dear Customer,\n\nYour complaint has been logged\nplease note the Tracking number\n\(complaintID)\n\nissue will be resolved within 3\nworking days, incase complaint\nremains unsolved, you may\ncontact at\nsdrpsupport@1link.net.pk\n111-116-757".localized
        output?(.setNormalText(text: text))
        
    }
    
    func didTapDoneButton() {
        router.navigateToHome()
    }
    
    private func getAttributedText() -> NSAttributedString {
        let finalString: NSMutableAttributedString = NSMutableAttributedString()
        
        let boldAttribute = [NSAttributedString.Key.font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .extraLargeFontSize)]
        let regularAttribute = [NSAttributedString.Key.font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraLargeFontSize)]
        
//        let startText: NSAttributedString = NSAttributedString(string: "Dear Customer,\n\nYour complaint has been logged\nplease note the Tracking number\n", attributes: regularAttribute)
//        finalString.append(startText)
//        let midText: NSAttributedString = NSAttributedString(string: "\(complaintID)\n\n", attributes: boldAttribute)
//        finalString.append(midText)
//        let endText: NSAttributedString = NSAttributedString(string: "issue will be resolved within 3\nworking days, incase complaint\nremains unsolved, you may\ncontact at\nsdrpsupport@1link.net.pk\n111-116-757", attributes: regularAttribute)
//        finalString.append(endText)
        finalString.append(NSAttributedString(string: "Dear Customer,\n\nYour complaint has been logged\nplease note the Tracking number\n\(complaintID)\n\nissue will be resolved within 3\nworking days, incase complaint\nremains unsolved, you may\ncontact at\nsdrpsupport@1link.net.pk\n111-116-757".localized))
        return finalString
    }
}
