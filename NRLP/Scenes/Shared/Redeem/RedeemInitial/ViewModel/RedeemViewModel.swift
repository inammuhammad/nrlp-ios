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
        // router.navigateToRedemptionRating()
    }

    private func fetchLoyaltyPartners() {
        self.output?(.showActivityIndicator(show: true))
        service.fetchLoyaltyPartners {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                let sortedArr = response.data.sorted(by: { $0.partnerName < $1.partnerName })
                self?.partners = sortedArr
                
                // FIXME: -
//                for i in 0..<(self?.partners.count ?? 0) {
//                    self?.partners[i].partnerName = "\(self?.partners[i].partnerName ?? "") Modified"
//                }
                // self?.partners[0].partnerName = "BEOE Modified"
                
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
        
        // NAVIGATE TO FBR TRIGGER
        
//        router.navigateToFBR(user: user)
        if partner.partnerName.lowercased().contains("FBR".lowercased()) {
//            if partner.categoryCount == 0 {
                router.navigateToFBR(partner: partner, user: user)
//            } else {
//                router.navigateToCategory(partner: partner, user: user)
//            }
        } else if partner.partnerName.lowercased().contains("CAA".lowercased()) {
            if partner.categoryCount != 0 {
                router.navigateToCategory(partner: partner, user: user)
            }
        } else if partner.partnerName.lowercased().contains("Passport".lowercased()) {
            if partner.categoryCount != 0 {
                router.navigateToCategory(partner: partner, user: user)
            } else {
                router.navigateToCategory(partner: partner, user: user)
            }
        } else if partner.partnerName.lowercased().contains("PIA".lowercased()) {
//            if partner.categoryCount != 0 {
//                router.navigateToCategory(partner: partner, user: user)
//            } else {
                router.navigateToPIA(partner: partner, user: user)
//            }
        } else if partner.partnerName.lowercased().contains("NADRA".lowercased()) {
//            if partner.categoryCount != 0 {
//                router.navigateToCategory(partner: partner, user: user)
//            } else {
                router.navigateToNadra(partner: partner, user: user)
//            }
        } else if partner.partnerName.lowercased().contains("USC".lowercased()) {
//            if partner.categoryCount != 0 {
//                router.navigateToCategory(partner: partner, user: user)
//            } else {
                router.navigateToUSC(partner: partner, user: user)
//            }
        } else if partner.partnerName.lowercased().contains("OPF".lowercased()) {
//            if partner.categoryCount != 0 {
//                router.navigateToCategory(partner: partner, user: user)
//            } else {
                router.navigateToOPF(partner: partner, user: user)
//            }
        } else if partner.partnerName.lowercased().contains("SLIC".lowercased()) {
            if partner.categoryCount != 0 {
                router.navigateToCategory(partner: partner, user: user)
            }
        } else if partner.partnerName.lowercased().contains("BEOE".lowercased()) {
            if partner.categoryCount != 0 {
                router.navigateToCategory(partner: partner, user: user)
            }
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
