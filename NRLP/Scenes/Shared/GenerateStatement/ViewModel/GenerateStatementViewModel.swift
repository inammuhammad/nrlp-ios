import Foundation

typealias GenerateStatementViewModelOutput = (GenerateStatementViewModel.Output) -> Void

protocol GenerateStatementViewModelProtocol {
    var output: GenerateStatementViewModelOutput? { get set}

    var email: String? { get set }
    var toDate: Date? { get set }
    var fromDate: Date? { get set }
    var datePickerViewModel: CustomDatePickerViewModel { get }
    
    func nextButtonPressed()
    func viewModelDidLoad()
}

class GenerateStatementViewModel: GenerateStatementViewModelProtocol {

    init(userModel: UserModel, router: GenerateStatementRouter, service: LoyaltyPointsServiceProtocol = LoyaltyPointsService()) {
        self.router = router
        self.service = service
        self.userModel = userModel
    }

    var output: GenerateStatementViewModelOutput?
    private var router: GenerateStatementRouter?
    private var service: LoyaltyPointsServiceProtocol?
    private var userModel: UserModel
    
    var email: String? {
        didSet {
            self.validateRequiredFields()
        }
    }

    var toDate: Date? {
        didSet {
            self.validateRequiredFields()
            self.output?(.updateToDate(date: toDateString))
            self.output?(.setFromDateLimit(from: nil, to: toDate))
        }
    }
    
    var datePickerViewModel: CustomDatePickerViewModel {
        let date = "2020-01-01"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return CustomDatePickerViewModel(minDate: dateFormatter.date(from: date)!)
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
        
        service?.fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel(email: self.email ?? "", fromDate: fromDate, toDate: toDate), responseHandler: { [weak self] (result) in
            guard let self = self else { return }

            self.output?(.showActivityIndicator(show: false))

            switch result {
            case .success:
                self.router?.navigateToSuccessScreen()
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        })
    }
    
    func viewModelDidLoad() {
        email = userModel.email
        output?(.setUserEmail(email: userModel.email ?? ""))
    }

    private func validateDataWithRegex() -> Bool {
        var isValid = true

        if email?.isValid(for: RegexConstants.emailRegex) ?? false {
            output?(.emailTextField(errorState: false, error: nil))
        } else {
            isValid = false
            output?(.emailTextField(errorState: true, error: StringConstants.ErrorString.emailError.localized))
        }

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
        case setUserEmail(email: String)
        case emailTextField(errorState: Bool, error: String?)
        case toDateTextField(errorState: Bool, error: String?)
        case fromDateTextField(errorState: Bool, error: String?)
        case setFromDateLimit(from: Date?, to: Date?)
        case setToDateLimit(from: Date?, to: Date?)
    }

    private func validateRequiredFields() {
        if email?.isBlank ?? true || toDate == nil || fromDate == nil {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
