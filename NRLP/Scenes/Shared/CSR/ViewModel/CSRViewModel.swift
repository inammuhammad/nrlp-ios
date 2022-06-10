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
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case doneButtonState(state: Bool)
    }
    
    func doneButtonPressed() {
        guard let stars = stars, stars > 0 else {
            return
        }
        
        let responseHandler: (Result<CSRResponseModel, APIResponseError>) -> Void = { [weak self] result in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("response: \(response)")
                self?.router.navigateToHome()
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
        
        self.output?(.showActivityIndicator(show: true))
        
        if model.transactionType == .transferPoints || model.transactionType == .selfAward,
            let nicNicop = model.nicNicop,
            let transactionType = model.transactionType {
                
                let requestModel = CSRRequestModel(
                    nicNicop: nicNicop,
                    transactionId: "-",
                    transactionType: transactionType.rawValue,
                    comments: "\(stars)"
                )
                
                service.submitRating(requestModel: requestModel, responseHandler: responseHandler)
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
