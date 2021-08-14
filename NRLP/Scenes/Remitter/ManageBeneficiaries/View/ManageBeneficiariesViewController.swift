//
//  ManageBeneficiariesViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class ManageBeneficiariesViewController: BaseViewController {

    @IBOutlet private weak var beneficiaryTable: UITableView!
    @IBOutlet private weak var noItemsView: UIView!
    @IBOutlet private weak var noItemsImg: UIImageView!
    @IBOutlet private weak var noItemsHeading: UILabel! {
        didSet {
            noItemsHeading.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
            noItemsHeading.text = "No Beneficiary found.".localized
        }
    }

    @IBOutlet private weak var noItemsDescription: UILabel! {
        didSet {
            noItemsDescription.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
            noItemsDescription.text = "Add Beneficiaries to transfer the loyalty point with your loved ones".localized
        }
    }

    @IBOutlet private weak var addBeneficiaryButton: PrimaryCTAButton! {
        didSet {
            addBeneficiaryButton.setTitle("Add Beneficiary".localized, for: .normal)
        }
    }

    var viewModel: ManageBeneficiaryViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        bindViewModelOutput()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewModelWillAppear()
    }

    private func setupUI() {
        self.title = "Manage Beneficiary".localized
        beneficiaryTable.tableFooterView = UIView(frame: CGRect.zero)
        beneficiaryTable.separatorInset = UIEdgeInsets.zero
    }

    private func registerNib() {
        beneficiaryTable.register(nibWithCellClass: BeneficiaryTableViewCell.self)
    }

    private func setupTableView() {
        beneficiaryTable.delegate = self
        beneficiaryTable.dataSource = self
        registerNib()
    }

}

// MARK: BindViewModel and View binding
extension ManageBeneficiariesViewController {
    private func bindViewModelOutput() {
        viewModel.output = {  [unowned self] output in
            switch output {
            case .reloadBeneficiaries:
                self.beneficiaryTable.reloadData()
            case .showActivityIndicator(let show):
                    show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                    self.showAlert(with: error)
            case .tableVisibility(let show):
                DispatchQueue.main.async {
                    self.beneficiaryTable.isHidden = !show
                    self.noItemsView.isHidden = show
                }
            case .addButton(let enableState):
                DispatchQueue.main.async {
                    self.addBeneficiaryButton.isEnabled = enableState
                }
            }

        }
    }
}

// MARK: UITableView Delegate & DataSource
extension ManageBeneficiariesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: BeneficiaryTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getBeneficiary(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedBeneficiary(indexPath: indexPath)
    }
}

// MARK: IBActions
extension ManageBeneficiariesViewController {

    @IBAction
    private func addButtonClicked(_ sender: PrimaryCTAButton) {
        viewModel.addBeneficiaryClicked()
    }
}

extension ManageBeneficiariesViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.manageBeneficiaries
    }
}
