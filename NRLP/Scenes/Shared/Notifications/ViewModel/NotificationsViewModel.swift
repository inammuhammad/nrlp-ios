//
//  NotificationsViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias NotificationsViewModelOutput = (NotificationsViewModel.Output) -> Void

protocol NotificationsViewModelProtocol {
    var output: NotificationsViewModelOutput? { get set }
}

class NotificationsViewModel: NotificationsViewModelProtocol {
    var output: NotificationsViewModelOutput?
    
    enum Output {
        
    }
}
