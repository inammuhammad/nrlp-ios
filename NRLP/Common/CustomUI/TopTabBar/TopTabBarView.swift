//
//  TopTabBarView.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

protocol TopTabBarViewDelegate: AnyObject {
    func topTabBarView(selected index: Int)
}

class TopTabBarView: CustomNibView {
    
    private var selection = 0
    var titles = [String]()
    var disabled = [Int]()
    var delegate: TopTabBarViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    override func setupView() {
        super.setupView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.alwaysBounceHorizontal = false
        
        setupCollectionViewNibs()
    }
    
    private func setupCollectionViewNibs() {
        collectionView.register(nibName: "TopTabCell")
    }
}

extension TopTabBarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count // viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopTabCell", for: indexPath) as? TopTabCell
        cell?.populate(title: titles[indexPath.item], isSelected: indexPath.item == selection, isDisabled: disabled.contains(indexPath.item))
        return (cell) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !disabled.contains(indexPath.item) else { return }
        
        selection = indexPath.item
        delegate?.topTabBarView(selected: selection)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionViewWidth = collectionView.bounds.width
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionInset = flowLayout.sectionInset
            
            collectionViewWidth -= sectionInset.left
            collectionViewWidth -= sectionInset.right
        }
        
        let width = titles.count > 3 ? collectionViewWidth / 3.5 : collectionViewWidth / CGFloat(titles.count)
        
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
