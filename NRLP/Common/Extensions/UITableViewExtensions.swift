//
//  UITableViewExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func register(nibForHeaderFooter: String) {
        register(nibForHeaderFooter: nibForHeaderFooter, withReuseIdentifier: nibForHeaderFooter)
    }

    func register(nibForHeaderFooter: String, withReuseIdentifier: String) {
        let nib = UINib(nibName: nibForHeaderFooter, bundle: .main)
        register(nib, forHeaderFooterViewReuseIdentifier: withReuseIdentifier)
    }

    func register(nibName: String) {
        register(nibName: nibName, withReuseCellIdentifier: nibName)
    }

    func register(nibName: String, withReuseCellIdentifier: String) {
        let nib = UINib(nibName: nibName, bundle: .main)
        register(nib, forCellReuseIdentifier: withReuseCellIdentifier)
    }

    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.0, animations: {
            self.reloadData()
        }, completion: { (_) in
            completion()
        })
    }

}

extension UITableView {

    /// Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("No XIB for UITableViewCell for \(String(describing: name)) found")
        }
        return cell
    }

    /// Register UITableViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    public func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
}
