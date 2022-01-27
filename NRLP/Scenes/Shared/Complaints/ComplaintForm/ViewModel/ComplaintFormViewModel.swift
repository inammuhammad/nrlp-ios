//
//  ComplaintFormViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias ComplaintFormViewModelOutput = (ComplaintFormViewModel.Output) -> Void

protocol ComplaintFormViewModelProtocol {
    
    var output: ComplaintFormViewModelOutput? { get set}
    
    var complaintTypeItemModel: [RadioButtonItemModel] { get }
    func viewDidLoad()
    func nextButtonPressed()
    
}

class ComplaintFormViewModel: ComplaintFormViewModelProtocol {
    
    private var router: ComplaintFormRouter
    var output: ComplaintFormViewModelOutput?
    private var userType: AccountType?
    private var loginState: UserLoginState
    private var complaintType: ComplaintTypes
    
    var complaintTypeItemModel: [RadioButtonItemModel] = []
    
    enum Output {
        case nextButtonState(state: Bool)
    }
    
    init(router: ComplaintFormRouter, type: AccountType, loginState: UserLoginState, complaintType: ComplaintTypes) {
        self.router = router
        self.userType = type
        self.loginState = loginState
        self.complaintType = complaintType
        setupComplaintType()
    }
    
    func viewDidLoad() {
        setupComplaintType()
        output?(.nextButtonState(state: true))
    }
    
    private func setupComplaintType() {
        complaintTypeItemModel = [RadioButtonItemModel(title: complaintType.getTitle(), key: complaintType.rawValue)]
    }
    
    func nextButtonPressed() {
        
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
