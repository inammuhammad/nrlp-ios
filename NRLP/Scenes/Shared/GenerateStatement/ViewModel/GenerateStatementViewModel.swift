import Foundation
import UIKit

typealias GenerateStatementViewModelOutput = (GenerateStatementViewModel.Output) -> Void

protocol GenerateStatementViewModelProtocol {
    var output: GenerateStatementViewModelOutput? { get set}
    
//    var email: String? { get set }
    var toDate: Date? { get set }
    var fromDate: Date? { get set }
    var datePickerViewModel: CustomDatePickerViewModel { get }
    
    func nextButtonPressed()
    func viewModelDidLoad()
}

class GenerateStatementViewModel: GenerateStatementViewModelProtocol {
    private let filename = "SDRP-Statemet.pdf"
    
    init(userModel: UserModel, router: GenerateStatementRouter, service: LoyaltyPointsServiceProtocol = LoyaltyPointsService()) {
        self.router = router
        self.service = service
        self.userModel = userModel
    }
    
    var output: GenerateStatementViewModelOutput?
    private var router: GenerateStatementRouter?
    private var service: LoyaltyPointsServiceProtocol?
    private var userModel: UserModel
    
//    var email: String? {
//        didSet {
//            self.validateRequiredFields()
//        }
//    }
    
    var toDate: Date? {
        didSet {
            self.validateRequiredFields()
            self.output?(.updateToDate(date: toDateString))
            self.output?(.setFromDateLimit(from: nil, to: toDate))
        }
    }
    
    var datePickerViewModel: CustomDatePickerViewModel {
//        let date = "2020-01-01"
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = Date().adding(days: -365) {
            return CustomDatePickerViewModel(minDate: date)
        }
        
        return CustomDatePickerViewModel()
    }
    
    var fromDate: Date? {
        didSet {
            self.validateRequiredFields()
            self.output?(.updateFromDate(date: fromDateString))
            self.output?(.setToDateLimit(from: fromDate, to: nil))
        }
    }
    
    private var fromDateString: String {
        return DateFormat().formatDateString(to: fromDate ?? Date(), formatter: .pickerFormat) ?? ""
    }
    
    private var toDateString: String {
        return DateFormat().formatDateString(to: toDate ?? Date(), formatter: .pickerFormat) ?? ""
    }
    
    func nextButtonPressed() {
        guard validateDataWithRegex() else {
            return
        }
        
        self.output?(.showActivityIndicator(show: true)) // Changed during Unit Testing
        
        let dateFormater = DateFormat()
        let fromDate = dateFormater.formatDateString(dateString: fromDateString, fromFormat: .pickerFormat, toFormat: .advanceStatementFormat) ?? ""
        let toDate = dateFormater.formatDateString(dateString: toDateString, fromFormat: .pickerFormat, toFormat: .advanceStatementFormat) ?? ""
        
        service?.fetchStatementPDF(
            requestModel: FetchLoyaltyAdvanceStatementRequestModel(
                email: "-",
                fromDate: fromDate,
                toDate: toDate
            )
        ) { [weak self] result in
            self?.output?(.showActivityIndicator(show: false))
            
            switch result {
            case .success(let data):
                self?.processPDF(data: data)
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }
    
    func viewModelDidLoad() {
//        email = userModel.email
//        output?(.setUserEmail(email: userModel.email ?? ""))
    }
    
    private func validateDataWithRegex() -> Bool {
        var isValid = true
        
//        if email?.isValid(for: RegexConstants.emailRegex) ?? false {
//            output?(.emailTextField(errorState: false, error: nil))
//        } else {
//            isValid = false
//            output?(.emailTextField(errorState: true, error: StringConstants.ErrorString.emailError.localized))
//        }
        
        if toDate != nil {
            output?(.toDateTextField(errorState: false, error: nil))
        } else {
            isValid = false
            output?(.toDateTextField(errorState: true, error: StringConstants.ErrorString.toDateError.localized))
        }
        
        if fromDate != nil {
            output?(.fromDateTextField(errorState: false, error: nil))
        } else {
            isValid = false
            output?(.fromDateTextField(errorState: true, error: StringConstants.ErrorString.fromDateError.localized))
        }
        
        if let fromDate = fromDate {
            if let toDate = toDate {
                if fromDate >= toDate {
                    isValid = false
                    output?(.fromDateTextField(errorState: true, error: StringConstants.ErrorString.fromDateAfter.localized))
                }
            }
        } else {
            isValid = false
        }
        return isValid
    }
    
    enum Output {
        case updateToDate(date: String)
        case updateFromDate(date: String)
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case nextButtonState(enableState: Bool)
//        case setUserEmail(email: String)
//        case emailTextField(errorState: Bool, error: String?)
        case toDateTextField(errorState: Bool, error: String?)
        case fromDateTextField(errorState: Bool, error: String?)
        case setFromDateLimit(from: Date?, to: Date?)
        case setToDateLimit(from: Date?, to: Date?)
        case sharePDF(url: URL)
    }
    
    private func validateRequiredFields() {
        if toDate == nil || fromDate == nil {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension GenerateStatementViewModel {
    private func processPDF(data: Data) {
        self.savePdf(pdfData: data)
    }
    
    private func savePdf(pdfData: Data) {
        DispatchQueue.main.async {
            let cacheDirPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let pdfName = self.filename
            let path = cacheDirPath.appendingPathComponent(pdfName)
            
            do {
                // atomic overrites if file already exists
                try pdfData.write(to: path, options: .atomic)
                self.showSavedPdf()
            } catch {
                self.output?(.showError(error: APIResponseError.unknown))
            }
        }
    }
    
    func showSavedPdf() {
        do {
            let cacheDirPath = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let contents = try FileManager.default.contentsOfDirectory(
                at: cacheDirPath,
                includingPropertiesForKeys: [.fileResourceTypeKey],
                options: .skipsHiddenFiles
            )
    
            for url in contents {
                if url.description.contains(filename) {
                    self.output?(.sharePDF(url: url))
                    return
                }
            }
            
            self.output?(.showError(error: APIResponseError.unknown))
        } catch {
            self.output?(.showError(error: APIResponseError.unknown))
        }
    }
}
