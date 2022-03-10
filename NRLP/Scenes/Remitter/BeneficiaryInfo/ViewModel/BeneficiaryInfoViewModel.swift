//
//  BeneficiaryInfoViewMode.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
typealias BeneficiaryInfoViewModelOutput = (BeneficiaryInfoViewModel.Output) -> Void

protocol BeneficiaryInfoViewModelProtocol {
    var output: BeneficiaryInfoViewModelOutput? { get set}
    var name: String? { get set }
    var cnic: String? { get set }
    var mobileNumber: String? { get set }
    var countryName: String? { get set }
    var relation: String? { get set }
    var customRelation: String? { get set }
    var relationshipPickerViewModel: ItemPickerViewModel { get }
    
    func viewDidLoad()
    func deleteButtonPressed()
    func editButtonPressed()
    func resendOTPButtonPressed()
    func updateButtonPressed()
    func cancelButtonPressed()
    func didSelect(relationshipTypeItem: RelationshipTypePickerItemModel?)
    func openCountryPicker()
    func startTimer()
    func stopTimer()
}

class BeneficiaryInfoViewModel: BeneficiaryInfoViewModelProtocol {
    
    var output: BeneficiaryInfoViewModelOutput?
    private var router: BeneficiaryInfoRouter
    private var service: ManageBeneficiaryServiceProtocol
    private var beneficiary: BeneficiaryModel
    
    private weak var timer: Timer?
    private var resendTime = 300
    
    var name: String?
    var cnic: String?
    var mobileNumber: String?
    var relation: String?
    var countryName: String?
    var customRelation: String?
    
    private var countrySelected: Country?
    
    var relationshipPickerViewModel: ItemPickerViewModel {
        var array: [PickerItemModel] = [PickerItemModel]()
        array.append(RelationshipTypePickerItemModel(title: RelationshipType.mother.getTitle(), key: RelationshipType.mother.rawValue))
        array.append(RelationshipTypePickerItemModel(title: RelationshipType.father.getTitle(), key: RelationshipType.father.rawValue))
        array.append(RelationshipTypePickerItemModel(title: RelationshipType.child.getTitle(), key: RelationshipType.child.rawValue))
        array.append(RelationshipTypePickerItemModel(title: RelationshipType.brother.getTitle(), key: RelationshipType.brother.rawValue))
        array.append(RelationshipTypePickerItemModel(title: RelationshipType.sister.getTitle(), key: RelationshipType.sister.rawValue))
        array.append(RelationshipTypePickerItemModel(title: RelationshipType.spouse.getTitle(), key: RelationshipType.spouse.rawValue))
        array.append(RelationshipTypePickerItemModel(title: RelationshipType.other.getTitle(), key: RelationshipType.other.rawValue))
        return ItemPickerViewModel(data: array)
    }
    
    init(router: BeneficiaryInfoRouter, beneficiary: BeneficiaryModel, service: ManageBeneficiaryServiceProtocol) {
        self.router = router
        self.beneficiary = beneficiary
        self.service = service
        self.name = beneficiary.alias
        self.cnic = "\(beneficiary.nicNicop)"
        self.mobileNumber = beneficiary.mobileNo
        self.relation = beneficiary.beneficiaryRelation
        self.countryName = beneficiary.country
    }
    
    func viewDidLoad() {
        if beneficiary.isActive == 0 {
            checkResendTime()
            self.output?(.shouldShowEditStackView(show: true))
            self.output?(.shouldShowUpdateStackView(show: false))
        } else {
            self.output?(.shouldShowEditStackView(show: false))
            self.output?(.shouldShowUpdateStackView(show: false))
        }
    }
    
    private func checkResendTime() {
        let updatedAtTime = beneficiary.updateAtTime ?? Date()
        let secondsDifference = DateFormat().getDateDiff(start: updatedAtTime, end: Date())
        if secondsDifference > 300 {
            self.output?(.showResendTimer(show: false))
        } else {
            if secondsDifference < 300 {
                self.resendTime = 300 - secondsDifference
            }
            self.output?(.showResendTimer(show: true))
        }
    }
    
    func deleteButtonPressed() {
        
        let descriptionString = String(format: "Are you sure you want to delete %@ ?".localized, beneficiary.alias ?? "")
        let model = AlertViewModel(alertHeadingImage: .declineAlert, alertTitle: "Delete Beneficiary".localized, alertDescription: descriptionString, primaryButton: AlertActionButtonModel(buttonTitle: "Yes".localized, buttonAction: {
            self.output?(.showActivityIndicator(show: true))
            self.service.deleteBeneficiary(beneficiary: DeleteBeneficiaryRequestModel( beneficiaryId: self.beneficiary.beneficiaryId)) { [weak self] (result) in
                self?.output?(.showActivityIndicator(show: false))
                guard let self = self else { return }
                self.output?(.showActivityIndicator(show: false))
                
                switch result {
                case .success:
                    self.router.popToBeneficiaryInfoController()
                case .failure(let error):
                    self.output?(.showError(error: error))
                }
                
            }
            
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "No".localized, buttonAction: {
            
        }))
        
        self.output?(.showAlert(alert: model))
        
    }
    
    func editButtonPressed() {
        self.output?(.shouldShowEditStackView(show: false))
        self.output?(.shouldShowUpdateStackView(show: true))
        self.output?(.editTextFields(isEditable: true))
    }
    
    func resendOTPButtonPressed() {
        guard timer == nil else {
            let alert = AlertViewModel(alertHeadingImage: .successAlert, alertTitle: "Please Wait!", alertDescription: "Please wait 5 minutes before resending OTP".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Done".localized, buttonAction: {
                // self.router.popToBeneficiaryInfoController()
            }))
            self.output?(.showAlert(alert: alert))
            return
        }
        
