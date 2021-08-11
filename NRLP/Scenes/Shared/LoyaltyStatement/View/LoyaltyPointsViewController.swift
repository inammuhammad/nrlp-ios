//
//  LoyaltyPointsViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class LoyaltyPointsViewController: BaseViewController {
    
    var viewModel: LoyaltyPointsViewModelProtocol!
    @IBOutlet private weak var lastStatementsLabel: UILabel! {
        didSet {
            lastStatementsLabel.text = "Last 10 Statements".localized
            lastStatementsLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
        }
    }
    @IBOutlet private weak var advanceStatementButton: SecondaryCTAButton! {
        didSet {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize),
                .foregroundColor: UIColor.init(commonColor: .appGreen)]
            let attributeString = NSMutableAttributedString(string: "View More Transactions".localized, attributes: attributes)
            advanceStatementButton.setAttributedTitle(attributeString, for: .normal)
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loyaltyPointsView: LoyaltyCardView!
    
    @IBOutlet private weak var notFoundView: UIView!
    @IBOutlet private weak var notFoundHeading: UILabel! {
        didSet {
            notFoundHeading.text = "No Data Found".localized
            notFoundHeading.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
        }
    }
    @IBOutlet private weak var notFoundDescription: UILabel! {
        didSet {
            notFoundDescription.text = "Please perform transactions and come back!".localized
            notFoundDescription.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModelOutput()
        viewModel?.viewModelDidLoad()
    }
    
    private func setupUI() {
        self.title = "View Statement".localized
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(nibWithCellClass: LoyaltyPointsTableViewCell.self)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        //        self.tableView.separatorInset = UIEdgeInsets.zero
    }
    
    @IBAction
    private func advanceStatementButtonPressed(_ sender: SecondaryCTAButton) {
        self.viewModel.goToAdvanceStatement()
    }
    
}

extension LoyaltyPointsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfStatement ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoyaltyPointsTableViewCell") as! LoyaltyPointsTableViewCell
        cell.populate(with: viewModel.getStatement(at: indexPath.row))
        return cell
    }
}

// MARK: BindViewModel and View binding
extension LoyaltyPointsViewController {
    private func bindViewModelOutput() {
        viewModel.output = {  [unowned self] output in
            switch output {
            case .showActivityIndicator(let show):
                DispatchQueue.main.async {
                    show ? ProgressHUD.show() : ProgressHUD.dismiss()
                }
            case .showError(let error):
                DispatchQueue.main.async {
                    self.showAlert(with: error)
                }
            case .reloadStatements:
                self.tableView.reloadData()
            case .updateLoyaltyCard(let viewModel):
                self.loyaltyPointsView.populate(with: viewModel)
            case .showTable(let show):
                self.notFoundView.isHidden = show
                self.tableView.isHidden = !show
                //self.advanceStatementButton.isHidden = !show
                self.loyaltyPointsView.isHidden = !show
            }
        }
    }
}

extension LoyaltyPointsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.loyaltyPoints
    }
}
