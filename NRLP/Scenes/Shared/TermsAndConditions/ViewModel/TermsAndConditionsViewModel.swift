//
//  TermsAndConditionsViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias TermsAndConditionViewModelOutput = (TermsAndConditionViewModel.Output) -> Void

protocol TermsAndConditionViewModelProtocol {

    var output: TermsAndConditionViewModelOutput? { get set }
    var isTermsAccepted: Bool { get set }
    func didTapRegisterButton()
    func didTapDeclinedTermsAndCondition()
    func didConfirmedDeclinedRegistration()
    func viewModelDidLoad()
}

class TermsAndConditionViewModel: TermsAndConditionViewModelProtocol {
    private var router: TermsAndConditionRouter
    var output: TermsAndConditionViewModelOutput?
    private var model: RegisterRequestModel
    private var termsAndConditionService: TermsAndConditionServiceProtocol
    private var registerUserService: RegisterUserService
    private var cancelRegisterUserService: CancelRegisterUserService
    private var tnc: TermsAndConditionContentModel?

    var isTermsAccepted: Bool = false {
        didSet {
            output?(.nextButtonState(enableState: isTermsAccepted))
        }
    }

    init(with router: TermsAndConditionRouter,
         model: RegisterRequestModel,
         termsAndConditionService: TermsAndConditionServiceProtocol,
         registerUserService: RegisterUserService,
         cancelRegisterUserService: CancelRegisterUserService,
         isFromBeneficiary: Bool = false) {

        self.router = router
        self.model = model
        if isFromBeneficiary {
            self.model.residentID = "-"
            self.model.passportType = "-"
            self.model.passportNumber = "-"
        }
        self.termsAndConditionService = termsAndConditionService
        self.registerUserService = registerUserService
        self.cancelRegisterUserService = cancelRegisterUserService
    }

    func viewModelDidLoad() {
        fetchTermsAndCondition()
    }

    private func fetchTermsAndCondition() {
        output?(.showActivityIndicator(show: true))
        termsAndConditionService.fetchTermsAndCondition { [weak self] (resposne) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch resposne {
            case .success(let model):
                self.tnc = model.data
                let attrTnc = self.tnc?.content.getStringForHTMLContent()
                self.output?(.updateTermsAndCondition(content: attrTnc ?? NSAttributedString()))
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    private func registerUser() {
        output?(.showActivityIndicator(show: true))
        model.sotp = "2"
        model.versionNo = tnc?.versionNo ?? "-"
        model.tncId = tnc?.id ?? -1
        registerUserService.registerUser(with: model) { [weak self] (response) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch response {
            case .success:
                self.router.navigateToRegistrationCompletionScreen(accountType: AccountType(rawValue: self.model.accountType)!)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    func didTapRegisterButton() {
        registerUser()
    }

    func didTapDeclinedTermsAndCondition() {
        output?(.showConfirmRegistrationDeclineAlert)
    }

    func didConfirmedDeclinedRegistration() {
        guard let tnc = tnc else {
            return
        }
        
        output?(.showActivityIndicator(show: true))
        
        let cancelModel = CancelRegisterRequestModel(
            accountType: model.accountType,
            cnicNicop: model.cnicNicop,
            versionNo: tnc.versionNo, tncId: tnc.id
        )
        
        cancelRegisterUserService.cancelRegisterUser(with: cancelModel) { [weak self] (response) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch response {
            case .success:
                self.router.navigateToLoginScreen()
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    enum Output {
        case nextButtonState(enableState: Bool)
        case showConfirmRegistrationDeclineAlert
        case updateTermsAndCondition(content: NSAttributedString)
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
