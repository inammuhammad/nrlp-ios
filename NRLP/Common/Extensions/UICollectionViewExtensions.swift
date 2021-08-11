//
//  UICollectionViewExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func register(nibName: String) {
        register(nibName: nibName, withReuseCellIdentifier: nibName)
    }

    func registerSupplementaryView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: .main)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nibName)
    }

    func register(nibName: String, withReuseCellIdentifier: String) {
        let nib = UINib(nibName: nibName, bundle: .main)
        register(nib, forCellWithReuseIdentifier: withReuseCellIdentifier)
    }

    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {

        let lastSection = numberOfSections - 1
        let lastItem = numberOfItems(inSection: lastSection) - 1
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(indexPath: lastItemIndexPath, at: scrollPosition, animated: animated)
    }

    func scrollToItem(indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {

        guard indexPath.section >= 0,
            indexPath.section < numberOfSections else {  return }

        guard indexPath.row >= 0,
            indexPath.row < numberOfItems(inSection: indexPath.section) else { return }

        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }

    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.0, animations: {
            self.reloadData()
        }, completion: { (_) in
            completion()
        })
    }

}
