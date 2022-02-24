//
//  ReceiverListingViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ReceiverListingViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: ReceiverListingViewModel!
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var receiverTable: UITableView!
    @IBOutlet private weak var noItemsView: UIView!
    @IBOutlet private weak var noItemsImg: UIImageView!
    @IBOutlet private weak var noItemsHeading: UILabel! {
        didSet {
            noItemsHeading.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
            noItemsHeading.text = "No Receiver Found.".localized
        }
    }

    @IBOutlet private weak var noItemsDescription: UILabel! {
        didSet {
            noItemsDescription.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
            noItemsDescription.text = "".localized
        }
    }

    @IBOutlet private weak var addReceiverButton: PrimaryCTAButton! {
        didSet {
            addReceiverButton.setTitle("Add Beneficiary".localized, for: .normal)
        }
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModelOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewModelWillAppear()
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        self.title = "Remittance Receiver Management".localized
        receiverTable.tableFooterView = UIView(frame: CGRect.zero)
        receiverTable.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupTableView() {
        receiverTable.delegate = self
        receiverTable.dataSource = self
        
        registerNib()
    }
    
    private func registerNib() {
        receiverTable.register(nibWithCellClass: BeneficiaryTableViewCell.self)
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showAlert(let alertViewModel):
                self.showAlert(with: alertViewModel)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .addButton(state: let state):
                DispatchQueue.main.async {
                    addReceiverButton.isEnabled = state
                }
            case .reloadReceivers:
                self.receiverTable.reloadData()
            case .tableVisibility(show: let show):
                DispatchQueue.main.async {
                    self.receiverTable.isHidden = !show
                    self.noItemsView.isHidden = show
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func addButtonClicked(_ sender: PrimaryCTAButton) {
        viewModel.addReceiverClicked()
    }

}

// MARK: Extension - UITableViewDelegate, UITableViewDataSource

extension ReceiverListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: BeneficiaryTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getReceiver(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectReceiver(indexPath: indexPath)
    }
}

// MARK: Extension - Initializable

extension ReceiverListingViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.receiverListing
    }
}
