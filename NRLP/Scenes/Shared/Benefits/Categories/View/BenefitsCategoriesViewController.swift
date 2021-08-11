//
//  BenefitsCategoriesViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BenefitsCategoriesViewController: BaseViewController {

    var viewModel: BenefitsCategoriesViewModelProtocol!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "List of Benefits".localized
            titleLabel.font = UIFont.init(commonFont: CommonFont.GaramondFontStyle.bold, size: .largeFontSize)
            titleLabel.textColor = UIColor.black
        }
    }
    @IBOutlet private weak var partnerImage: UIImageView!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupView()
        viewModel.viewDidLoad()
    }
    
    func setupView() {
        self.title = "View NRLP Benefits".localized
        tableView.register(nibWithCellClass: BenefitCategoryCell.self)
    }
    
    func bindViewModel() {
        viewModel.output = { [unowned self] output in
            switch output {
            
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .dataReload:
                self.tableView.reloadData()
            case .updateView(let partner):
                if let img = partner.imageSrc.base64ToImage() {
                    self.partnerImage.image = img
                } else {
                    self.partnerImage.image = UIImage(named: "benefitsPlaceholder")
                }
            }
        }
    }
}

extension BenefitsCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: BenefitCategoryCell.self, for: indexPath)
        cell.populate(with: viewModel.getCategory(index: indexPath.row))
        return cell
    }
}

extension BenefitsCategoriesViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.benefitsCategories
    }
}
