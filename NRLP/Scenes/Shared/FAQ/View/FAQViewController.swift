//
//  FAQViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController {

    var viewModel: FAQViewModelProtocol!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.viewModelDidLoad()
    }

    private func setupTableView() {
        tableView.register(nibWithCellClass: FAQItemTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupView() {
        self.title = "FAQs".localized
    }
}

extension FAQViewController {
    //bindViewModel
    private func bindViewModel() {
        viewModel.faqOutput = { [unowned self] output in
            switch output {
            case .reloadData:
                self.tableView.reloadData()
            case .showError(let error):
                self.showAlert(with: error)
            case .showProgressHud(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .reloadCell(let index):
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfFaqs
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withClass: FAQItemTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getFaq(for: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapFaq(at: indexPath.row)
    }
}

extension FAQViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.faq
    }
}
