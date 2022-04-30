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
    
    private let categories = ["Complaint", "Activity", "Announcement"]
    
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
        
        self.title = "NotificationZ"
    }
    
    private func setupTopTabBarView() {
        self.topTabBarView.titles = categories
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
        collectionView.register(nibName: "NotificationsCategoryCollectionViewCell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsCategoryCollectionViewCell", for: indexPath) as? NotificationsCategoryCollectionViewCell
        
        return (cell) ?? UICollectionViewCell()
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
