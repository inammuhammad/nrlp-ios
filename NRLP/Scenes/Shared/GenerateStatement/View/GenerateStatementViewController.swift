import UIKit

class GenerateStatementViewController: BaseViewController {

    var viewModel: GenerateStatementViewModelProtocol!

    @IBOutlet private weak var lblStatementTitle: UILabel! {
        didSet {
            lblStatementTitle.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
            lblStatementTitle.textColor = .black
            lblStatementTitle.text = "Generate Advance Statement".localized
        }
    }

//    @IBOutlet private weak var emailTextView: LabelledTextview! {
//        didSet {
//            emailTextView.titleLabelText = "Email Address".localized
//            emailTextView.placeholderText = "abc@abc.com".localized
////            emailTextView.inputFieldMaxLength = 50
//            emailTextView.editTextKeyboardType = .emailAddress
//            emailTextView.formatValidator = FormatValidator(regex: RegexConstants.emailRegex, invalidFormatError: StringConstants.ErrorString.emailError.localized)
//            emailTextView.onTextFieldChanged = { updatedText in
//                self.viewModel.email = updatedText
//            }
//        }
//    }

    @IBOutlet private weak var fromDateTextView: LabelledTextview! {
        didSet {
            fromDateTextView.titleLabelText = "From Date".localized
            fromDateTextView.placeholderText = "Select Date".localized
            fromDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            fromDateTextView.inputTextFieldInputPickerView = fromDatePicker
        }
    }

    @IBOutlet private weak var toDateTextView: LabelledTextview! {
        didSet {
            toDateTextView.titleLabelText = "To Date".localized
            toDateTextView.placeholderText = "Select Date".localized
            toDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            toDateTextView.inputTextFieldInputPickerView = toDatePicker
        }
    }

    @IBOutlet private weak var btnRequestStatement: PrimaryCTAButton! {
        didSet {
            btnRequestStatement.titleLabel?.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
//            btnRequestStatement.setTitle("Request Statement".localized, for: .normal)
            btnRequestStatement.setTitle("Next".localized, for: .normal)
        }
    }

    private lazy var toDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.datePickerViewModel
        return pickerView
    }()

    private lazy var fromDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.datePickerViewModel
        return pickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModelOutput()
        viewModel.viewModelDidLoad()
    }

    @IBAction
    private func didTapNextButton(_ sender: Any) {
        viewModel.nextButtonPressed()
    }

    private func setupUI() {
        self.title = "View More Transactions".localized
    }

}

// MARK: Setup View and Bindings
extension GenerateStatementViewController {
    private func bindViewModelOutput() {
        self.viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .updateToDate(let date):
                self.toDateTextView.inputText = date
            case .updateFromDate(let date):
                self.fromDateTextView.inputText = date
            case .nextButtonState(let state):
                self.btnRequestStatement.isEnabled = state
//            case .emailTextField(let errorState, let errorMsg):
//                self.emailTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .toDateTextField(let errorState, let errorMsg):
                self.toDateTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .fromDateTextField(let errorState, let errorMsg):
                self.fromDateTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .showError(let error):
                self.showAlert(with: error)
//            case .setUserEmail(let email):
//                self.emailTextView.inputText = email
            case .setFromDateLimit(let from, let to):
                if to != nil {
                    self.fromDatePicker.maximumDate = to
                }
                if from != nil {
                    self.fromDatePicker.minimumDate = from
                }
            case .setToDateLimit(let from, let to):
                if to != nil {
                    self.toDatePicker.maximumDate = to
                }
                if from != nil {
                    self.toDatePicker.minimumDate = from
                }

            case .sharePDF(url: let url):
                self.presentShareSheet(url)
            }
        }
    }
    
    private func presentShareSheet(_ url: URL) {        
        let shareSheet = UIActivityViewController(
            activityItems: [
                url
            ],
            applicationActivities: nil
        )
        self.present(shareSheet, animated: true)
    }
}

extension GenerateStatementViewController: CustomDatePickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

    func didTapDoneButton(picker: CustomDatePickerView, date: Date) {
        self.view.endEditing(true)
        switch picker {
        case self.toDatePicker:
            self.viewModel.toDate = date
        case self.fromDatePicker:
            self.viewModel.fromDate = date
        default:
            break
        }
    }
}

extension GenerateStatementViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.generateStatement
    }
}
