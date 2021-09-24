//
//  RedemptionOTPRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 24/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedemptionOTPRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSuccessScreen(psid: String, amount: String, flowType: RedemptionFlowType, inputModel: InitRedemptionTransactionModel, transactionID: String) {
        print("NAVIGATE TO PSID")
//        self.navigationController?.pushViewController(, animated: true)
        if let nav = self.navigationController {
            let vc = OperationCompletedViewController.getInstance()
            var points = ""
            if flowType == .FBR {
                points = amount
            } else {
                points = inputModel.point ?? ""
            }
            let message = getSuccessMessage(psid: psid, points: points, flowType: flowType, inputModel: inputModel, transactionID: transactionID)
            vc.viewModel = RedemptionPSIDSuccessViewModel(with: nav, message: message)
            nav.pushViewController(vc, animated: true)
            
        }
    }
    
    private func getSuccessMessage(psid: String, points: String, flowType: RedemptionFlowType, inputModel: InitRedemptionTransactionModel, transactionID: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strTodayDate = formatter.string(from: Date()) // string purpose I add here
        let todayDate = formatter.date(from: strTodayDate)
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let finalStrDate = formatter.string(from: todayDate ?? Date())
        switch flowType {
        case .FBR:
            return "Receipt No. \(transactionID)\n\nYou have redeemed \(points) Points against\nPSID \(psid) successfully at FBR\n\n\(finalStrDate)".localized
        case .PIA:
            return "Receipt No. \(transactionID)\n\nYou have redeemed \(points) Points against\nPSID \(psid) successfully at PIA\n\n\(finalStrDate)".localized
        case .Nadra:
            return "Receipt No. \(transactionID)\n\nYou have redeemed \(points) Points against Tracking\nID \(psid) successfully at NADRA.\n\n\(finalStrDate)".localized
        case .USC:
            return "You have redeemed \(points) Points against\nPSID \(psid) successfully at Utility Stores".localized
        case .OPF:
            return "Your amount against Voucher No.\n\(psid) for \(points) Points is redeemed successfully at OPF".localized
        case .DGIP:
            formatter.dateFormat = "dd MMM yyyy"
            let date = formatter.date(from: finalStrDate) ?? Date()
            let dateStr = formatter.string(from: date)
            return "Receipt No. \(transactionID)\nYou have redeemed \(points) Points at Passport\n\(dateStr)".localized
        }
    }
}
