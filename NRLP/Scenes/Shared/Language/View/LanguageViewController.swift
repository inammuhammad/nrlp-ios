//
//  LanguageViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 10/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class LanguageViewController: BaseViewController {

    var viewModel: LanguageViewModelProtocol!
    @IBOutlet weak var headingLabel: UILabel! {
        didSet {
            headingLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
            headingLabel.text = "Select your language you are comfortable to work with.".localized
        }
    }
    @IBOutlet private weak var saveCTAButton: PrimaryCTAButton! {
        didSet {
            saveCTAButton.setTitle("Save".localized, for: .normal)
        }
    }
    @IBOutlet weak var languageRadioGroup: RadioButtonView! {
        didSet {
            languageRadioGroup.alignment = .vertical
            languageRadioGroup.setRadioButtonItems(items: viewModel.languageItemModel)
            languageRadioGroup.didUpdatedSelectedItem = { [weak self] item in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.viewModel.selectedLanguage = item.key
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelOutput()
        viewModel.viewModelDidLoad()
        setupUI()
    }

    func setupUI() {
        self.title = "Language Selection".localized
    }
    
    @IBAction private func saveButtonPressed(_ sender: PrimaryCTAButton) {
        viewModel.didTapSaveButton()
    }
}

extension LanguageViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .setCurrentLanguageSelected(let index):
                self.languageRadioGroup.setRadioItemSelected(at: index, isSelected: true)
            case .showAlert(let alertViewModel):
                self.showAlert(with: alertViewModel)
            case .nextButtonState(let enableState):
                self.saveCTAButton.isEnabled = enableState
            }
        }
    }
}

extension LanguageViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return .language
    }
}
