//
//  RedemptionViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//

import Foundation

typealias RedemptionRatingViewModelOutput = (RedemptionRatingViewModel.Output) -> Void

protocol RedemptionRatingViewModelProtocol {
    
//    var ratingType: RedemptionRatingTypes? {get set}

    var stars: Int? { get set }
    var output: RedemptionRatingViewModelOutput? { get set}
//    var ratingTypeItemModel: [RadioButtonItemModel] { get }
    func viewDidLoad()
    func submitRating()
    // func doneButtonPressed()
}

class RedemptionRatingViewModel: RedemptionRatingViewModelProtocol {

    private var router: RedemptionRatingRouter
    private var service: RedeemService
    var output: RedemptionRatingViewModelOutput?
    
//    var ratingTypeItemModel: [RadioButtonItemModel] = []
    
//    var ratingType: RedemptionRatingTypes? {
//        didSet {
//            checkDoneButtonState()
//        }
//    }
    
    var stars: Int? {
        didSet {
            submitRating()
            // checkDoneButtonState()
        }
    }
    
    private var transactionId: String
    
    func viewDidLoad() {
        stars = 0
        checkDoneButtonState()
    }
    
//    private func setupRatingType() {
//        ratingTypeItemModel = [
//            RadioButtonItemModel(title: RedemptionRatingTypes.good.getTitle(), key: RedemptionRatingTypes.good.rawValue),
//            RadioButtonItemModel(title: RedemptionRatingTypes.satisfactory.getTitle(), key: RedemptionRatingTypes.satisfactory.rawValue),
//            RadioButtonItemModel(title: RedemptionRatingTypes.unsatisfactory.getTitle(), key: RedemptionRatingTypes.unsatisfactory.rawValue)
//        ]
//
//        ratingType = RedemptionRatingTypes(rawValue: ratingTypeItemModel.first?.key ?? "")
//    }

    init(router: RedemptionRatingRouter, transactionId: String, service: RedeemService) {
        self.router = router
        self.transactionId = transactionId
        self.service = service
        
//        setupRatingType()
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case doneButtonState(state: Bool)
    }
    
    func submitRating() { // doneButtonPressed() {
//        guard let ratingType = ratingType else {
//            return
//        }
        
        guard let stars = stars, stars > 0 else {
            return
        }

        self.output?(.showActivityIndicator(show: true))
        let comments = "\(stars)" // ratingType.rawValue

        service.submitRedemptionRating(requestModel: RedemptionRatingModel(transactionId: transactionId, comments: comments)) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("response: \(response)")
                // self?.goToSuccess()
                self?.router.navigateToHome()
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
        
        // self.router.navigateToHome()
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
