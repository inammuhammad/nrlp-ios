//
//  PopupViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 04/07/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias PopupViewModelOutput = (PopupViewModel.Output) -> Void

protocol PopupViewModelProtocol {
    var output: PopupViewModelOutput? { get set }
   
    func viewDidLoad()
    func didTapOkayButton()
}

class PopupViewModel: PopupViewModelProtocol {
    var output: PopupViewModelOutput?
    private let router: PopupRouter
    private let message: String

    init(router: PopupRouter, message: String) {
        self.router = router
        self.message = message
    }
    
    func viewDidLoad() {
        self.output?(.update(message: message))
    }

    func didTapOkayButton() {
        NRLPUserDefaults.shared.popupWindowSkipped(true)
        self.router.dismissToPreviousScreen()
    }
    
    enum Output {
        case update(message: String)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}
