//
//  NotificationsViewController.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    var viewModel: NotificationsViewModelProtocol!
    
    private let categories = NotificationCategory.allCases // ["Complaint"] // , "Activity", "Announcement"]
    
    @IBOutlet private weak var topTabBarView: TopTabBarView! {
        didSet {
            setupTopTabBarView()
        }
    }
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.title = "Notifications"

        let view = UIView()
        let label = UILabel()
        label.text = "Notifications".localized
        label.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
        let imageView = UIImageView(image: UIImage(named: "bell"))
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        if AppConstants.isAppLanguageUrdu {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: imageView.topAnchor),
                view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                view.leftAnchor.constraint(equalTo: imageView.leftAnchor),
                
                view.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                view.rightAnchor.constraint(equalTo: label.rightAnchor),
                label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8)
            ])
        } else {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: imageView.topAnchor),
                view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                view.rightAnchor.constraint(equalTo: imageView.rightAnchor),
                
                view.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                view.leftAnchor.constraint(equalTo: label.leftAnchor),
                label.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -8)
            ])
        }
        
        self.navigationItem.titleView = view
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(error: let error):
                self.showAlert(with: error)
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            }
        }
    }
    
    private func setupTopTabBarView() {
        self.topTabBarView.titles = categories.map { $0.rawValue.localized }
        self.topTabBarView.disabled = [1, 2]
        self.topTabBarView.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.sectionInset = .zero
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.isPagingEnabled = true
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.alwaysBounceHorizontal = false
        
        collectionView.isScrollEnabled = false
        
        setupCollectionViewNibs()
    }
    
    private func setupCollectionViewNibs() {
        collectionView.register(nibName: "NotificationsCategoryCell")
    }
}

extension NotificationsViewController: TopTabBarViewDelegate {
    func topTabBarView(selected index: Int) {
        collectionView.scrollToItem(indexPath: IndexPath(item: index, section: 0))
        // collectionView.scrollToItem(indexPath: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
}

extension NotificationsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsCategoryCell", for: indexPath) as? NotificationsCategoryCell
        viewModel.populate(cell: cell, indexPath: indexPath)
        // cell?.populate(with: self.viewModel, category: .complaints)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
}

extension NotificationsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        .notifocations
    }
}
