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
    
    @IBOutlet private weak var topTabBarView: TopTabBarView! {
        didSet {
            setupTopTabBarView()
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            
        }
    }
    
    @IBOutlet private weak var stackView: UIStackView! {
        didSet {
            
        }
    }
    
    private let categories = NotificationCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelOutput()
        configTitleView()
        configCategories()
        
        self.scrollView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        )
    }
    
    private func configTitleView() {
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
    
    private func configCategories() {
        assert(stackView.subviews.count == categories.count)
        
        for i in 0..<categories.count {
            guard let view = stackView.subviews[i] as? NotificationsCategoryView else {
                break
            }
            
            viewModel.populate(view: view, index: i)
        }
    }
    
    @objc private func screenTapped() {
        for view in stackView.subviews {
            guard let view = view as? NotificationsCategoryView else {
                return
            }
            
            view.resetSelection()
        }
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
        // self.topTabBarView.disabled = [1, 2]
        self.topTabBarView.delegate = self
    }
    
    private func scrollTo(index: Int) {
        let width = scrollView.bounds.width
        let contentOffsetX = CGFloat(index) * width
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: false)
    }
}

extension NotificationsViewController: TopTabBarViewDelegate {
    func topTabBarView(selected index: Int) {
        for view in stackView.subviews {
            guard let view = view as? NotificationsCategoryView else {
                return
            }
            
            view.resetSelection()
        }
        scrollTo(index: index)
    }
}

extension NotificationsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        .notifocations
    }
}