        self.output?(.showActivityIndicator(show: true))
        let requestModel = ResendOTPBeneficiaryRequestModel(beneficiaryID: beneficiary.beneficiaryId.toString())
        service.resendOTPBeneficiary(requestModel: requestModel) { [weak self] (result) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(_):
                let alert = AlertViewModel(alertHeadingImage: .successAlert, alertTitle: "", alertDescription: "Registration code has been resent".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Done".localized, buttonAction: {
                    self.resetBeneficiary()
                    self.router.popToBeneficiaryInfoController()
                }))
                self.output?(.showAlert(alert: alert))
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }
    
    func updateButtonPressed() {
        // Verify textfields
        if !validateDataWithRegex() {
            return
        }
        let mobNumber = "\(countrySelected?.code ?? "")\(mobileNumber ?? "")"
        let requestModel = UpdateBeneficiaryRequestModel(beneficiaryID: beneficiary.beneficiaryId.toString(), beneficiaryName: name, beneficiaryMobileNo: mobNumber, beneficiaryNicNicop: cnic, beneficiaryRelation: relation, beneficiaryCountry: countryName)
        print(requestModel)
        self.output?(.showActivityIndicator(show: true))
        service.updateBeneficiary(requestModel: requestModel) { [weak self] result in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(_):
                let alert = AlertViewModel(alertHeadingImage: .successAlert, alertTitle: "", alertDescription: "Beneficiary details has been updated successfully".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Done".localized, buttonAction: {
                    self?.router.popToBeneficiaryInfoController()
                }))
                self?.output?(.showAlert(alert: alert))
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }
    
    func cancelButtonPressed() {
        resetBeneficiary()
        self.output?(.shouldShowEditStackView(show: true))
        self.output?(.shouldShowUpdateStackView(show: false))
        self.output?(.editTextFields(isEditable: false))
    }
    
    func didSelect(relationshipTypeItem: RelationshipTypePickerItemModel?) {
        if let relationshipType = relationshipTypeItem?.relationshipType {
            if relationshipType.getTitle().lowercased() == RelationshipType.other.getTitle().lowercased() {
                // SHOW NEXT TEXTFIELD
                relation = ""
                output?(.showBeneficiaryTextField(isVisible: true))
            } else {
                // SET TEXTFIELD
                relation = relationshipType.getTitle()
                output?(.showBeneficiaryTextField(isVisible: false))
                output?(.updateRelationshipType(inputText: relationshipType.getTitle()))
            }
        }
    }
    
    func openCountryPicker() {
        router.navigateToCountryPicker(with: { [weak self] selectedCountry in
            if selectedCountry.country != self?.countryName {
                self?.countrySelected = selectedCountry
                self?.countryName = selectedCountry.country
                self?.output?(.updateMobileCode(code: selectedCountry.code + " - "))
                self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x", count: selectedCountry.length).joined()))
                self?.output?(.updateCountry(countryName: selectedCountry.country))
            }
        }, accountType: .beneficiary)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if resendTime > 0 {
            resendTime -= 1
        } else {
            self.output?(.showResendTimer(show: false))
            stopTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        resendTime = 300
    }
    
    enum Output {
        case showError(error: APIResponseError)
        case deleteButtonState
        case showAlert(alert: AlertViewModel)
        case dismissAlert
        case editTextFields(isEditable: Bool)
        case showActivityIndicator(show: Bool)
        case shouldShowEditStackView(show: Bool)
        case shouldShowUpdateStackView(show: Bool)
        case resetBeneficiary(beneficiary: BeneficiaryModel)
        case nameTextField(errorState: Bool, errorMessage: String?)
        case cnicTextField(errorState: Bool, errorMessage: String?)
        case mobileNumberTextField(errorState: Bool, errorMessage: String?)
        case customRelationTextField(errorState: Bool, errorMessage: String?)
        case countryTextField(errorState: Bool, errorMessage: String?)
        case updateRelationshipType(inputText: String)
        case showBeneficiaryTextField(isVisible: Bool)
        case clearCustomRelationTextField
        case updateMobileCode(code: String)
        case updateMobilePlaceholder(placeholder: String)
        case updateCountry(countryName: String)
        case showResendTimer(show: Bool)
    }
    
    private func resetBeneficiary() {
        self.output?(.clearCustomRelationTextField)
        self.output?(.resetBeneficiary(beneficiary: beneficiary))
    }
    
    deinit {
        stopTimer()
        print("I am getting deinit \(String(describing: self))")
    }
}

extension BeneficiaryInfoViewModel {

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

//        if name?.isValid(for: RegexConstants.nameRegex) ?? false {
//            output?(.nameTextField(errorState: false, errorMessage: nil))
//        } else {
//            output?(.nameTextField(errorState: true, errorMessage: StringConstants.ErrorString.nameError.localized))
//            isValid = false
//        }

        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.cnicTextField(errorState: false, errorMessage: nil))
        } else {
            output?(.cnicTextField(errorState: true, errorMessage: StringConstants.ErrorString.cnicError.localized))
            isValid = false
        }

        if countryName != nil && !(mobileNumber?.isBlank ?? false) {
            output?(.mobileNumberTextField(errorState: false, errorMessage: nil))
        } else {
            output?(.mobileNumberTextField(errorState: true, errorMessage: StringConstants.ErrorString.mobileNumberError.localized))
            isValid = false
        }
        
//        if !(relation?.isBlank ?? false) {
//            output?(.customRelationTextField(errorState: false, errorMessage: nil))
//        } else {
//            output?(.customRelationTextField(errorState: true, errorMessage: StringConstants.ErrorString.selectBeneficiaryError.localized))
//            isValid = false
//        }
        return isValid
    }
}
