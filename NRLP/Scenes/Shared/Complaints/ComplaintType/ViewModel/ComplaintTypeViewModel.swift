//
//  ComplaintTypeViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ComplaintTypeViewModelOutput = (ComplaintTypeViewModel.Output) -> Void

protocol ComplaintTypeViewModelProtocol {
    
    var output: ComplaintTypeViewModelOutput? { get set}
    
    var complaintType: ComplaintTypes? {get set}
    
    var complaintTypeItemModel: [RadioButtonItemModel] { get }
    func viewDidLoad()
    func nextButtonPressed()
    
}

class ComplaintTypeViewModel: ComplaintTypeViewModelProtocol {
    
    private var router: ComplaintTypeRouter
    var output: ComplaintTypeViewModelOutput?
    private var userType: AccountType?
    private var loginState: UserLoginState
    private var currentUser: UserModel?
    
    var complaintType: ComplaintTypes? {
        didSet {
            checkNextButtonState()
        }
    }
    
    var complaintTypeItemModel: [RadioButtonItemModel] = []
    
    enum Output {
        case nextButtonState(state: Bool)
    }
    
    init(router: ComplaintTypeRouter, type: AccountType, loginState: UserLoginState, currentUser: UserModel?) {
        self.router = router
        self.userType = type
        self.loginState = loginState
        self.currentUser = currentUser
        setupComplaintType()
    }
    
    func viewDidLoad() {
        setupComplaintType()
        output?(.nextButtonState(state: true))
    }
    
    private func setupComplaintType() {
        switch loginState {
        case .loggedIn:
            if userType == .remitter {
                addRegisteredRemitterData()
            } else if userType == .beneficiary {
                addRegisteredBeneficiaryData()
            }
        case .loggedOut:
            if userType == .remitter {
                addNotRegisteredRemitterData()
            } else if userType == .beneficiary {
                addNotRegisteredBeneficiaryData()
            }
        }
        
        complaintType = ComplaintTypes(rawValue: complaintTypeItemModel.first?.key ?? "")
    }
    
    private func addNotRegisteredRemitterData() {
        complaintTypeItemModel = [
            RadioButtonItemModel(title: ComplaintTypes.unableToRegister.getTitle(), key: ComplaintTypes.unableToRegister.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.unableToReceiveOTP.getTitle(), key: ComplaintTypes.unableToReceiveOTP.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.others.getTitle(), key: ComplaintTypes.others.rawValue)
        ]
    }
    
    private func addRegisteredRemitterData() {
        complaintTypeItemModel = [
            RadioButtonItemModel(title: ComplaintTypes.unableToReceiveOTP.getTitle(), key: ComplaintTypes.unableToReceiveOTP.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.unableToAddBeneficiary.getTitle(), key: ComplaintTypes.unableToAddBeneficiary.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.unableToTransferPointsToBeneficiary.getTitle(), key: ComplaintTypes.unableToTransferPointsToBeneficiary.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.unableToSelfAwardPoints.getTitle(), key: ComplaintTypes.unableToSelfAwardPoints.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.redemptionIssues.getTitle(), key: ComplaintTypes.redemptionIssues.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.others.getTitle(), key: ComplaintTypes.others.rawValue)
        ]
    }
    
    private func addNotRegisteredBeneficiaryData() {
        complaintTypeItemModel = [
            RadioButtonItemModel(title: ComplaintTypes.unableToRegister.getTitle(), key: ComplaintTypes.unableToRegister.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.unableToReceiveRegistrationCode.getTitle(), key: ComplaintTypes.unableToReceiveRegistrationCode.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.others.getTitle(), key: ComplaintTypes.others.rawValue)
        ]
    }
    
    private func addRegisteredBeneficiaryData() {
        complaintTypeItemModel = [
            RadioButtonItemModel(title: ComplaintTypes.unableToReceiveOTP.getTitle(), key: ComplaintTypes.unableToReceiveOTP.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.redemptionIssues.getTitle(), key: ComplaintTypes.redemptionIssues.rawValue),
            RadioButtonItemModel(title: ComplaintTypes.others.getTitle(), key: ComplaintTypes.others.rawValue)
        ]
    }
    
    private func checkNextButtonState() {
        if complaintType == nil {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }
    
    func nextButtonPressed() {
        if let user = userType, let complaint = complaintType {
            router.navigateToComplaintFormScreen(accountType: user, loginState: loginState, complaintType: complaint, currentUser: currentUser)
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

enum UserLoginState {
    case loggedIn
    case loggedOut
}
