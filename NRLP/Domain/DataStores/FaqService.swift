//
//  FaqService.swift
//  1Link-NRLP
//
//  Created by VenD on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias FAQServiceCallBack = (Result<FaqResponseModel, APIResponseError>) -> Void

protocol FAQServiceProtocol {

    func fetchFAQ(completion: @escaping FAQServiceCallBack)
}

class FAQService: BaseDataStore, FAQServiceProtocol {
    func fetchFAQ(completion: @escaping FAQServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

//        let response = FaqResponseModel(message: "success", data: FAQQuestions(questions: [
//            FaqQuestion(question: "This is question 1", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 2", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 3", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum"),
//            FaqQuestion(question: "This is question 4", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 5", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 6", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 7", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum"),
//            FaqQuestion(question: "This is question 8", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 9", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 10", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum"),
//            FaqQuestion(question: "This is question 11", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum."),
//            FaqQuestion(question: "This is question 12", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum.")
//        ]))
//        completion(.success(response))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .faqs), parameters: FAQRequestModel(), shouldHash: false)
        networking.get(request: request) { (response: APIResponse<FaqResponseModel>) in

            completion(response.result)
        }
    }
}
