import UIKit
import Foundation

protocol CustomDatePickerViewDelegate: class {
    func didTapCancelButton()
    func didTapDoneButton(picker: CustomDatePickerView, date: Date)
//    func didTapDoneButton(picker: CustomDatePickerView, date: String)
}

protocol PickerToolbarProtocol {
    var toolbar: UIToolbar? { get }
}

class CustomDatePickerView: UIDatePicker, PickerToolbarProtocol {

    private(set) var toolbar: UIToolbar?
    weak var toolbarDelegate: CustomDatePickerViewDelegate?
    var isRegistration: Bool?
    var isSelfAward: Bool?
    
    var viewModel: CustomDatePickerViewModel! {
        didSet {
            if isRegistration ?? false  {
                self.maximumDate = viewModel.maxDate
            } else if isSelfAward ?? false {
                self.minimumDate = viewModel.minDate
                self.maximumDate = viewModel.maxDate
            } else {
                self.minimumDate = viewModel?.minDate
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
        setupPicker()
    }

    private func setupPicker() {
        self.datePickerMode = .date
        if #available(iOS 13.4, *) {
            self.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.maximumDate = Date()
    }

    @objc func doneTapped() {
        toolbarDelegate?.didTapDoneButton(picker: self, date: self.date)
    }

    @objc func cancelTapped() {
        toolbarDelegate?.didTapCancelButton()
    }
}
