//
//  RedemptionViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//

import Foundation

typealias RedemptionRatingViewModelOutput = (RedemptionRatingViewModel.Output) -> Void

protocol RedemptionRatingViewModelProtocol {
    
    var ratingType: RedemptionRatingTypes? {get set}

    var output: RedemptionRatingViewModelOutput? { get set}
    var ratingTypeItemModel: [RadioButtonItemModel] { get }
    func viewDidLoad()
    func doneButtonPressed()
}

class RedemptionRatingViewModel: RedemptionRatingViewModelProtocol {

    private var router: RedemptionRatingRouter
    var output: RedemptionRatingViewModelOutput?
    
    var ratingTypeItemModel: [RadioButtonItemModel] = []
    
    var ratingType: RedemptionRatingTypes? {
        didSet {
            checkDoneButtonState()
        }
    }
    
    func viewDidLoad() {
        output?(.doneButtonState(state: false))
        checkDoneButtonState()
    }
    
    private func setupRatingType() {
        ratingTypeItemModel = [
            RadioButtonItemModel(title: RedemptionRatingTypes.good.getTitle(), key: RedemptionRatingTypes.good.rawValue),
            RadioButtonItemModel(title: RedemptionRatingTypes.satisfactory.getTitle(), key: RedemptionRatingTypes.satisfactory.rawValue),
            RadioButtonItemModel(title: RedemptionRatingTypes.unsatisfactory.getTitle(), key: RedemptionRatingTypes.unsatisfactory.rawValue)
        ]
        
        ratingType = RedemptionRatingTypes(rawValue: ratingTypeItemModel.first?.key ?? "")
    }

    init(router: RedemptionRatingRouter//,
//         transactionId: String,
) {
        self.router = router
        
        setupRatingType()
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case doneButtonState(state: Bool)
    }
    
    func doneButtonPressed() {
        // TODO: Submit Rating
        
        // self.router.navigateToHome()
    }
    
    private func checkDoneButtonState() {
        if ratingType == nil {
            output?(.doneButtonState(state: false))
        } else {
            output?(.doneButtonState(state: true))
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
