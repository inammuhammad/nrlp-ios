import UIKit
import Foundation

typealias RedeemViewModelOutput = (RedeemViewModel.Output) -> Void

protocol RedeemViewModelProtocol {
    var output: RedeemViewModelOutput? {get set}
    var numberOfRows: Int {get}
    func didSelectOption(index: Int)
    func viewDidLoad()
    func getPartner(index: Int) -> Partner
}

class RedeemViewModel: RedeemViewModelProtocol {

    private var router: RedeemRouter!
    var output: RedeemViewModelOutput?
    private var service: RedeemService
    private var partners: [Partner] = []
    private var user: UserModel

    func getPartner(index: Int) -> Partner {
        return partners[index]
    }

    var numberOfRows: Int {
        return partners.count
    }

    init(router: RedeemRouter,
         user: UserModel,
         service: RedeemService = RedeemService()) {
        self.router = router
        self.user = user
        self.service = service
    }

    func viewDidLoad() {
        fetchLoyaltyPartners()
    }

    private func fetchLoyaltyPartners() {
        self.output?(.showActivityIndicator(show: true))
        service.fetchLoyaltyPartners {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self?.partners = response.data
                self?.output?(.dataReload)
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case dataReload
    }

    func didSelectOption(index: Int) {
        let partner = self.partners[index]
        router.navigateToCategory(partner: partner, user: user)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
