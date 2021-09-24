//
//  RedemptionFBRViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class RedemptionFBRViewController: BaseViewController {
    
    var viewModel: RedemptionFBRViewModelProtocol!
    
    @IBOutlet weak var pointsView: LoyaltyCardView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nextBtn: PrimaryCTAButton! {
        didSet {
            nextBtn.setTitle("Next".localized, for: .normal)
            nextBtn.setTitle("Next".localized, for: .selected)
            nextBtn.setTitle("Next".localized, for: .disabled)
            nextBtn.setTitle("Next".localized, for: .highlighted)
        }
    }
    @IBOutlet weak var cancelBtn: SecondaryCTAButton!{
        didSet {
            cancelBtn.setTitle("Cancel".localized, for: .normal)
            cancelBtn.setTitle("Cancel".localized, for: .selected)
            cancelBtn.setTitle("Cancel".localized, for: .disabled)
            cancelBtn.setTitle("Cancel".localized, for: .highlighted)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad()
        self.title = "Redeem".localized
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        viewModel.cancelButtonPressed()
    }
    
    private func bindViewModel() {
        self.viewModel.output = { [unowned self] output in
            switch output {
            case.updateLoyaltyPoints(viewModel: let viewModel):
                self.pointsView.populate(with: viewModel)
            case .setTitle(text: let text):
                titleLbl.text = text
            case .setDescription(text: let text):
                descLbl.text = text
            }
        }
    }
    
}

extension RedemptionFBRViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redemptionFBR
    }
}
