import UIKit
import Foundation

typealias RedeemServiceViewModelOutput = (RedeemServiceViewModel.Output) -> Void

protocol RedeemServiceViewModelProtocol {
    var output: RedeemServiceViewModelOutput? {get set}

    var points: String? {get set}
    var equivalentPoints: String? {get set}
    var categoryCount: Int {get}
    func gotoNext(transactionId: String, partner: Partner?)
    func itemSelected(index: Int)
    func viewDidLoad()
    func cellDidTap(index: Int)
    func getCategory(index: Int) -> Category
}

class RedeemServiceViewModel: RedeemServiceViewModelProtocol {
    var categoryCount: Int {
        return partner.categoryCount
    }

    private var partner: Partner
    var output: RedeemServiceViewModelOutput?
    private var router: RedeemServiceRouter!
    private var service: RedeemService

    private var user: UserModel
    
    var points: String? {
        didSet {
            checkPointsValid()
        }
    }

    var equivalentPoints: String?

    init(router: RedeemServiceRouter,
         partner: Partner,
         user: UserModel,
         service: RedeemService = RedeemService()) {
        self.router = router
        self.partner = partner
        self.user = user
        self.service = service
    }

    func viewDidLoad() {
        output?(.reloadViewData(partnerName: self.partner.partnerName))
        output?(.updateLoyaltyCard(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)")))
    }

    func getCategory(index: Int) -> Category {
        return self.partner.categories[index]
    }

    func cellDidTap(index: Int) {
        let alert: AlertViewModel
        if self.partner.categories[index].pointsAssigned > self.user.roundedLoyaltyPoints {
            alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Oh Snap!".localized, alertDescription: "You do not have enough Loyalty Points.".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil), secondaryButton: nil)

        } else {

            let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)]
            
            let formattedPoints = PointsFormatter().format(string: "\(getCategory(index: index).pointsAssigned)")
            
            let string = String(format: "You have selected to redeem %1$@ \npoints for %2$@ at %3$@".localized, formattedPoints, self.partner.categories[index].categoryName, partner.partnerName)
            
            let indexForPoints = string.index(of: formattedPoints)?.utf16Offset(in: string) ?? 0
            let indexForCategory = string.index(of: partner.categories[index].categoryName)?.utf16Offset(in: string) ?? 0
            let indexForPartnerName = string.index(of: partner.partnerName)?.utf16Offset(in: string) ?? 0
            
            let attributedString = NSMutableAttributedString(string: string, attributes: regularAttributes)
            
            let pointsRange = NSRange(location: indexForPoints, length: formattedPoints.count + "\n".count + " Points".localized.count)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize), range: pointsRange)
            
            let categoryRange = NSRange(location: indexForCategory, length: partner.categories[index].categoryName.count)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize), range: categoryRange)
            
            let partnerNameRange = NSRange(location: indexForPartnerName, length: partner.partnerName.count)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize), range: partnerNameRange)

            alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points".localized, alertDescription: nil, alertAttributedDescription: attributedString, primaryButton: AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: {
                self.itemSelected(index: index)
            }), secondaryButton: AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil))

        }
        self.output?(.showAlert(alert: alert))
    }

    func gotoNext(transactionId: String, partner: Partner?) {
        self.router.gotoOTPScreen(transactionId: transactionId, partner: partner, user: self.user)
    }

    func checkPointsValid() {
        if points?.isBlank ?? true {
            self.output?(.nextButtonState(enableState: false))
        } else {
            self.output?(.nextButtonState(enableState: true))
        }
    }

    func getPartnerWithTransaction(index: Int) -> Partner {
        return Partner(id: partner.id, partnerName: partner.partnerName, categories: [getCategory(index: index)])
    }

    func itemSelected(index: Int) {
        output?(.showActivityIndicator(show: true))
        service.redeemPointsInitialize(requestModel: RedeemInitializeRequestModel(partnerId: "\(partner.id)", categoryId: "\(getCategory(index: index).id)", points: getCategory(index: index).pointsAssigned)) {[weak self] (result) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self.gotoNext(transactionId: response.transactionId, partner: self.getPartnerWithTransaction(index: index))
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case nextButtonState(enableState: Bool)
        case showAlert(alert: AlertViewModel)
        case reloadViewData(partnerName: String)
        case updateLoyaltyCard(viewModel: LoyaltyCardViewModel)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
