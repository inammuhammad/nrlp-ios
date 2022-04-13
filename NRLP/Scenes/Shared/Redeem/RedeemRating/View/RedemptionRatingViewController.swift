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
    
    @IBOutlet weak var ratingTypeRadioButton: RadioButtonView! {
        didSet {
            ratingTypeRadioButton.alignment = .vertical
            ratingTypeRadioButton.setRadioButtonItems(items: viewModel.ratingTypeItemModel)
            ratingTypeRadioButton.setRadioItemSelected(at: 0, isSelected: true)
            ratingTypeRadioButton.didUpdatedSelectedItem = { [weak self] item in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.viewModel.ratingType = RedemptionRatingTypes(rawValue: item.key)
            }
        }
    }
    
    @IBOutlet weak var doneButton: PrimaryCTAButton! {
        didSet {
            doneButton.setTitle("Done".localized, for: .normal)
        }
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
            case .showActivityIndicator(show: let show):
                return
            case .showError(error: let error):
                return
            }
        }
    }
}

extension RedemptionRatingViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redemptionRating
    }
}
