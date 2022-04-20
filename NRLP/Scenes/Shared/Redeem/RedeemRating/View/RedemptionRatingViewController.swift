//
//  RedemptionRatingViewController.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class RedemptionRatingViewController: BaseViewController {
    
    var viewModel: RedemptionRatingViewModelProtocol!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Rate Your Redemption Experience".localized
            titleLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            titleLabel.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    
//    @IBOutlet weak var ratingTypeRadioButton: RadioButtonView! {
//        didSet {
//            ratingTypeRadioButton.alignment = .vertical
//            ratingTypeRadioButton.setRadioButtonItems(items: viewModel.ratingTypeItemModel)
//            ratingTypeRadioButton.setRadioItemSelected(at: 0, isSelected: true)
//            ratingTypeRadioButton.didUpdatedSelectedItem = { [weak self] item in
//                guard let self = self else { return }
//                self.view.endEditing(true)
//                self.viewModel.ratingType = RedemptionRatingTypes(rawValue: item.key)
//            }
//        }
//    }
    
    // Stars
    @IBOutlet weak var ratingStar1: UIImageView! {
        didSet {
            ratingStar1.tintColor = .lightGray
            ratingStar1.isUserInteractionEnabled = true
            ratingStar1.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(tappedStar1(_:)))
            )
        }
    }
    @IBOutlet weak var ratingStar2: UIImageView! {
        didSet {
            ratingStar2.tintColor = .lightGray
            ratingStar2.isUserInteractionEnabled = true
            ratingStar2.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(tappedStar2(_:)))
            )
        }
    }
    
    @IBOutlet weak var ratingStar3: UIImageView! {
        didSet {
            ratingStar3.tintColor = .lightGray
            ratingStar3.isUserInteractionEnabled = true
            ratingStar3.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(tappedStar3(_:)))
            )
        }
    }
    
    @IBOutlet weak var ratingStar4: UIImageView! {
        didSet {
            ratingStar4.tintColor = .lightGray
            ratingStar4.isUserInteractionEnabled = true
            ratingStar4.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(tappedStar4(_:)))
            )
        }
    }
    
    @IBOutlet weak var ratingStar5: UIImageView! {
        didSet {
            ratingStar5.tintColor = .lightGray
            ratingStar5.isUserInteractionEnabled = true
            ratingStar5.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(tappedStar5(_:)))
            )
        }
    }
    
    @IBOutlet weak var doneButton: PrimaryCTAButton! {
        didSet {
            doneButton.setTitle("Done".localized, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        bindViewModelOutput()
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .doneButtonState(state: let state):
                self.doneButton.isEnabled = state
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            }
        }
    }
    
//    @IBAction func doneButtonAction(_ sender: Any) {
//        viewModel.doneButtonPressed()
//    }
    
    @objc private func tappedStar1(_ sender: UIImageView) {
        ratingSelect(1)
    }
    
    @objc private func tappedStar2(_ sender: UIImageView) {
        ratingSelect(2)
    }
    
    @objc private func tappedStar3(_ sender: UIImageView) {
        ratingSelect(3)
    }
    
    @objc private func tappedStar4(_ sender: UIImageView) {
        ratingSelect(4)
    }
    
    @objc private func tappedStar5(_ sender: UIImageView) {
        ratingSelect(5)
    }
    
    private func ratingSelect(_ stars: Int) {
        ratingStar1.tintColor = stars > 0 ? UIColor(named: "FED501") : UIColor(named: "CCCCCC")
        ratingStar2.tintColor = stars > 1 ? UIColor(named: "FED501") : UIColor(named: "CCCCCC")
        ratingStar3.tintColor = stars > 2 ? UIColor(named: "FED501") : UIColor(named: "CCCCCC")
        ratingStar4.tintColor = stars > 3 ? UIColor(named: "FED501") : UIColor(named: "CCCCCC")
        ratingStar5.tintColor = stars > 4 ? UIColor(named: "FED501") : UIColor(named: "CCCCCC")
        
        viewModel.stars = stars
    }
}

extension RedemptionRatingViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redemptionRating
    }
}
