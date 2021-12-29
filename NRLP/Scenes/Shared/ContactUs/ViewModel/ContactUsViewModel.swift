import UIKit
import Foundation

typealias ContactUsViewModelOutput = (ContactUsViewModel.Output) -> Void

protocol ContactUsViewModelProtocol {
    var output: ContactUsViewModelOutput? {get set}
    var numberOfRows: Int {get}
    func didSelectOption(index: Int)
    func viewDidLoad()
    func getItem(index: Int) -> ContactItem
}

enum ContactUsItem: Int {
    case callUs = 0
    case email
    case visitWeb
    
    var image: UIImage {
        switch self {
        case .callUs:
            return #imageLiteral(resourceName: "contactIcon")
        case .email:
            return #imageLiteral(resourceName: "email-icon")
        case .visitWeb:
            return #imageLiteral(resourceName: "public-icon")
        }
    }
    
    var title: String {
        switch self {
        case .callUs:
            return "Call Us".localized
        case .email:
            return "Send us an email".localized
        case .visitWeb:
            return "Visit our website".localized
        }
    }
    
    var description: String {
        switch self {
        case .callUs:
            return "+92 21 111 116 757"
        case .email:
            return "sdrpsupport@1link.net.pk"
        case .visitWeb:
            return "www.NRLP.com.pk"
        }
    }
    
    var actionContent: String {
        switch self {
        case .callUs:
            return "+9221111116757"
        case .email:
            return "sdrpsupport@1link.net.pk"
        case .visitWeb:
            return "https://www.nrlp.com.pk/"
        }
    }
}

class ContactUsViewModel: ContactUsViewModelProtocol {
    
    var output: ContactUsViewModelOutput?
    private var items: [ContactItem] = [
        ContactItem(with: ContactUsItem.callUs),
        ContactItem(with: ContactUsItem.email)]
//        ContactItem(with: ContactUsItem.visitWeb) ]
    
    func getItem(index: Int) -> ContactItem {
        return items[index]
    }
    
    var numberOfRows: Int {
        return items.count
    }
    
    func viewDidLoad() {
        output?(.dataReload)
    }
    
    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: AlertViewModel)
        case dataReload
    }
    
    func didSelectOption(index: Int) {
        var errorModel = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: StringConstants.ErrorString.serverErrorTitle.localized, alertDescription: "", primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil))
        switch index {
        case ContactUsItem.callUs.rawValue:
            AppUtility.goToDialer(phoneNumber: items[index].contact) { (error) in
                errorModel.alertDescription = error
                output?(.showError(error: errorModel))
            }
        case ContactUsItem.email.rawValue:
            AppUtility.goToEmail(email: items[index].contact) { (error) in
                errorModel.alertDescription = error
                output?(.showError(error: errorModel))
            }
        case ContactUsItem.visitWeb.rawValue:
            AppUtility.goToWebsite(url: items[index].contact) { (error) in
                errorModel.alertDescription = error
                output?(.showError(error: errorModel))
            }
        default:
            break
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.output?(.dataReload)
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

struct ContactItem {
    var image: UIImage {
        return contactUsItem.image
    }
    var title: String {
        return contactUsItem.title
    }
    var displayContact: String {
        return contactUsItem.description
    }
    var contact: String {
        return contactUsItem.actionContent
    }
    
    private var contactUsItem: ContactUsItem
    
    init(with contactUsItem: ContactUsItem) {
        self.contactUsItem = contactUsItem
    }
}
