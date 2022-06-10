//
//  CSRViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 09/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias CSRViewModelOutput = (CSRViewModel.Output) -> Void

protocol CSRViewModelProtocol {
    
    var stars: Int? { get set }
    var output: CSRViewModelOutput? { get set}
    func viewDidLoad()
    func doneButtonPressed()
}

class CSRViewModel: CSRViewModelProtocol {
    
    private var router: CSRRouter
    private var service: CSRService
    var output: CSRViewModelOutput?
    
    var stars: Int? {
        didSet {
            // submitRating()
            checkDoneButtonState()
        }
    }
    
    var model: CSRModel
    
    func viewDidLoad() {
        stars = 0
        checkDoneButtonState()
        
        if model.transactionType == .registration {
            self.output?(.updateTitleText(text: "How would you rate registration process"))
        } else if model.transactionType == .selfAward {
            self.output?(.updateTitleText(text: "How would you rate self-awarding process"))
        } else if model.transactionType == .transferPoints {
            self.output?(.updateTitleText(text: "How would you rate transfer point process"))
        }
    }
    
    init(
        router: CSRRouter,
        model: CSRModel
    ) {
        self.router = router
        self.service = CSRService()
        self.model = model
    }
    
    enum Output {
        case updateTitleText(text: String)
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case doneButtonState(state: Bool)
    }
    
    func doneButtonPressed() {
        guard let stars = stars, stars > 0 else {
            return
        }
        
        self.output?(.showActivityIndicator(show: true))
        
        if model.transactionType == .transferPoints ||
            model.transactionType == .selfAward,
           let nicNicop = model.nicNicop,
           let transactionType = model.transactionType {
            
            let requestModel = CSRRequestModel(
                nicNicop: nicNicop,
                transactionId: "-",
                transactionType: transactionType.rawValue,
                comments: "\(stars)"
            )
            
            service.submitRating(requestModel: requestModel) { [weak self] result in
                self?.output?(.showActivityIndicator(show: false))
                switch result {
                case .success:
                    self?.router.navigateToHome()
                case .failure(let error):
                    self?.output?(.showError(error: error))
                }
            }
            
        } else if model.transactionType == .registration,
                  let nicNicop = model.nicNicop,
                  let transactionType = model.transactionType,
                  let userType = model.userType {
            
            let requestModel = RegistrationCSRRequestModel(
                nicNicop: nicNicop,
                userType: userType,
                transactionType: transactionType.rawValue,
                comments: "\(stars)"
            )
            
            service.submitRegistrationRating(requestModel: requestModel) { [weak self] result in
                self?.output?(.showActivityIndicator(show: false))
                switch result {
                case .success:
                    self?.router.navigateToLoginScreen()
                case .failure(let error):
                    self?.output?(.showError(error: error))
                }
            }
        }
    }
    
    private func checkDoneButtonState() {
        if let stars = stars, stars > 0 {
            output?(.doneButtonState(state: true))
        } else {
            output?(.doneButtonState(state: false))
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
