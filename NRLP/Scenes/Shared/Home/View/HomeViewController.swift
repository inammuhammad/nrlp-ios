//
//  HomeViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class HomeViewController: BaseViewController {
    var viewModel: HomeViewModelProtocol!
    weak var sideMenuDelegate: HomeSideMenuViewControllerDelegate!
    private lazy var notificationBellView: NotificationBellView = {
        var navBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        
        // normalise bell icon height
        navBarHeight *= 0.6

        let notificationBellView = NotificationBellView(
            title: "Notifications",
            frame: CGRect(origin: .zero, size: CGSize(width: navBarHeight * 1.25, height: navBarHeight))
        )
        notificationBellView.onTap = {
            self.notificationsBellTapped()
        }
        
        return notificationBellView
    }()

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.viewModelDidLoad()
        setupHamburgerItem()
        
        // FIXME: Test Code
        // notificationsBellTapped()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupHamburgerItem()
        viewModel.viewModelWillAppear()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        setupCollectionViewNibs()
    }

    private func setupCollectionViewNibs() {
        collectionView.register(nibName: "HomeCollectionViewCardCell")
        collectionView.register(nibName: "HomeCollectionViewLoyaltyCell")
//        collectionView.registerSupplementaryView(nibName: "HomeCollectionViewHeader")
    }
}

// Setup Navigaition Hamburger Menu
extension HomeViewController {
    private func setupHamburgerItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerIcon"), style: .plain, target: self, action: #selector(hamburgerButtonTapped))
        
        let rightBarButtonItem = UIBarButtonItem(customView: notificationBellView)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc
    private func hamburgerButtonTapped() {
        sideMenuDelegate.toggleNavigationPanel()
    }
    
    @objc
    private func notificationsBellTapped() {
        self.viewModel.notificationsBellTapped()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.getItem(at: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.cellIdentifier, for: indexPath) as? HomeCollectionViewCellProtocol
        cell?.populate(with: model, controller: self)
                
        return cell as? UICollectionViewCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = viewModel.getItem(at: indexPath.row).cellSize
        return CGSize(width: size.getCellWidth(), height: size.getCellHeight())
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView.numberOfItems(inSection: section) == 1 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: collectionView.frame.width - flowLayout.itemSize.width)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sideMenuDelegate.collapseSidePanel()
        viewModel.didTapItem(at: indexPath.row)
    }
}

extension HomeViewController {
    private func setupUI() {
        self.title = "Home".localized
    }

    private func bindViewModel() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .reloadCollectionView:
                self.collectionView.reloadData()
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .showLogoutAlert(let alertModel):
                self.showAlert(with: alertModel) {
                    self.requestReview()
                }
            case .showAlert(let alertModel):
                self.showAlert(with: alertModel)
            case .updateNotificationCount(let count):
                notificationBellView.count = count
                UIApplication.shared.applicationIconBadgeNumber = count
            case .showPopup(let message):
                PopupViewController.presentPopup(with: message, from: self) {
                    NRLPUserDefaults.shared.popupWindowSkipped(true)
                }
            }
        }
    }
}

extension HomeViewController: SideMenuNavigationDelegate {
    func didTapToNavigation(section item: SideMenuItem) {
        sideMenuDelegate.collapseSidePanel()
        viewModel.didTapSideMenu(item: item)
    }
}

extension HomeViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.home
    }
}

extension HomeViewController {
    private func requestReview() {
        SKStoreReviewController.requestReview()
    }
}
