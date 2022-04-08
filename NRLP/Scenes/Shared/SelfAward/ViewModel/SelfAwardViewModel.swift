////
////  TransactionTypeViewModel.swift
////  NRLP
////
////  Created by Muhammad Shahid Shakeel on 06/04/2022.
////
//
//import UIKit
//
//typealias SelfAwardViewModelOutput = (SelfAwardViewModel.Output) -> Void
//
//protocol SelfAwardViewModelProtocol {
////    var output: ReceiverTypeViewModelOutput? { get set }
//    var transactionTypeItemPickerViewModel: ItemPickerViewModel { get }
////
////    func viewDidLoad()
////    func didSelect(receiverType: RemitterReceiverTypePickerItemModel)
////    func nextButtonPressed()
//}
//
//class SelfAwardViewModel: SelfAwardViewModelProtocol {
//    
//    private var transactionType: TransactionType? {
//        didSet {
//            validateRequiredFields()
//        }
//    }
//
//    var transactionTypeItemPickerViewModel: ItemPickerViewModel {
//        return ItemPickerViewModel(
//            data: [
//                TransactionTypePickerItemModel(
//                    title: TransactionType.cnic.getTitle(),
//                    key: TransactionType.cnic.rawValue
//                ),
//                TransactionTypePickerItemModel(
//                    title: TransactionType.bank.getTitle(),
//                    key: TransactionType.bank.rawValue
//                )
//            ]
//        )
//    }
//
//    var output: SelfAwardViewModelOutput?
////
////    private var router: ReceiverTypeRouter
////
////    init(router: ReceiverTypeRouter) {
////        self.router = router
////    }
////
//    enum Output {
////        case showError(error: APIResponseError)
////        case showAlert(alert: AlertViewModel)
////        case showActivityIndicator(show: Bool)
////        case setNoteLbl(text: String)
//        case buttonState(enabled: Bool)
//        case setTransactionType(text: String)
//    }
////
////    func viewDidLoad() {
////        let text = "Note: You can add maximum 5 receivers.".localized
////        output?(.setNoteLbl(text: text))
////        output?(.buttonState(enabled: false))
////    }
////
////    func nextButtonPressed() {
////        guard let type = receiverType else { return }
////        router.navigateToReceiverFormScreen(receiverType: type)
////    }
//
//    func didSelect(transactionType: TransactionTypePickerItemModel) {
//        self.transactionType = transactionType.transactionType
//        output?(.setTransactionType(text: self.transactionType?.getTitle() ?? ""))
//    }
//
//    private func validateRequiredFields() {
//        if transactionType == nil {
//            output?(.buttonState(enabled: false))
//        } else {
//            output?(.buttonState(enabled: true))
//        }
//    }
//    
//    deinit {
//        print("I am getting deinit \(String(describing: self))")
//    }
//    
//}
