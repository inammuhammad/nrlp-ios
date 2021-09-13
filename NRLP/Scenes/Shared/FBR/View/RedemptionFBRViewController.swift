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
    @IBOutlet weak var nextBtn: PrimaryCTAButton!
    @IBOutlet weak var cancelBtn: SecondaryCTAButton!
    
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
            }
        }
    }
    
}

extension RedemptionFBRViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redemptionFBR
    }
}
