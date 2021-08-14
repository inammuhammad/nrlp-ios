//
//  FAQViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias FAQViewModelOutput = (FAQViewModel.Output) -> Void

protocol FAQViewModelProtocol {
    var numberOfFaqs: Int { get }
    var faqOutput: FAQViewModelOutput? { get set }
    func getFaq(for index: Int) -> FAQItemViewModel
    func didTapFaq(at index: Int)
    func viewModelDidLoad()
}

class FAQViewModel: FAQViewModelProtocol {
    private var faqItemModel: [FAQItemViewModel] = []
    var faqOutput: FAQViewModelOutput?
    private var service: FAQServiceProtocol

    var numberOfFaqs: Int {
        return faqItemModel.count
    }

    init(with service: FAQServiceProtocol = FAQService()) {
        self.service = service
    }

    func getFaq(for index: Int) -> FAQItemViewModel {
        return faqItemModel[index]
    }

    func viewModelDidLoad() {
        fetchFAQs()
    }

    private func fetchFAQs() {
        faqOutput?(.showProgressHud(show: true))
        service.fetchFAQ { [weak self] (response) in
            guard let self = self else { return }
            self.faqOutput?(.showProgressHud(show: false))
            switch response {
            case .success(let faqs):
                self.faqItemModel = faqs.data.questions.map({ (faq) -> FAQItemViewModel in
                    return FAQItemViewModel(faq: faq)
                })
                self.faqOutput?(.reloadData)
            case .failure(let error):
                self.faqOutput?(.showError(error: error))
            }
        }
    }

    private func getPreExpandedItemIndex() -> [Int] {
        var preExpandedItemIndex: [Int] = []
        for index in 0..<faqItemModel.count {
            let item = faqItemModel[index]
            if item.faqExpandState != .collapsed {
                preExpandedItemIndex.append(index)
            }
        }
        return preExpandedItemIndex
    }

    private func collapseAllItemExceptCurrentExpanded(at indexes: [Int]) {
        for index in indexes where faqItemModel[index].faqExpandState != .shouldCollapse {
            faqItemModel[index].faqExpandState = .collapsed
            faqOutput?(.reloadCell(index: index))
        }
    }

    func didTapFaq(at index: Int) {
        let preExpandedIndex = getPreExpandedItemIndex()
        faqItemModel[index].faqExpandState = faqItemModel[index].faqExpandState == .expanded ? .shouldCollapse : .shouldExpand
        faqOutput?(.reloadCell(index: index))
        collapseAllItemExceptCurrentExpanded(at: preExpandedIndex)
        faqItemModel[index].faqExpandState = faqItemModel[index].faqExpandState == .shouldCollapse ? .collapsed : .expanded
    }

    enum Output {
        case showProgressHud(show: Bool)
        case reloadData
        case reloadCell(index: Int)
        case showError(error: APIResponseError)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
