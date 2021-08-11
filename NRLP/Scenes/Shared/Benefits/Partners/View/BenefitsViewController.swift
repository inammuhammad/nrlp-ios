//
//  BenefitsViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 13/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BenefitsViewController: BaseViewController {

    var viewModel: BenefitsViewModelProtocol!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "NRLP Redemption Partners".localized
            titleLabel.font = UIFont.init(commonFont: CommonFont.GaramondFontStyle.bold, size: .largeFontSize)
            titleLabel.textColor = UIColor.black
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    func setupUI() {
        self.title = "View NRLP Benefits".localized
    }
}

extension BenefitsViewController {

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.register(nibName: "BenefitsCardCell")
    }

    private func bindViewModel() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .dataReload:
                self.collectionView.reloadData()
            }
        }
    }
}

extension BenefitsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.getPartner(index: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BenefitsCardCell", for: indexPath) as? BenefitsCardCell
        cell?.populate(with: model)
        return (cell) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectOption(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width/2 - 6
        return CGSize(width: width, height: 150)
    }
}

extension BenefitsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.benefits
    }
}
