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
    func getPartner() -> Partner
}

class RedeemServiceViewModel: RedeemServiceViewModelProtocol {
    func getPartner() -> Partner {
        return self.partner
    }
    
    var categoryCount: Int {
        return partner.categoryCount
    }

    private var partner: Partner
    var output: RedeemServiceViewModelOutput?
    private var router: RedeemServiceRouter!
    private var service: RedeemService
    private var redemptionService = RedemptionService()

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
        output?(.updateLoyaltyCard(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)", user: self.user)))
    }

    func getCategory(index: Int) -> Category {
        return self.partner.categories[index]
    }

    func cellDidTap(index: Int) {
        
        if self.partner.partnerName.lowercased().contains("passport".lowercased()) {
            executePassportFlow(index: index)
        } else if self.partner.partnerName.lowercased().contains("Fbr".lowercased()) {
            executeFBRFlow(index: index)
        } else if self.partner.partnerName.lowercased().contains("nadra".lowercased()) {
            executeNadraFlow(index: index)
        } else if self.partner.partnerName.lowercased().contains("PIA".lowercased()) {
            executePIAFlow(index: index)
        } else if self.partner.partnerName.lowercased().contains("usc".lowercased()) {
            executeUSCFlow(index: index)
        } else if self.partner.partnerName.lowercased().contains("opf".lowercased()) {
            executeOPFFlow(index: index)
        } else if self.partner.partnerName.lowercased().contains("SLIC".lowercased()) {
            executeSLICFlow(index: index)
        } else if self.partner.partnerName.lowercased().contains("BEOE".lowercased()) {
            executeBEOEFlow(index: index)
        } else {
            let alert: AlertViewModel
            if self.partner.categories[index].pointsAssigned > self.user.roundedLoyaltyPoints {
                alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Oh Snap!".localized, alertDescription: "You do not have enough Loyalty Points.".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil), secondaryButton: nil)
                
            } else {
                alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points".localized, alertDescription: nil, alertAttributedDescription: getAlertDescription(index: index), primaryButton: AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: {
                    self.itemSelected(index: index)
                }), secondaryButton: AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil))
                
            }
            self.output?(.showAlert(alert: alert))
        }
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
        case navigateToFinishScreen(partner: Partner, transactionID: String)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
    private func getAlertDescription(index: Int) -> NSAttributedString {
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
        return attributedString
    }
    
    private func executePassportFlow(index: Int) {
        var alert: AlertViewModel
        var cnic = ""
        var mobileNumber = ""
        var email = ""
        
        let topTextfieldViewModel = AlertTextFieldModel(
            placeholderText: "Enter Applicant's CNIC/NICOP",
            placeHolderTextColor: .black,
            inputFieldMaxLength: 13,
            inputFieldMinLength: 13,
            editKeyboardType: .asciiCapableNumberPad,
            formatValidator: CNICFormatValidator(
                regex: RegexConstants.cnicRegex,
                invalidFormatError: StringConstants.ErrorString.cnicError
            ),
            formatter: CNICFormatter(),
            onTextFieldChanged: { text in
                cnic = text
            },
            errorMessage: StringConstants.ErrorString.cnicError,
            onError: nil
        )
        let midTextfieldViewModel = AlertTextFieldModel(
            placeholderText: "Enter Mobile No.",
            placeHolderTextColor: .black,
            inputFieldMaxLength: 20,
            editKeyboardType: .asciiCapableNumberPad,
            formatValidator: FormatValidator(
                regex: RegexConstants.mobileNumberRegex,
                invalidFormatError: "Please enter valid Mobile No".localized
            ),
            onTextFieldChanged: { text in
                mobileNumber = text
            },
            errorMessage: "Please enter valid Mobile No".localized,
            onError: nil
        )
        let bottomTextfieldViewModel = AlertTextFieldModel(
            placeholderText: "Enter Email Address (Optional)",
            placeHolderTextColor: .black,
            editKeyboardType: .emailAddress,
            isOptional: true
        ) { text in
            email = text
        }
        
        let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm") {
            if AppConstants.isDev {
                print("\(cnic) \(mobileNumber) \(email)")
            }
            if !email.isEmpty {
                if !email.isValid(for: RegexConstants.emailRegex) {
                    let alert = AlertViewModel(alertHeadingImage: .noImage, alertTitle: "Error", alertDescription: "Please enter a valid email address", alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "OK"))
                    self.output?(.showAlert(alert: alert))
                    return
                }
            }
            if !cnic.isValid(for: RegexConstants.cnicRegex) || cnic.isEmpty || mobileNumber.isEmpty {
                let alert = AlertViewModel(alertHeadingImage: .noImage, alertTitle: "Error", alertDescription: "Please enter valid data.", alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "OK"))
                self.output?(.showAlert(alert: alert))
                return
            }
            self.showNewAlert(index: index, cnic: cnic, mobileNo: mobileNumber, email: email)
        }
        let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel", buttonAction: nil)
        alert = AlertViewModel(
            alertHeadingImage: .redeemPoints,
            alertTitle: "Redeem Points",
            alertDescription: nil,
            alertAttributedDescription: getAlertDescription(index: index),
            primaryButton: confirmButton,
            secondaryButton: cancelButton,
            topTextField: topTextfieldViewModel,
            middleTextField: midTextfieldViewModel,
            bottomTextField: bottomTextfieldViewModel
        )
        output?(.showAlert(alert: alert))
    }
    
    private func executeNadraFlow(index: Int) {
        let category = getCategory(index: index)
        router.navigateToNadra(partner: partner, user: user, category: category)
    }
    
    private func executeFBRFlow(index: Int) {
        router.navigateToFBR(partner: partner, user: user)
    }
    
    private func executePIAFlow(index: Int) {
        let category = getCategory(index: index)
        router.navigateToPIA(partner: partner, user: user, category: category)
    }
    
    private func executeUSCFlow(index: Int) {
        router.navigateToUSC(partner: partner, user: user)
    }
    
    private func executeOPFFlow(index: Int) {
        router.navigateToOPF(partner: partner, user: user)
    }
    
    private func executeSLICFlow(index: Int) {
        let category = getCategory(index: index)
        router.navigateToSLIC(partner: partner, user: user, category: category)
    }
    
    private func executeBEOEFlow(index: Int) {
        let category = getCategory(index: index)
        router.navigateToBEOE(partner: partner, user: user, category: category)
    }
    
    private func validateTextFields(cnic: String, mobile: String) -> Bool {
        if cnic.isValid(for: RegexConstants.cnicRegex) || !cnic.isEmpty {
            return true
        }
        return false
    }
    
    private func showNewAlert(index: Int, cnic: String, mobileNo: String, email: String?) {
        if self.partner.partnerName.lowercased() == "passport".lowercased() {
            let alert: AlertViewModel
            let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel", buttonAction: nil)
            let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm") {
                self.output?(.showActivityIndicator(show: true))
                let points = self.getCategory(index: index).pointsAssigned
                let formattedPoints = "\(points)"
                let model = InitRedemptionTransactionModel(code: self.partner.partnerName, pse: self.partner.partnerName, consumerNo: cnic, amount: formattedPoints, sotp: 1, pseChild: self.partner.categories[index].categoryName, mobileNo: mobileNo, email: email)
                self.redemptionService.redemptionTransactionSendOTP(requestModel: model) { result in
                    self.output?(.showActivityIndicator(show: false))
//                    self.router.navigateToOTPScreen(transactionID: "-", partner: self.partner, user: self.user, inputModel: model, flowType: .DGIP)
                    switch result {
                    case .success(let response):
                        self.router.navigateToOTPScreen(transactionID: response.transactionId, partner: self.partner, user: self.user, inputModel: model, flowType: .DGIP)
                    case .failure(let error):
                        self.output?(.showError(error: error))
                    }
                }
            }
            alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points", alertDescription: nil, alertAttributedDescription: self.getAlertDescription(index: index), primaryButton: confirmButton, secondaryButton: cancelButton)
            self.output?(.showAlert(alert: alert))
        } else {
            let alert: AlertViewModel
            let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel", buttonAction: nil)
            let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm") {
                self.output?(.navigateToFinishScreen(partner: self.partner, transactionID: ""))
            }
            alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points", alertDescription: nil, alertAttributedDescription: self.getAlertDescription(index: index), primaryButton: confirmButton, secondaryButton: cancelButton)
            self.output?(.showAlert(alert: alert))
        }
    }
}
