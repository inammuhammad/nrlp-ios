//
//  LoyaltyPointsViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias LoyaltyPointsViewModelOutput = (LoyaltyPointsViewModel.Output) -> Void

protocol LoyaltyPointsViewModelProtocol {

    var output: LoyaltyPointsViewModelOutput? { get set}
    var numberOfStatement: Int { get }
    func viewModelDidLoad()
    func getStatement(at index: Int) -> LoyaltyPointsTableCellViewModel
    func goToAdvanceStatement()
}

class LoyaltyPointsViewModel: LoyaltyPointsViewModelProtocol {
    
    private var service: LoyaltyPointsServiceProtocol
    private var router: LoyaltyPointsRouter
    var output: LoyaltyPointsViewModelOutput?

    private var userModel: UserModel
    private var statements: [Statement] = []

    var numberOfStatement: Int {
        return statements.count
    }
    
    var loyaltyCardImageStyle: UIImage? {
        return userModel.loyaltyLevel.cardImage
    }

    init(router: LoyaltyPointsRouter,
         userModel: UserModel,
         service: LoyaltyPointsServiceProtocol = LoyaltyPointsService()) {
        self.service = service
        self.router = router
        self.userModel = userModel
    }

    func viewModelDidLoad() {
        fetchStatements()
        self.output?(.updateLoyaltyCard(viewModel: LoyaltyCardViewModel(with: self.userModel.loyaltyLevel, userPoints: "\(userModel.roundedLoyaltyPoints)")))
    }

    func getStatement(at index: Int) -> LoyaltyPointsTableCellViewModel {
        return LoyaltyPointsTableCellViewModel(with: statements[index])
    }

    private func fetchStatements() {

        self.output?(.showActivityIndicator(show: true))
        service.fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel()) { [weak self] (result) in

            guard let self = self else { return }

            self.output?(.showActivityIndicator(show: false))

            switch result {
            case .success(let loyaltyStatement):
                let statement: [Statement] = loyaltyStatement.data.statements
                self.statements = self.sortStatement(statement: statement)
                let formater = PointsFormatter()
                let points = Int(loyaltyStatement.data.currentpointbalance.double)
                let formattedPoints = formater.format(string: "\(points)")
                self.output?(.updateLoyaltyCard(viewModel: LoyaltyCardViewModel(with: self.userModel.loyaltyLevel, userPoints: formattedPoints)))
                self.output?(.reloadStatements)
                if self.statements.isEmpty {
                    self.output?(.showTable(show: false))
                } else {
                    self.output?(.showTable(show: true))
                }
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    private func sortStatement(statement: [Statement]) -> [Statement] {
        let arraySliceStatement = statement.sorted(by: { (firstObject, secondObject) -> Bool in

            var _firstObject = firstObject
            var _secondObject = secondObject

            guard let firstDate = _firstObject.createdDate,
                let secondDate = _secondObject.createdDate else {
                    return false
            }
            return firstDate > secondDate
        }).prefix(10)

        return Array(arraySliceStatement)
    }
    
    func goToAdvanceStatement() {
        self.router.navigateToFilterScreen(userModel: userModel)
    }
    
    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case reloadStatements
        case updateLoyaltyCard(viewModel: LoyaltyCardViewModel)
        case showTable(show: Bool)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
