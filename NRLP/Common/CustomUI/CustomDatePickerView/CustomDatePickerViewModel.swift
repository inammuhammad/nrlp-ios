import UIKit
import Foundation

protocol CustomDateViewModelProtocol {
    var minDate: Date { get set }
    
    func dateChanged(_ sender: UIDatePicker) -> String
}

struct CustomDatePickerViewModel: CustomDateViewModelProtocol {

    var minDate: Date
    
    func dateChanged(_ sender: UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: sender.date)
    }
}

protocol CustomDatePickerItemModel {
    var date: String { get set }
}
