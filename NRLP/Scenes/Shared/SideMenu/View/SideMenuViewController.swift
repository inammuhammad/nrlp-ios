//
//  SideMenuViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

protocol SideMenuNavigationDelegate: class {
    func didTapToNavigation(section item: SideMenuItem)
}

class SideMenuViewController: BaseViewController {

    weak var sideMenuNavigationDelegate: SideMenuNavigationDelegate!
    var viewModel: SideMenuViewModelProtocol!

    @IBOutlet private weak var versionNumberLabel: UILabel! {
        didSet {
            versionNumberLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .smallFontSize)
        }
    }
    @IBOutlet private weak var poweredByLabel: UILabel! {
        didSet {
            poweredByLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            poweredByLabel.text = "Powered by".localized
        }
    }
    @IBOutlet private weak var sideMenuTopView: UIView! {
        didSet {
            sideMenuTopView.backgroundColor = UIColor.init(commonColor: .appBottomBorderViewShadow)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.isUserInteractionEnabled = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: SideMenuTableViewCell.self)
    }

    override
    func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewModelDidLoad()
    }
}

//BindViewModel
extension SideMenuViewController {
    private func bindViewModel() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .navigateToSection(let item):
                self.sideMenuNavigationDelegate.didTapToNavigation(section: item)
            case .updateVersionNumber(let version):
                self.versionNumberLabel.text = version
            }
        }
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewHeader = SideMenuTableViewHeader()
        tableViewHeader.populate(with: viewModel.sectionHeaderModel)
        return tableViewHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        90
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SideMenuTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getItem(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.isUserInteractionEnabled = false
        viewModel.didTapItem(at: indexPath.row)
    }
}

extension SideMenuViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.sideMenu
    }
}
