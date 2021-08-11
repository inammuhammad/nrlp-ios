//
//  ErrorResponse.swift
//  1Link-NRLP
//
//  Created by VenD on 24/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import Alamofire

enum APIResponseError: Error {
    case internetOffline
    case sessionExpire
    case server(ErrorResponse?)
    case requestError(AFError?)
    case unknown
    case fileDownloadingFailed(AFError?)

    /// Error message.
    var message: String {
        switch self {
        case .internetOffline:
            return StringConstants.ErrorString.noInternetErrorMessage.localized
        case .server(let error):
            return error?.message  ?? StringConstants.ErrorString.generalErrorMessage.localized
        case .requestError(let error):
            return error?.localizedDescription ?? StringConstants.ErrorString.generalErrorMessage.localized
        case .sessionExpire:
            return StringConstants.ErrorString.sessionExpireMessage.localized
        case .unknown, .fileDownloadingFailed:
            return StringConstants.ErrorString.generalErrorMessage.localized
        }
    }

    var title: String {
        switch self {
        case .internetOffline:
            return StringConstants.ErrorString.noInternetErrorTitle.localized
        case .server, .requestError, .unknown, .sessionExpire, .fileDownloadingFailed:
            return StringConstants.ErrorString.serverErrorTitle.localized
        }
    }
    
    var illustrationImage: AlertIllustrationType {
        switch self {
        case .internetOffline:
            return .noInternet
        default:
            return .ohSnap
        }
    }

    var underlayingErrorCode: String? {
        switch self {
        case .server(let response):
            return response?.errorCode
        default:
            return nil
        }
    }

    /// Error code based on error
    var errorCode: Int {
        switch self {
        case .internetOffline:
            return 401
        default:
            return 500
        }
    }
}
